// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/model/setting_item.dart';

enum UnlockOption { yes, no }

/// Represent authenticate to open setting
class UnlockSetting extends SettingSelectionItem {
  UnlockSetting(this.setting);

  UnlockOption setting;

  @override
  String getDisplayName(BuildContext context) {
    switch (setting) {
      case UnlockOption.yes:
        return AppLocalization.of(context)!.yes;
      case UnlockOption.no:
      default:
        return AppLocalization.of(context)!.no;
    }
  }

  // For saving to shared prefs
  int getIndex() {
    return setting.index;
  }
}
