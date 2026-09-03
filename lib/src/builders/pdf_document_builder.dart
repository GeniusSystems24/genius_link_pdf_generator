import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart' as bc;
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../application/contracts/pdf_generation_ports.dart';
import '../components/widgets/pdf_barcode.dart';
import '../components/widgets/pdf_data_grid.dart';
import '../components/widgets/pdf_info_box.dart';
import '../components/widgets/pdf_report_header.dart';
import '../components/widgets/pdf_rich_text.dart';
import '../components/widgets/pdf_summary.dart';
import '../core/directionality.dart';
import '../core/pdf_config.dart';
import '../core/pdf_logger.dart';
import '../models/pdf_image.dart';
import '../extensions/color_extensions.dart';

part 'pdf_document_builder/document_builder.dart';
part 'pdf_document_builder/flow_layout.dart';
part 'pdf_document_builder/report_composer.dart';
