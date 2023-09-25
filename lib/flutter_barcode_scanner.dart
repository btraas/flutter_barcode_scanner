import 'dart:async';

import 'package:flutter/services.dart';

/// Scan mode which is either QR code or BARCODE
enum ScanMode { QR, BARCODE, DEFAULT }

enum BarcodeType {
  AZTEC,
  CODABAR,
  CODE_128,
  CODE_39,
  CODE_93,
  DATA_MATRIX,
  EAN_13,
  EAN_8,
  ITF,
  PDF_417,
  QR_CODE,
  UPC_A,
  UPC_E
}
extension BarcodeTypeOrdinal on BarcodeType {

  int? get value {
    switch (this) {
      case BarcodeType.AZTEC:
        return 4096;
      case BarcodeType.CODABAR:
        return 8;
      case BarcodeType.CODE_128:
        return 1;
      case BarcodeType.CODE_39:
        return 2;
      case BarcodeType.CODE_93:
        return 4;
      case BarcodeType.DATA_MATRIX:
        return 16;
      case BarcodeType.EAN_13:
        return 32;
      case BarcodeType.EAN_8:
        return 64;
      case BarcodeType.ITF:
        return 128;
      case BarcodeType.PDF_417:
        return 2048;
      case BarcodeType.QR_CODE:
        return 256;
      case BarcodeType.UPC_A:
        return 512;
      case BarcodeType.UPC_E:
        return 1024;
      default:
        throw Exception('Unhandled BarcodeType ${toString()}');
    }
  }
}


/// Provides access to the barcode scanner.
///
/// This class is an interface between the native Android and iOS classes and a
/// Flutter project.
class FlutterBarcodeScanner {
  static const MethodChannel _channel =
      MethodChannel('flutter_barcode_scanner');

  static const EventChannel _eventChannel =
      EventChannel('flutter_barcode_scanner_receiver');

  static Stream? _onBarcodeReceiver;

  /// Scan with the camera until a barcode is identified, then return.
  ///
  /// Shows a scan line with [lineColor] over a scan window. A flash icon is
  /// displayed if [isShowFlashIcon] is true. The text of the cancel button can
  /// be customized with the [cancelButtonText] string.
  static Future<String> scanBarcode(String lineColor, String cancelButtonText,
      bool isShowFlashIcon, ScanMode scanMode, {Set<BarcodeType>? barcodeTypes}) async {
    if (cancelButtonText.isEmpty) {
      cancelButtonText = 'Cancel';
    }

    // Pass params to the plugin
    Map params = <String, dynamic>{
      'lineColor': lineColor,
      'cancelButtonText': cancelButtonText,
      'isShowFlashIcon': isShowFlashIcon,
      'isContinuousScan': false,
      'scanMode': scanMode.index,
      'barcodeTypes': barcodeTypes?.map((e) => e.value).toList()
    };

    /// Get barcode scan result
    final barcodeResult =
        await _channel.invokeMethod('scanBarcode', params) ?? '';
    return barcodeResult;
  }

  /// Returns a continuous stream of barcode scans until the user cancels the
  /// operation.
  ///
  /// Shows a scan line with [lineColor] over a scan window. A flash icon is
  /// displayed if [isShowFlashIcon] is true. The text of the cancel button can
  /// be customized with the [cancelButtonText] string. Returns a stream of
  /// detected barcode strings.
  static Stream? getBarcodeStreamReceiver(String lineColor,
      String cancelButtonText, bool isShowFlashIcon, ScanMode scanMode, {Set<BarcodeType>? barcodeTypes}) {
    if (cancelButtonText.isEmpty) {
      cancelButtonText = 'Cancel';
    }

    // Pass params to the plugin
    Map params = <String, dynamic>{
      'lineColor': lineColor,
      'cancelButtonText': cancelButtonText,
      'isShowFlashIcon': isShowFlashIcon,
      'isContinuousScan': true,
      'scanMode': scanMode.index,
      'barcodeTypes': barcodeTypes?.map((e) => e.value).toList()
    };

    // Invoke method to open camera, and then create an event channel which will
    // return a stream
    _channel.invokeMethod('scanBarcode', params);
    _onBarcodeReceiver ??= _eventChannel.receiveBroadcastStream();
    return _onBarcodeReceiver;
  }
}
