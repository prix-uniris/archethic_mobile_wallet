// ignore_for_file: cancel_subscriptions

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

// Project imports:
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/model/address.dart';
import 'package:archethic_wallet/ui/util/ui_util.dart';
import 'package:archethic_wallet/util/seeds.dart';

enum DataType { raw, url, address, seed }

class QRScanErrs {
  static const String permissionDenied = 'qr_denied';
  static const String unknownError = 'qr_unknown';
  static const String cancelError = 'qr_cancel';
  static const List<String> errorList = <String>[
    permissionDenied,
    unknownError,
    cancelError
  ];
}

// ignore: avoid_classes_with_only_static_members
class UserDataUtil {
  static StreamSubscription<dynamic>? setStream;

  static String? _parseData(String data, DataType type) {
    data = data.trim();
    if (type == DataType.raw) {
      return data;
    } else if (type == DataType.url) {
      if (isIP(data)) {
        return data;
      } else if (isURL(data)) {
        return data;
      }
    } else if (type == DataType.address) {
      final Address address = Address(data);
      if (address.isValid()) {
        return address.address;
      }
    } else if (type == DataType.seed) {
      // Check if valid seed
      if (AppSeeds.isValidSeed(data)) {
        return data;
      }
    }
    return null;
  }

  static Future<String?> getClipboardText(DataType type) async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    if (data == null || data.text == null) {
      return null;
    }
    return _parseData(data.text!, type);
  }

  static Future<String?> getQRData(DataType type, BuildContext context) async {
    UIUtil.cancelLockEvent();
    try {
      final ScanResult scanResult = await BarcodeScanner.scan();
      final String data = scanResult.rawContent;
      if (isEmpty(data)) {
        return null;
      }
      return _parseData(data, type);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.qrInvalidPermissions, context);
        return QRScanErrs.permissionDenied;
      } else {
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.qrUnknownError, context);
        return QRScanErrs.unknownError;
      }
    } on FormatException {
      return QRScanErrs.cancelError;
    } catch (e) {
      if (kDebugMode) {
        print('Unknown QR Scan Error ${e.toString()}');
      }
      return QRScanErrs.unknownError;
    }
  }
}
