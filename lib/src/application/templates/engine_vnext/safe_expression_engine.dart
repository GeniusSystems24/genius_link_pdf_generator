
/// Restricted expression engine for S22.
///
/// The grammar supports literals, null-safe nested map access, arithmetic,
/// comparisons, boolean operators, null coalescing and a small allow-list of
/// functions. It never invokes reflection, dynamic methods, or arbitrary user code.
class GeniusPdfSafeExpressionEngine {
  const GeniusPdfSafeExpressionEngine({
    this.maxTokens = 4096,
    this.maxDepth = 64,
  });

  final int maxTokens;
  final int maxDepth;

  Object? evaluate(
    String expression,
    Map<String, Object?> context, {
    Map<String, String> localization = const {},
  }) {
    final tokenizer = _Tokenizer(expression, maxTokens: maxTokens);
    final parser = _Parser(
      tokenizer.tokens,
      context,
      localization,
      maxDepth: maxDepth,
    );
    final value = parser.parse();
    parser.expectEnd();
    return value;
  }

  /// Safe nested property access. Missing/null segments return null.
  Object? resolvePath(
    String path,
    Map<String, Object?> context,
  ) =>
      _resolvePath(path, context);
}

enum _TokenKind {
  number,
  string,
  identifier,
  operatorToken,
  leftParen,
  rightParen,
  comma,
  eof,
}

class _Token {
  const _Token(
    this.kind,
    this.lexeme, [
    this.literal,
  ]);

  final _TokenKind kind;
  final String lexeme;
  final Object? literal;
}

class _Tokenizer {
  _Tokenizer(
    this.source, {
    required this.maxTokens,
  }) {
    _scan();
  }

  final String source;
  final int maxTokens;
  final List<_Token> tokens = [];
  int _index = 0;

  void _scan() {
    while (_index < source.length) {
      _skipWhitespace();
      if (_index >= source.length) break;

      final start = _index;
      final char = source[_index];

      if (_isDigit(char) ||
          (char == '.' &&
              _index + 1 < source.length &&
              _isDigit(source[_index + 1]))) {
        _number(start);
      } else if (char == '"' || char == "'") {
        _string(char);
      } else if (_isIdentifierStart(char)) {
        _identifier(start);
      } else {
        switch (char) {
          case '(':
            _add(_Token(_TokenKind.leftParen, char));
            _index++;
            break;
          case ')':
            _add(_Token(_TokenKind.rightParen, char));
            _index++;
            break;
          case ',':
            _add(_Token(_TokenKind.comma, char));
            _index++;
            break;
          default:
            _operator();
            break;
        }
      }
    }
    _add(const _Token(_TokenKind.eof, ''));
  }

  void _skipWhitespace() {
    while (_index < source.length &&
        source[_index].trim().isEmpty) {
      _index++;
    }
  }

  void _number(int start) {
    var hasDot = false;
    while (_index < source.length) {
      final char = source[_index];
      if (_isDigit(char)) {
        _index++;
        continue;
      }
      if (char == '.' && !hasDot) {
        hasDot = true;
        _index++;
        continue;
      }
      break;
    }
    final lexeme = source.substring(start, _index);
    final value = num.tryParse(lexeme);
    if (value == null) {
      throw FormatException('Invalid number `$lexeme`.');
    }
    _add(_Token(_TokenKind.number, lexeme, value));
  }

  void _string(String quote) {
    _index++;
    final buffer = StringBuffer();
    var closed = false;
    while (_index < source.length) {
      final char = source[_index++];
      if (char == quote) {
        closed = true;
        break;
      }
      if (char == '\\' && _index < source.length) {
        final escaped = source[_index++];
        switch (escaped) {
          case 'n':
            buffer.write('\n');
            break;
          case 'r':
            buffer.write('\r');
            break;
          case 't':
            buffer.write('\t');
            break;
          default:
            buffer.write(escaped);
        }
      } else {
        buffer.write(char);
      }
    }
    if (!closed) {
      throw const FormatException(
        'Unterminated string literal.',
      );
    }
    _add(
      _Token(
        _TokenKind.string,
        buffer.toString(),
        buffer.toString(),
      ),
    );
  }

  void _identifier(int start) {
    _index++;
    while (_index < source.length &&
        _isIdentifierPart(source[_index])) {
      _index++;
    }
    final lexeme = source.substring(start, _index);
    _add(_Token(_TokenKind.identifier, lexeme));
  }

  void _operator() {
    const allowed = <String>{
      '&&',
      '||',
      '==',
      '!=',
      '>=',
      '<=',
      '??',
      '+',
      '-',
      '*',
      '/',
      '%',
      '>',
      '<',
      '!',
    };

    final two = _index + 1 < source.length
        ? source.substring(_index, _index + 2)
        : '';
    if (allowed.contains(two)) {
      _add(_Token(_TokenKind.operatorToken, two));
      _index += 2;
      return;
    }

    final one = source[_index];
    if (allowed.contains(one)) {
      _add(_Token(_TokenKind.operatorToken, one));
      _index++;
      return;
    }

    throw FormatException(
      'Unsupported character `${source[_index]}` '
      'at $_index.',
    );
  }

  void _add(_Token token) {
    tokens.add(token);
    if (tokens.length > maxTokens) {
      throw StateError(
        'Expression exceeds token limit $maxTokens.',
      );
    }
  }

  bool _isDigit(String value) =>
      value.codeUnitAt(0) >= 48 && value.codeUnitAt(0) <= 57;

  bool _isIdentifierStart(String value) {
    final code = value.codeUnitAt(0);
    return value == '_' ||
        value == r'$' ||
        (code >= 65 && code <= 90) ||
        (code >= 97 && code <= 122);
  }

  bool _isIdentifierPart(String value) =>
      _isIdentifierStart(value) ||
      _isDigit(value) ||
      value == '.';
}

class _Parser {
  _Parser(
    this.tokens,
    this.context,
    this.localization, {
    required this.maxDepth,
  });

  final List<_Token> tokens;
  final Map<String, Object?> context;
  final Map<String, String> localization;
  final int maxDepth;
  int _current = 0;
  int _depth = 0;

  Object? parse() => _guard(_coalesce);

  void expectEnd() {
    if (_peek.kind != _TokenKind.eof) {
      throw FormatException(
        'Unexpected token `${_peek.lexeme}`.',
      );
    }
  }

  Object? _coalesce() {
    var left = _or();
    while (_matchOperator('??')) {
      final right = _or();
      left ??= right;
    }
    return left;
  }

  Object? _or() {
    var left = _and();
    while (_matchOperator('||')) {
      final right = _and();
      left = _asBool(left) || _asBool(right);
    }
    return left;
  }

  Object? _and() {
    var left = _equality();
    while (_matchOperator('&&')) {
      final right = _equality();
      left = _asBool(left) && _asBool(right);
    }
    return left;
  }

  Object? _equality() {
    var left = _comparison();
    while (_matchOperator('==') ||
        _matchOperator('!=')) {
      final op = _previous.lexeme;
      final right = _comparison();
      left = op == '==' ? left == right : left != right;
    }
    return left;
  }

  Object? _comparison() {
    var left = _additive();
    while (_matchAny(const ['>', '>=', '<', '<='])) {
      final op = _previous.lexeme;
      final right = _additive();
      final comparison = _compare(left, right);
      left = switch (op) {
        '>' => comparison > 0,
        '>=' => comparison >= 0,
        '<' => comparison < 0,
        '<=' => comparison <= 0,
        _ => false,
      };
    }
    return left;
  }

  Object? _additive() {
    var left = _multiplicative();
    while (_matchAny(const ['+', '-'])) {
      final op = _previous.lexeme;
      final right = _multiplicative();

      if (op == '+' &&
          (left is String || right is String)) {
        left = '${left ?? ''}${right ?? ''}';
      } else {
        final a = _asNum(left);
        final b = _asNum(right);
        left = op == '+' ? a + b : a - b;
      }
    }
    return left;
  }

  Object? _multiplicative() {
    var left = _unary();
    while (_matchAny(const ['*', '/', '%'])) {
      final op = _previous.lexeme;
      final right = _unary();
      final a = _asNum(left);
      final b = _asNum(right);
      left = switch (op) {
        '*' => a * b,
        '/' => b == 0
            ? throw const FormatException(
                'Division by zero.',
              )
            : a / b,
        '%' => b == 0
            ? throw const FormatException(
                'Modulo by zero.',
              )
            : a % b,
        _ => 0,
      };
    }
    return left;
  }

  Object? _unary() {
    if (_matchOperator('!')) {
      return !_asBool(_unary());
    }
    if (_matchOperator('-')) {
      return -_asNum(_unary());
    }
    if (_matchOperator('+')) {
      return _asNum(_unary());
    }
    return _primary();
  }

  Object? _primary() {
    if (_matchKind(_TokenKind.number) ||
        _matchKind(_TokenKind.string)) {
      return _previous.literal;
    }

    if (_matchKind(_TokenKind.identifier)) {
      final name = _previous.lexeme;
      if (name == 'true') return true;
      if (name == 'false') return false;
      if (name == 'null') return null;

      if (_matchKind(_TokenKind.leftParen)) {
        final args = <Object?>[];
        if (!_checkKind(_TokenKind.rightParen)) {
          do {
            args.add(_guard(_coalesce));
          } while (_matchKind(_TokenKind.comma));
        }
        _consume(
          _TokenKind.rightParen,
          'Expected `)` after function arguments.',
        );
        return _call(name, args);
      }

      return _resolvePath(name, context);
    }

    if (_matchKind(_TokenKind.leftParen)) {
      final value = _guard(_coalesce);
      _consume(
        _TokenKind.rightParen,
        'Expected `)` after expression.',
      );
      return value;
    }

    throw FormatException(
      'Expected value at `${_peek.lexeme}`.',
    );
  }

  Object? _call(
    String name,
    List<Object?> args,
  ) {
    switch (name) {
      case 'coalesce':
        for (final value in args) {
          if (value != null) return value;
        }
        return null;
      case 'len':
      case 'count':
        _arity(name, args, 1);
        final value = args.single;
        if (value == null) return 0;
        if (value is String) return value.length;
        if (value is Iterable) return value.length;
        if (value is Map) return value.length;
        throw FormatException('$name() expects String/List/Map.');
      case 'sum':
        _arityRange(name, args, 1, 2);
        return _aggregate(
          args[0],
          args.length == 2 ? args[1]?.toString() : null,
          'sum',
        );
      case 'avg':
        _arityRange(name, args, 1, 2);
        return _aggregate(
          args[0],
          args.length == 2 ? args[1]?.toString() : null,
          'avg',
        );
      case 'min':
        _arityRange(name, args, 1, 2);
        return _aggregate(
          args[0],
          args.length == 2 ? args[1]?.toString() : null,
          'min',
        );
      case 'max':
        _arityRange(name, args, 1, 2);
        return _aggregate(
          args[0],
          args.length == 2 ? args[1]?.toString() : null,
          'max',
        );
      case 'groupSum':
        _arity(name, args, 3);
        return _groupSum(
          args[0],
          args[1]?.toString() ?? '',
          args[2]?.toString() ?? '',
        );
      case 'format':
        _arity(name, args, 2);
        return _format(
          args[0],
          args[1]?.toString() ?? '',
        );
      case 't':
        _arity(name, args, 1);
        final key = args.single?.toString() ?? '';
        return localization[key] ?? key;
      default:
        throw FormatException(
          'Function `$name` is not allowed.',
        );
    }
  }

  Object _aggregate(
    Object? source,
    String? path,
    String operation,
  ) {
    if (source is! Iterable) {
      throw FormatException(
        '$operation() expects a list.',
      );
    }

    final values = <num>[];
    for (final item in source) {
      final value = path == null
          ? item
          : item is Map
              ? _resolvePath(
                  path,
                  Map<String, Object?>.from(item),
                )
              : null;
      if (value == null) continue;
      values.add(_asNum(value));
    }

    if (operation == 'sum') {
      return values.fold<num>(0, (a, b) => a + b);
    }
    if (values.isEmpty) return 0;
    if (operation == 'avg') {
      return values.fold<num>(0, (a, b) => a + b) /
          values.length;
    }
    if (operation == 'min') {
      return values.reduce((a, b) => a <= b ? a : b);
    }
    if (operation == 'max') {
      return values.reduce((a, b) => a >= b ? a : b);
    }
    throw FormatException('Unknown aggregate `$operation`.');
  }

  Map<String, num> _groupSum(
    Object? source,
    String groupPath,
    String valuePath,
  ) {
    if (source is! Iterable) {
      throw const FormatException(
        'groupSum() expects a list.',
      );
    }
    final result = <String, num>{};
    for (final item in source) {
      if (item is! Map) continue;
      final map = Map<String, Object?>.from(item);
      final group =
          _resolvePath(groupPath, map)?.toString() ?? '';
      final value = _resolvePath(valuePath, map);
      if (value == null) continue;
      result[group] =
          (result[group] ?? 0) + _asNum(value);
    }
    return result;
  }

  String _format(
    Object? value,
    String spec,
  ) {
    if (value == null) return '';
    if (spec.startsWith('number:')) {
      final precision =
          int.tryParse(spec.substring('number:'.length)) ?? 2;
      return _asNum(value).toDouble().toStringAsFixed(precision);
    }
    if (spec.startsWith('money:')) {
      final currency = spec.substring('money:'.length);
      return '${_asNum(value).toDouble().toStringAsFixed(2)} $currency';
    }
    if (spec == 'upper') return value.toString().toUpperCase();
    if (spec == 'lower') return value.toString().toLowerCase();
    return value.toString();
  }

  T _guard<T>(T Function() callback) {
    _depth++;
    if (_depth > maxDepth) {
      _depth--;
      throw StateError(
        'Expression nesting exceeds $maxDepth.',
      );
    }
    try {
      return callback();
    } finally {
      _depth--;
    }
  }

  num _asNum(Object? value) {
    if (value is num) return value;
    final parsed = num.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      throw FormatException(
        'Expected numeric value, got `$value`.',
      );
    }
    return parsed;
  }

  bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value == null) return false;
    if (value is num) return value != 0;
    if (value is String) return value.isNotEmpty;
    return true;
  }

  int _compare(Object? left, Object? right) {
    if (left is num || right is num) {
      return _asNum(left).compareTo(_asNum(right));
    }
    return (left?.toString() ?? '')
        .compareTo(right?.toString() ?? '');
  }

  void _arity(
    String name,
    List<Object?> args,
    int expected,
  ) {
    if (args.length != expected) {
      throw FormatException(
        '$name() expects $expected argument(s); '
        'got ${args.length}.',
      );
    }
  }

  void _arityRange(
    String name,
    List<Object?> args,
    int min,
    int max,
  ) {
    if (args.length < min || args.length > max) {
      throw FormatException(
        '$name() expects $min..$max arguments; '
        'got ${args.length}.',
      );
    }
  }

  bool _matchOperator(String value) {
    if (_peek.kind == _TokenKind.operatorToken &&
        _peek.lexeme == value) {
      _current++;
      return true;
    }
    return false;
  }

  bool _matchAny(List<String> values) {
    if (_peek.kind == _TokenKind.operatorToken &&
        values.contains(_peek.lexeme)) {
      _current++;
      return true;
    }
    return false;
  }

  bool _matchKind(_TokenKind kind) {
    if (_checkKind(kind)) {
      _current++;
      return true;
    }
    return false;
  }

  bool _checkKind(_TokenKind kind) =>
      _peek.kind == kind;

  void _consume(
    _TokenKind kind,
    String message,
  ) {
    if (!_matchKind(kind)) {
      throw FormatException(message);
    }
  }

  _Token get _peek => tokens[_current];
  _Token get _previous => tokens[_current - 1];
}

Object? _resolvePath(
  String path,
  Map<String, Object?> context,
) {
  if (path.isEmpty) return null;
  Object? current = context;
  for (final segment in path.split('.')) {
    if (segment.isEmpty) return null;
    if (current is Map<String, Object?>) {
      current = current[segment];
      continue;
    }
    if (current is Map) {
      current = current[segment];
      continue;
    }
    // Deliberately no reflection / getters on arbitrary objects.
    return null;
  }
  return current;
}
