import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  group('S01 template direction compatibility', () {
    test('legacy TemplateDefinition JSON without direction remains valid', () {
      final template = TemplateDefinition.fromJson(<String, dynamic>{
        'id': 'legacy-template',
        'name': 'Legacy',
        'content': <dynamic>[],
      });
      expect(template.direction, GeniusPdfDirection.auto);
      expect(template.toJson().containsKey('direction'), isFalse);
    });

    test('legacy page settings JSON defaults direction to auto', () {
      final template = TemplateDefinition.fromJson(<String, dynamic>{
        'id': 'legacy-page',
        'name': 'Legacy page',
        'content': <dynamic>[],
        'pageSettings': <String, dynamic>{
          'pageSize': 'a4',
          'orientation': 'portrait',
        },
      });
      expect(template.pageSettings!.direction, GeniusPdfDirection.auto);
      expect(template.pageSettings!.toJson().containsKey('direction'), isFalse);
    });

    test('explicit template/page directions round-trip through JSON', () {
      final template = TemplateDefinition.fromJson(<String, dynamic>{
        'id': 'directed',
        'name': 'Directed',
        'direction': 'rtl',
        'content': <dynamic>[],
        'pageSettings': <String, dynamic>{
          'pageSize': 'a4',
          'orientation': 'portrait',
          'direction': 'ltr',
        },
      });
      expect(template.direction, GeniusPdfDirection.rtl);
      expect(template.pageSettings!.direction, GeniusPdfDirection.ltr);
      final json = template.toJson();
      expect(json['direction'], 'rtl');
      expect((json['pageSettings'] as Map<String, dynamic>)['direction'], 'ltr');
    });

    test('unknown legacy direction fails soft to auto', () {
      final template = TemplateDefinition.fromJson(<String, dynamic>{
        'id': 'unknown',
        'name': 'Unknown',
        'direction': 'legacy-value',
        'content': <dynamic>[],
      });
      expect(template.direction, GeniusPdfDirection.auto);
    });
  });
}
