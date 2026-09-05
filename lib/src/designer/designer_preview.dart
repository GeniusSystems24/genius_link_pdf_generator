
import '../engine_vnext/template_engine_vnext.dart';
import 'designer_authoring.dart';
import 'designer_models.dart';

class GeniusPdfDesignerPreviewRequest {
  const GeniusPdfDesignerPreviewRequest({
    required this.state,
    this.scope = const GeniusPdfTemplateScope(),
    this.maxRepeatItems = 10000,
  }) : assert(maxRepeatItems > 0);

  final GeniusPdfDesignerDocumentState state;
  final GeniusPdfTemplateScope scope;
  final int maxRepeatItems;
}

class GeniusPdfDesignerPreviewResult {
  const GeniusPdfDesignerPreviewResult({
    required this.state,
    required this.validation,
    this.resolvedTemplate,
  });

  final GeniusPdfDesignerDocumentState state;
  final GeniusPdfDesignerValidationResult validation;
  final GeniusPdfResolvedTemplate? resolvedTemplate;

  bool get canPreview =>
      validation.isValid && resolvedTemplate != null;
}

/// S25-T06..T11 preview model. UI frameworks can bind this result to a live
/// preview canvas, PDF preview, validation panel and page-profile selector.
class GeniusPdfDesignerPreviewService {
  const GeniusPdfDesignerPreviewService();

  GeniusPdfDesignerPreviewResult build(
    GeniusPdfDesignerPreviewRequest request, {
    GeniusPdfTemplateRegistry? registry,
  }) {
    const authoring = GeniusPdfDesignerAuthoringController();
    final validation = authoring.validate(request.state);
    if (!validation.isValid) {
      return GeniusPdfDesignerPreviewResult(
        state: request.state,
        validation: validation,
      );
    }

    final templateRegistry =
        registry ?? GeniusPdfTemplateRegistry();
    try {
      templateRegistry.register(
        request.state.schema,
        replaceSameVersion: true,
      );
    } on StateError {
      // A supplied registry can already contain the same preview version.
      templateRegistry.register(
        request.state.schema,
        replaceSameVersion: true,
      );
    }

    final engine = GeniusPdfTemplateEngine(
      registry: templateRegistry,
      maxRepeatItems: request.maxRepeatItems,
    );
    final resolved = engine.resolve(
      request.state.schema,
      context: request.state.sampleData,
      localization: request.state.localization,
      scope: request.scope,
    );
    return GeniusPdfDesignerPreviewResult(
      state: request.state,
      validation: validation,
      resolvedTemplate: resolved,
    );
  }
}
