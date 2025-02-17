// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:archethic_wallet/appstate_container.dart';
import 'package:archethic_wallet/ui/util/dimens.dart';
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/model/authentication_method.dart';
import 'package:archethic_wallet/util/service_locator.dart';
import 'package:archethic_wallet/ui/util/styles.dart';
import 'package:archethic_wallet/ui/util/routes.dart';
import 'package:archethic_wallet/ui/views/pin_screen.dart';
import 'package:archethic_wallet/ui/views/yubikey_screen.dart';
import 'package:archethic_wallet/ui/widgets/components/buttons.dart';
import 'package:archethic_wallet/ui/widgets/components/dialog.dart';
import 'package:archethic_wallet/ui/widgets/components/icon_widget.dart';
import 'package:archethic_wallet/util/app_util.dart';
import 'package:archethic_wallet/util/biometrics_util.dart';
import 'package:archethic_wallet/util/case_converter.dart';
import 'package:archethic_wallet/util/preferences.dart';
import 'package:archethic_wallet/util/vault.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({Key? key}) : super(key: key);

  @override
  _AppLockScreenState createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _lockedOut = true;
  String _countDownTxt = '';

  Future<void> _goHome() async {
    if (StateContainer.of(context).wallet == null) {
      await AppUtil()
          .loginAccount(await StateContainer.of(context).getSeed(), context);
    }
    StateContainer.of(context)
        .requestUpdate(account: StateContainer.of(context).selectedAccount);
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home_transition',
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildPinScreen(BuildContext context, String expectedPin) {
    return PinScreen(PinOverlayType.enterPin,
        expectedPin: expectedPin,
        description: AppLocalization.of(context)!.unlockPin,
        pinScreenBackgroundColor:
            StateContainer.of(context).curTheme.backgroundDark);
  }

  Widget _buildYubikeyScreen(BuildContext context) {
    return YubikeyScreen(
        yubikeyScreenBackgroundColor:
            StateContainer.of(context).curTheme.backgroundDark);
  }

  String _formatCountDisplay(int count) {
    if (count <= 60) {
      // Seconds only
      String secondsStr = count.toString();
      if (count < 10) {
        secondsStr = '0' + secondsStr;
      }
      return '00:' + secondsStr;
    } else if (count > 60 && count <= 3600) {
      // Minutes:Seconds
      String minutesStr = '';
      final int minutes = count ~/ 60;
      if (minutes < 10) {
        minutesStr = '0' + minutes.toString();
      } else {
        minutesStr = minutes.toString();
      }
      String secondsStr = '';
      final int seconds = count % 60;
      if (seconds < 10) {
        secondsStr = '0' + seconds.toString();
      } else {
        secondsStr = seconds.toString();
      }
      return minutesStr + ':' + secondsStr;
    } else {
      // Hours:Minutes:Seconds
      String hoursStr = '';
      final int hours = count ~/ 3600;
      if (hours < 10) {
        hoursStr = '0' + hours.toString();
      } else {
        hoursStr = hours.toString();
      }
      count = count % 3600;
      String minutesStr = '';
      final int minutes = count ~/ 60;
      if (minutes < 10) {
        minutesStr = '0' + minutes.toString();
      } else {
        minutesStr = minutes.toString();
      }
      String secondsStr = '';
      final int seconds = count % 60;
      if (seconds < 10) {
        secondsStr = '0' + seconds.toString();
      } else {
        secondsStr = seconds.toString();
      }
      return hoursStr + ':' + minutesStr + ':' + secondsStr;
    }
  }

  Future<void> _runCountdown(int count) async {
    if (count >= 1) {
      if (mounted) {
        setState(() {
          _lockedOut = true;
          _countDownTxt = _formatCountDisplay(count);
        });
      }
      Future<void>.delayed(const Duration(seconds: 1), () {
        _runCountdown(count - 1);
      });
    } else {
      if (mounted) {
        setState(() {
          _lockedOut = false;
        });
      }
    }
  }

  Future<void> authenticateWithBiometrics() async {
    final bool authenticated = await sl
        .get<BiometricUtil>()
        .authenticateWithBiometrics(
            context, AppLocalization.of(context)!.unlockBiometrics);
    if (authenticated) {
      _goHome();
    }
  }

  Future<void> authenticateWithPin({bool transitions = false}) async {
    final Vault _vault = await Vault.getInstance();
    final String? expectedPin = _vault.getPin();
    bool auth = false;
    if (transitions) {
      auth = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return _buildPinScreen(context, expectedPin!);
        }),
      ) as bool;
    } else {
      auth = await Navigator.of(context).push(
        NoPushTransitionRoute(builder: (BuildContext context) {
          return _buildPinScreen(context, expectedPin!);
        }),
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted && auth) {
      _goHome();
    }
  }

  Future<void> authenticateWithYubikey({bool transitions = false}) async {
    bool auth = false;
    if (transitions) {
      auth = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return _buildYubikeyScreen(context);
        }),
      );
    } else {
      auth = await Navigator.of(context).push(
        NoPushTransitionRoute(builder: (BuildContext context) {
          return _buildYubikeyScreen(context);
        }),
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted && auth) {
      _goHome();
    }
  }

  Future<void> _authenticate({bool transitions = false}) async {
    // Test if user is locked out
    // Get duration of lockout
    final Preferences _preferences = await Preferences.getInstance();
    final DateTime? lockUntil = _preferences.getLockDate();
    if (lockUntil == null) {
      _preferences.resetLockAttempts();
    } else {
      final int countDown =
          lockUntil.difference(DateTime.now().toUtc()).inSeconds;
      // They're not allowed to attempt
      if (countDown > 0) {
        _runCountdown(countDown);
        return;
      }
    }
    setState(() {
      _lockedOut = false;
    });
    final AuthenticationMethod authMethod = _preferences.getAuthMethod();
    final bool hasBiometrics = await sl.get<BiometricUtil>().hasBiometrics();
    if (authMethod.method == AuthMethod.biometrics && hasBiometrics) {
      try {
        await authenticateWithBiometrics();
      } catch (e) {
        await authenticateWithPin(transitions: transitions);
      }
    } else {
      if (authMethod.method == AuthMethod.yubikeyWithYubicloud) {
        return authenticateWithYubikey(transitions: transitions);
      } else {
        await authenticateWithPin(transitions: transitions);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: StateContainer.of(context).curTheme.backgroundDarkest,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  StateContainer.of(context).curTheme.backgroundDark!,
                  StateContainer.of(context).curTheme.background!
                ],
              ),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                SafeArea(
              minimum: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.035,
                  top: MediaQuery.of(context).size.height * 0.075),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: smallScreen(context) ? 15 : 20),
                              height: 50,
                              width: 150,
                              child: TextButton(
                                onPressed: () {
                                  AppDialogs.showConfirmDialog(
                                      context,
                                      CaseChange.toUpperCase(
                                          AppLocalization.of(context)!.warning,
                                          context),
                                      AppLocalization.of(context)!.logoutDetail,
                                      AppLocalization.of(context)!
                                          .logoutAction
                                          .toUpperCase(), () {
                                    // Show another confirm dialog
                                    AppDialogs.showConfirmDialog(
                                        context,
                                        AppLocalization.of(context)!
                                            .logoutAreYouSure,
                                        AppLocalization.of(context)!
                                            .logoutReassurance,
                                        CaseChange.toUpperCase(
                                            AppLocalization.of(context)!.yes,
                                            context),
                                        () {});
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.signOutAlt,
                                        size: 16,
                                        color: StateContainer.of(context)
                                            .curTheme
                                            .primary),
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 4),
                                      child: Text(
                                          AppLocalization.of(context)!.logout,
                                          style: AppStyles
                                              .textStyleSize14W600Primary(
                                                  context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        buildIconWidget(
                            context, 'assets/icons/lock.png', 90, 90),
                        Container(
                          child: Text(
                            CaseChange.toUpperCase(
                                AppLocalization.of(context)!.locked, context),
                            style:
                                AppStyles.textStyleSize28W700Primary(context),
                          ),
                          margin: const EdgeInsets.only(top: 10),
                        ),
                        if (!_lockedOut)
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            child: Text(
                              AppLocalization.of(context)!
                                  .tooManyFailedAttempts,
                              style:
                                  AppStyles.textStyleSize14W600Primary(context),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppButton.buildAppButton(
                          context,
                          AppButtonType.primary,
                          _lockedOut
                              ? _countDownTxt
                              : AppLocalization.of(context)!.unlock,
                          Dimens.buttonBottomDimens, onPressed: () {
                        if (!_lockedOut) {
                          _authenticate(transitions: true);
                        }
                      }, disabled: _lockedOut),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
