import 'dart:typed_data';

/// Represents an image for use in PDF documents.
///
/// This model encapsulates image binary data along with its dimensions,
/// making it easy to position and scale images within PDF pages.
///
/// Named `AppPdfImage` to avoid conflicts with Syncfusion's `PdfImage`.
///
/// ## Example
/// ```dart
/// final image = AppPdfImage(
///   data: imageBytes,
///   width: 200,
///   height: 100,
/// );
///
/// // Use in PDF document
/// document.addImage(image);
/// ```
class GeniusPdfImage {

  /// Creates a new [GeniusPdfImage] instance.
  ///
  /// ## Parameters
  /// - [data]: Binary image data (required).
  /// - [width]: Image width in points (required).
  /// - [height]: Image height in points (required).
  const GeniusPdfImage({
    required this.data,
    required this.width,
    required this.height,
  });
  /// The binary data of the image.
  final Uint8List data;

  /// The width of the image in points.
  final double width;

  /// The height of the image in points.
  final double height;

  /// The aspect ratio of the image (width / height).
  double get aspectRatio => width / height;

  /// Creates a scaled version of this image that fits within the given bounds.
  ///
  /// The aspect ratio is preserved.
  GeniusPdfImage scaledToFit({
    required double maxWidth,
    required double maxHeight,
  }) {
    final widthRatio = maxWidth / width;
    final heightRatio = maxHeight / height;
    final scale = widthRatio < heightRatio ? widthRatio : heightRatio;

    return GeniusPdfImage(
      data: data,
      width: width * scale,
      height: height * scale,
    );
  }

  /// Creates a scaled version of this image with the given width.
  ///
  /// The aspect ratio is preserved.
  GeniusPdfImage scaledToWidth(double targetWidth) {
    final scale = targetWidth / width;
    return GeniusPdfImage(
      data: data,
      width: targetWidth,
      height: height * scale,
    );
  }

  /// Creates a scaled version of this image with the given height.
  ///
  /// The aspect ratio is preserved.
  GeniusPdfImage scaledToHeight(double targetHeight) {
    final scale = targetHeight / height;
    return GeniusPdfImage(
      data: data,
      width: width * scale,
      height: targetHeight,
    );
  }

  /// Creates a copy of this image with the given properties replaced.
  GeniusPdfImage copyWith({
    Uint8List? data,
    double? width,
    double? height,
  }) {
    return GeniusPdfImage(
      data: data ?? this.data,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  String toString() => 'AppPdfImage(width: $width, height: $height)';
}
