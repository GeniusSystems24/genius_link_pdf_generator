import '../infrastructure/printer_service_preview_gateway.dart';
import '../presentation/print_preview_controller.dart';

abstract final class GeniusPrintingCompositionRoot {
  static const GeniusPrintPreviewController previewController =
      GeniusPrintPreviewController(
    gateway: GeniusPrinterServicePreviewGateway(),
  );
}
