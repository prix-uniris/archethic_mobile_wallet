// Flutter imports:
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

// Project imports:
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/model/setting_item.dart';

enum AvailableLanguage { DEFAULT, ENGLISH, FRENCH }

/// Represent the available languages our app supports
class LanguageSetting extends SettingSelectionItem {
  LanguageSetting(this.language);

  AvailableLanguage language;

  @override
  String getDisplayName(BuildContext context) {
    switch (language) {
      case AvailableLanguage.ENGLISH:
        return 'English (en)';
      case AvailableLanguage.FRENCH:
        return 'Français (fr)';
      default:
        return AppLocalization.of(context)!.systemDefault;
    }
  }

  String getLocaleString() {
    switch (language) {
      case AvailableLanguage.ENGLISH:
        return 'en';
      case AvailableLanguage.FRENCH:
        return 'fr';
      default:
        return 'DEFAULT';
    }
  }

  Locale getLocale() {
    final String localeStr = getLocaleString();
    if (localeStr == 'DEFAULT') {
      return const Locale('en');
    }
    return Locale(localeStr);
  }

  // For saving to shared prefs
  int getIndex() {
    return language.index;
  }
}
