// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:archethic_wallet/appstate_container.dart';

// ignore: avoid_classes_with_only_static_members
class AppStyles {
  static TextStyle textStyleSize16W200Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size16,
        fontWeight: FontWeight.w200,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize16W400Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size16,
        fontWeight: FontWeight.w400,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize16W700Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size16,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize16W100Primary60(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size16,
        fontWeight: FontWeight.w100,
        color: StateContainer.of(context).curTheme.primary60);
  }

  static TextStyle textStyleSize14W600Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w600,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize14W600PrimaryDisabled(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w600,
        color: StateContainer.of(context).curTheme.primary!.withOpacity(0.3));
  }

  static TextStyle textStyleSize24W600Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size24,
        fontWeight: FontWeight.w600,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize14W600BackgroundDarkest(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w600,
        color: StateContainer.of(context).curTheme.backgroundDarkest);
  }

  static TextStyle textStyleSize16W700BackgroundDarkest(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size16,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.backgroundDarkest);
  }

  static TextStyle textStyleSize14W700Background(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.background);
  }

  static TextStyle textStyleSize14W700ContextMenuPrimary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.contextMenuText);
  }

  static TextStyle textStyleSize14W700ContextMenuTextRed(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.contextMenuTextRed);
  }

  static TextStyle textStyleSize20W700Background(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size20,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.background);
  }

  static TextStyle textStyleSize20W700Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size20,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize20W700Green(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size20,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.positiveAmount);
  }

  static TextStyle textStyleSize20W700Red(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size20,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.negativeAmount);
  }

  static TextStyle textStyleSize14W700Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize14W700Success(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.success);
  }

  static TextStyle textStyleSize14W700SuccessDark(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.successDark);
  }

  static TextStyle textStyleSize20W700Primary60(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size20,
        fontWeight: FontWeight.w700,
        color: StateContainer.of(context).curTheme.primary60);
  }

  static TextStyle textStyleSize14W100Sucess(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.success,
      height: 1.5,
    );
  }

  static TextStyle textStyleSize14W100Text60(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary60,
      height: 1.5,
    );
  }

  static TextStyle textStyleSize14W700Text60(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.primary60,
      height: 1.5,
    );
  }

  static TextStyle textStyleSize14W100Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary,
      height: 1.5,
    );
  }

  static TextStyle textStyleSize14W600Text60(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size14,
        fontWeight: FontWeight.w600,
        color: StateContainer.of(context).curTheme.primary60);
  }

  static TextStyle textStyleSize28W900Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: AppFontSizes.size28,
        fontWeight: FontWeight.w900,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize40W900Primary(BuildContext context) {
    return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: StateContainer.of(context).curTheme.primary);
  }

  static TextStyle textStyleSize12W100PositiveValue(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w800,
      color: StateContainer.of(context).curTheme.positiveValue,
    );
  }

  static TextStyle textStyleSize16W100PositiveValue(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w800,
      color: StateContainer.of(context).curTheme.positiveValue,
    );
  }

  static TextStyle textStyleSize12W100NegativeValue(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w800,
      color: StateContainer.of(context).curTheme.negativeValue,
    );
  }

  static TextStyle textStyleSize16W100NegativeValue(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w800,
      color: StateContainer.of(context).curTheme.negativeValue,
    );
  }

  static TextStyle textStyleSize12W100Primary60(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.primary60,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize12W100Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.primary,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize12W100Primary30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.primary,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize10W100Primary60(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.primary60,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize10W100Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.primary,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize10W100Transparent(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.transparent,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle textStyleSize12W100Text60(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary60,
    );
  }

  static TextStyle textStyleSize16W600Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize16W600Primary30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.primary30,
    );
  }

  static TextStyle textStyleSize16W200Primary30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w200,
      color: StateContainer.of(context).curTheme.primary30,
    );
  }

  static TextStyle textStyleSize16W600ChoiceOption(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.choiceOption,
    );
  }

  static TextStyle textStyleSize12W600Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize14W100Success(BuildContext context) {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w100,
      fontFamily: 'Montserrat',
      color: StateContainer.of(context).curTheme.success,
      height: 1.5,
      letterSpacing: 1,
    );
  }

  static TextStyle textStyleSize24W700Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size24,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize28W700Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size28,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize28W700Warning(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size28,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.warning,
    );
  }

  static TextStyle textStyleSize80W700Primary15(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 80,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.primary15,
    );
  }

  static TextStyle textStyleSize16W600Text45(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.primary45,
    );
  }

  static TextStyle textStyleSize12W100Text30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary30,
    );
  }

  static TextStyle textStyleSmallTextW100Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSmallTextW100Success(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.success,
    );
  }

  static TextStyle textStyleSmallTextW400SuccessDark(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w400,
      color: StateContainer.of(context).curTheme.successDark,
    );
  }

  static TextStyle textStyleSmallTextW100Text30(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.smallText(context),
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary30,
    );
  }

  static TextStyle textStyleSize14W600Success(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w600,
      color: StateContainer.of(context).curTheme.success,
    );
  }

  static TextStyle textStyleSize16W100Success(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.success,
    );
  }

  static TextStyle textStyleSize16W700Success(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.success,
    );
  }

  static TextStyle textStyleSize28W700Success(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size28,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.success,
    );
  }

  static TextStyle textStyleSize16W100Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w100,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize12W400Primary(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: StateContainer.of(context).curTheme.primary,
    );
  }

  static TextStyle textStyleSize14W700Primary60(BuildContext context) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w700,
      color: StateContainer.of(context).curTheme.primary60,
    );
  }
}

// ignore: avoid_classes_with_only_static_members
class AppFontSizes {
  static const double size10 = 10.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size22 = 22.0;
  static const double size24 = 24.0;
  static const double size28 = 28.0;

  static double largest(BuildContext context) {
    if (smallScreen(context)) {
      return size22;
    }
    return size28;
  }

  static double large(BuildContext context) {
    if (smallScreen(context)) {
      return size18;
    }
    return size20;
  }

  static double smallText(BuildContext context) {
    if (smallScreen(context)) {
      return size12;
    }
    return size14;
  }
}

bool smallScreen(BuildContext context) {
  if (MediaQuery.of(context).size.height < 800) {
    return true;
  } else {
    return false;
  }
}
