import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'share_models.dart';

/// Bluetooth device type.
enum GeniusBluetoothDeviceType {
  /// Unknown device type
  unknown('Unknown', 'غير معروف'),

  /// Computer
  computer('Computer', 'كمبيوتر'),

  /// Phone
  phone('Phone', 'هاتف'),

  /// Tablet
  tablet('Tablet', 'جهاز لوحي'),

  /// Headphones/Audio
  audio('Audio', 'صوتي'),

  /// Printer
  printer('Printer', 'طابعة'),

  /// Other
  other('Other', 'أخرى');

  const GeniusBluetoothDeviceType(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Bluetooth device connection status.
enum GeniusBluetoothConnectionStatus {
  /// Not connected
  disconnected('Disconnected', 'غير متصل'),

  /// Connecting
  connecting('Connecting', 'جاري الاتصال'),

  /// Connected
  connected('Connected', 'متصل'),

  /// Connection failed
  failed('Failed', 'فشل');

  const GeniusBluetoothConnectionStatus(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Represents a Bluetooth device.
class GeniusBluetoothDevice {
  /// Creates a Bluetooth device.
  const GeniusBluetoothDevice({
    required this.id,
    required this.name,
    this.address,
    this.type = GeniusBluetoothDeviceType.unknown,
    this.isPaired = false,
    this.isFavorite = false,
    this.lastConnected,
    this.signalStrength,
  });

  /// Create from JSON.
  factory GeniusBluetoothDevice.fromJson(Map<String, dynamic> json) {
    return GeniusBluetoothDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      type: GeniusBluetoothDeviceType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => GeniusBluetoothDeviceType.unknown,
      ),
      isPaired: json['isPaired'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastConnected: json['lastConnected'] != null
          ? DateTime.parse(json['lastConnected'] as String)
          : null,
    );
  }

  /// Device identifier.
  final String id;

  /// Device display name.
  final String name;

  /// Device MAC address.
  final String? address;

  /// Device type.
  final GeniusBluetoothDeviceType type;

  /// Whether device is paired.
  final bool isPaired;

  /// Whether device is favorite.
  final bool isFavorite;

  /// Last connection time.
  final DateTime? lastConnected;

  /// Signal strength (-100 to 0 dBm).
  final int? signalStrength;

  /// Get signal strength category.
  String get signalCategory {
    if (signalStrength == null) return 'Unknown';
    if (signalStrength! >= -50) return 'Excellent';
    if (signalStrength! >= -60) return 'Good';
    if (signalStrength! >= -70) return 'Fair';
    return 'Weak';
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type.name,
      'isPaired': isPaired,
      'isFavorite': isFavorite,
      'lastConnected': lastConnected?.toIso8601String(),
    };
  }

  /// Copy with modifications.
  GeniusBluetoothDevice copyWith({
    String? name,
    String? address,
    GeniusBluetoothDeviceType? type,
    bool? isPaired,
    bool? isFavorite,
    DateTime? lastConnected,
    int? signalStrength,
  }) {
    return GeniusBluetoothDevice(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      isPaired: isPaired ?? this.isPaired,
      isFavorite: isFavorite ?? this.isFavorite,
      lastConnected: lastConnected ?? this.lastConnected,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}

/// Transfer status.
enum GeniusTransferStatus {
  /// Transfer pending
  pending('Pending', 'قيد الانتظار'),

  /// Transfer in progress
  inProgress('In Progress', 'جاري'),

  /// Transfer completed
  completed('Completed', 'مكتمل'),

  /// Transfer failed
  failed('Failed', 'فشل'),

  /// Transfer cancelled
  cancelled('Cancelled', 'ملغي');

  const GeniusTransferStatus(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Represents a file transfer operation.
class GeniusBluetoothTransfer {
  /// Creates a transfer operation.
  GeniusBluetoothTransfer({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.device,
    this.status = GeniusTransferStatus.pending,
    this.progress = 0.0,
    this.startedAt,
    this.completedAt,
    this.error,
  });

  /// Transfer identifier.
  final String id;

  /// File name.
  final String fileName;

  /// File size in bytes.
  final int fileSize;

  /// Target device.
  final GeniusBluetoothDevice device;

  /// Transfer status.
  GeniusTransferStatus status;

  /// Progress (0.0 to 1.0).
  double progress;

  /// When transfer started.
  DateTime? startedAt;

  /// When transfer completed.
  DateTime? completedAt;

  /// Error message if failed.
  String? error;

  /// Bytes transferred.
  int get bytesTransferred => (fileSize * progress).round();

  /// Estimated time remaining in seconds.
  int? get estimatedTimeRemaining {
    if (startedAt == null || progress <= 0) return null;
    final elapsed = DateTime.now().difference(startedAt!).inSeconds;
    if (elapsed <= 0) return null;
    final rate = progress / elapsed;
    if (rate <= 0) return null;
    return ((1.0 - progress) / rate).round();
  }

  /// Transfer speed in bytes per second.
  double? get transferSpeed {
    if (startedAt == null || progress <= 0) return null;
    final elapsed = DateTime.now().difference(startedAt!).inMilliseconds;
    if (elapsed <= 0) return null;
    return bytesTransferred / (elapsed / 1000);
  }

  /// Whether transfer is active.
  bool get isActive =>
      status == GeniusTransferStatus.pending ||
      status == GeniusTransferStatus.inProgress;

  /// Whether transfer is finished.
  bool get isFinished =>
      status == GeniusTransferStatus.completed ||
      status == GeniusTransferStatus.failed ||
      status == GeniusTransferStatus.cancelled;
}

/// Result of Bluetooth operation.
class GeniusBluetoothResult {
  /// Creates a Bluetooth result.
  const GeniusBluetoothResult({
    required this.success,
    this.message,
    this.error,
    this.device,
    this.transfer,
  });

  /// Factory for success.
  factory GeniusBluetoothResult.success({
    String? message,
    GeniusBluetoothDevice? device,
    GeniusBluetoothTransfer? transfer,
  }) {
    return GeniusBluetoothResult(
      success: true,
      message: message,
      device: device,
      transfer: transfer,
    );
  }

  /// Factory for failure.
  factory GeniusBluetoothResult.failure(String error) {
    return GeniusBluetoothResult(
      success: false,
      error: error,
    );
  }

  /// Whether the operation was successful.
  final bool success;

  /// Success message.
  final String? message;

  /// Error message.
  final String? error;

  /// Device involved.
  final GeniusBluetoothDevice? device;

  /// Transfer involved.
  final GeniusBluetoothTransfer? transfer;
}

/// Bluetooth sharing service for PDF documents.
///
/// Provides Bluetooth file sharing capabilities:
/// - Device discovery
/// - File transfer
/// - Transfer progress tracking
/// - Nearby Share / AirDrop support
///
/// Example:
/// ```dart
/// final service = GeniusBluetoothShareService.instance;
///
/// // Check if Bluetooth is available
/// if (await service.isBluetoothAvailable()) {
///   // Discover nearby devices
///   final devices = await service.discoverDevices();
///
///   // Send file to device
///   final result = await service.sendFile(
///     pdfBytes: pdfBytes,
///     fileName: 'document.pdf',
///     device: devices.first,
///     onProgress: (progress) => print('Progress: ${progress * 100}%'),
///   );
/// }
/// ```
class GeniusBluetoothShareService {
  GeniusBluetoothShareService._();

  static final GeniusBluetoothShareService _instance =
      GeniusBluetoothShareService._();

  /// Singleton instance.
  static GeniusBluetoothShareService get instance => _instance;

  /// Discovered devices.
  final List<GeniusBluetoothDevice> _discoveredDevices = [];

  /// Favorite/saved devices.
  final List<GeniusBluetoothDevice> _savedDevices = [];

  /// Active transfers.
  final List<GeniusBluetoothTransfer> _activeTransfers = [];

  /// Stream controller for discovery events.
  final _discoveryController =
      StreamController<List<GeniusBluetoothDevice>>.broadcast();

  /// Stream controller for transfer events.
  final _transferController =
      StreamController<GeniusBluetoothTransfer>.broadcast();

  /// Stream of discovered devices.
  Stream<List<GeniusBluetoothDevice>> get discoveryStream =>
      _discoveryController.stream;

  /// Stream of transfer updates.
  Stream<GeniusBluetoothTransfer> get transferStream =>
      _transferController.stream;

  /// Get discovered devices.
  List<GeniusBluetoothDevice> get discoveredDevices =>
      List.unmodifiable(_discoveredDevices);

  /// Get saved/favorite devices.
  List<GeniusBluetoothDevice> get savedDevices =>
      List.unmodifiable(_savedDevices);

  /// Get active transfers.
  List<GeniusBluetoothTransfer> get activeTransfers =>
      List.unmodifiable(_activeTransfers);

  /// Whether discovery is in progress.
  bool _isDiscovering = false;
  bool get isDiscovering => _isDiscovering;

  /// Initialize the service.
  Future<void> initialize() async {
    await _loadSavedDevices();
  }

  /// Check if Bluetooth is available on this device.
  Future<bool> isBluetoothAvailable() async {
    // On mobile platforms, Bluetooth is typically available
    // but may need to be enabled
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if Bluetooth is enabled.
  Future<bool> isBluetoothEnabled() async {
    try {
      // This would normally check via platform channel
      // For now, return true on supported platforms
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  /// Request to enable Bluetooth.
  Future<bool> requestEnableBluetooth() async {
    try {
      // This would normally prompt the user via platform channel
      // For now, return true
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Discover nearby Bluetooth devices.
  ///
  /// Returns a list of discovered devices. Use [discoveryStream] to
  /// receive real-time updates during discovery.
  Future<List<GeniusBluetoothDevice>> discoverDevices({
    Duration timeout = const Duration(seconds: 10),
    bool includePaired = true,
  }) async {
    if (_isDiscovering) {
      return _discoveredDevices;
    }

    _isDiscovering = true;
    _discoveredDevices.clear();

    try {
      // Simulate device discovery
      // In a real implementation, this would use platform channels
      // to interact with the native Bluetooth APIs

      // Add some simulated paired devices
      if (includePaired) {
        final pairedDevices = await _getPairedDevices();
        _discoveredDevices.addAll(pairedDevices);
        _discoveryController.add(_discoveredDevices);
      }

      // Wait for timeout or discovery completion
      await Future.delayed(timeout);

      _isDiscovering = false;
      return _discoveredDevices;
    } catch (e) {
      _isDiscovering = false;
      rethrow;
    }
  }

  /// Stop device discovery.
  Future<void> stopDiscovery() async {
    _isDiscovering = false;
  }

  /// Get paired devices.
  Future<List<GeniusBluetoothDevice>> _getPairedDevices() async {
    // This would normally fetch from platform
    // Return saved devices as a fallback
    return _savedDevices;
  }

  /// Send file to a Bluetooth device.
  ///
  /// Note: Due to platform limitations, this may open the system
  /// share sheet for Bluetooth sharing rather than sending directly.
  Future<GeniusBluetoothResult> sendFile({
    required Uint8List pdfBytes,
    required String fileName,
    required GeniusBluetoothDevice device,
    void Function(double progress)? onProgress,
  }) async {
    // Create transfer record
    final transfer = GeniusBluetoothTransfer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      fileSize: pdfBytes.length,
      device: device,
      status: GeniusTransferStatus.inProgress,
      startedAt: DateTime.now(),
    );
    _activeTransfers.add(transfer);
    _transferController.add(transfer);

    try {
      // Save file to temp
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Update progress
      transfer.progress = 0.3;
      onProgress?.call(0.3);
      _transferController.add(transfer);

      // Use system share with Bluetooth hint
      // On Android, this may allow direct Bluetooth selection
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: fileName,
      );

      transfer.progress = 1.0;
      onProgress?.call(1.0);

      if (result.status == ShareResultStatus.success) {
        transfer.status = GeniusTransferStatus.completed;
        transfer.completedAt = DateTime.now();
        _transferController.add(transfer);

        // Update device last connected
        await _updateDeviceLastConnected(device.id);

        return GeniusBluetoothResult.success(
          message: 'File shared successfully',
          device: device,
          transfer: transfer,
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        transfer.status = GeniusTransferStatus.cancelled;
        _transferController.add(transfer);
        return GeniusBluetoothResult.failure('Transfer cancelled');
      } else {
        transfer.status = GeniusTransferStatus.failed;
        transfer.error = 'Share unavailable';
        _transferController.add(transfer);
        return GeniusBluetoothResult.failure('Bluetooth share unavailable');
      }
    } catch (e) {
      transfer.status = GeniusTransferStatus.failed;
      transfer.error = e.toString();
      _transferController.add(transfer);
      return GeniusBluetoothResult.failure(e.toString());
    }
  }

  /// Share via Nearby Share (Android) or AirDrop (iOS).
  ///
  /// This uses the platform's built-in proximity sharing feature.
  Future<GeniusShareResult> shareViaNearby({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    try {
      // Save file to temp
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Use system share which will show Nearby Share/AirDrop option
      final result = await Share.shareXFiles([XFile(file.path)]);

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: GeniusShareTarget.bluetooth(),
          message: 'Shared via Nearby',
          filePath: filePath,
          fileSize: pdfBytes.length,
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(
          target: GeniusShareTarget.bluetooth(),
        );
      } else {
        return GeniusShareResult.failure(
          target: GeniusShareTarget.bluetooth(),
          error: 'Nearby sharing unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: GeniusShareTarget.bluetooth(),
        error: e.toString(),
      );
    }
  }

  /// Cancel an active transfer.
  Future<void> cancelTransfer(String transferId) async {
    final index = _activeTransfers.indexWhere((t) => t.id == transferId);
    if (index != -1) {
      final transfer = _activeTransfers[index];
      transfer.status = GeniusTransferStatus.cancelled;
      _transferController.add(transfer);
    }
  }

  // Device management

  /// Save a device to favorites.
  Future<void> saveDevice(GeniusBluetoothDevice device) async {
    final existing = _savedDevices.indexWhere((d) => d.id == device.id);
    if (existing != -1) {
      _savedDevices[existing] = device.copyWith(isFavorite: true);
    } else {
      _savedDevices.add(device.copyWith(isFavorite: true));
    }
    await _persistSavedDevices();
  }

  /// Remove a device from favorites.
  Future<void> removeDevice(String deviceId) async {
    _savedDevices.removeWhere((d) => d.id == deviceId);
    await _persistSavedDevices();
  }

  /// Toggle device favorite status.
  Future<void> toggleFavorite(String deviceId) async {
    final index = _savedDevices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _savedDevices[index] = _savedDevices[index].copyWith(
        isFavorite: !_savedDevices[index].isFavorite,
      );
      await _persistSavedDevices();
    }
  }

  Future<void> _updateDeviceLastConnected(String deviceId) async {
    final index = _savedDevices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _savedDevices[index] = _savedDevices[index].copyWith(
        lastConnected: DateTime.now(),
      );
      await _persistSavedDevices();
    }
  }

  // Persistence

  Future<void> _loadSavedDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('genius_bluetooth_devices');
      if (json != null) {
        final List<dynamic> list = jsonDecode(json);
        _savedDevices.clear();
        _savedDevices.addAll(
          list.map((item) =>
              GeniusBluetoothDevice.fromJson(item as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> _persistSavedDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'genius_bluetooth_devices',
        jsonEncode(_savedDevices.map((d) => d.toJson()).toList()),
      );
    } catch (_) {
      // Ignore errors
    }
  }

  /// Dispose the service.
  void dispose() {
    _discoveryController.close();
    _transferController.close();
  }
}
