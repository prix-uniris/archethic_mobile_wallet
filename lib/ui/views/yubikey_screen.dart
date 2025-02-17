// Dart imports:
// ignore_for_file: always_specify_types

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yubidart/yubidart.dart';

// Project imports:
import 'package:archethic_wallet/appstate_container.dart';
import 'package:archethic_wallet/bus/otp_event.dart';
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/util/service_locator.dart';
import 'package:archethic_wallet/ui/util/styles.dart';
import 'package:archethic_wallet/ui/util/ui_util.dart';
import 'package:archethic_wallet/ui/widgets/components/app_text_field.dart';
import 'package:archethic_wallet/ui/widgets/components/icon_widget.dart';
import 'package:archethic_wallet/util/nfc.dart';
import 'package:archethic_wallet/util/preferences.dart';

class YubikeyScreen extends StatefulWidget {
  const YubikeyScreen({this.yubikeyScreenBackgroundColor, Key? key})
      : super(key: key);

  final Color? yubikeyScreenBackgroundColor;

  @override
  _YubikeyScreenState createState() => _YubikeyScreenState();
}

class _YubikeyScreenState extends State<YubikeyScreen> {
  StreamSubscription<OTPReceiveEvent>? _otpReceiveSub;

  double buttonSize = 100.0;

  VerificationResponse verificationResponse = VerificationResponse();

  FocusNode? enterOTPFocusNode;
  TextEditingController? enterOTPController;
  String buttonNFCLabel = 'get my OTP via NFC';
  bool isNFCAvailable = false;

  @override
  void initState() {
    super.initState();
    _registerBus();

    enterOTPFocusNode = FocusNode();
    enterOTPController = TextEditingController();

    sl.get<NFCUtil>().hasNFC().then((bool hasNFC) {
      setState(() {
        isNFCAvailable = hasNFC;
      });
    });
  }

  void _registerBus() {
    _otpReceiveSub = EventTaxiImpl.singleton()
        .registerTo<OTPReceiveEvent>()
        .listen((OTPReceiveEvent event) {
      setState(() {
        buttonNFCLabel = 'get my OTP via NFC';
      });
      _verifyOTP(event.otp!);
    });
  }

  @override
  void dispose() {
    if (_otpReceiveSub != null) {
      _otpReceiveSub!.cancel();
    }
    super.dispose();
  }

  Future<void> _verifyOTP(String otp) async {
    final Preferences _preferences = await Preferences.getInstance();

    UIUtil.showSnackbar(otp, context);
    final String yubikeyClientAPIKey = _preferences.getYubikeyClientAPIKey();
    final String yubikeyClientID = _preferences.getYubikeyClientID();
    verificationResponse = await YubicoService()
        .verifyYubiCloudOTP(otp, yubikeyClientAPIKey, yubikeyClientID);
    switch (verificationResponse.status) {
      case 'BAD_OTP':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_BAD_OTP, context);
        Navigator.of(context).pop();
        break;
      case 'BACKEND_ERROR':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_BACKEND_ERROR, context);
        Navigator.of(context).pop();
        break;
      case 'BAD_SIGNATURE':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_BAD_SIGNATURE, context);
        Navigator.of(context).pop();
        break;
      case 'MISSING_PARAMETER':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_MISSING_PARAMETER,
            context);
        Navigator.of(context).pop();
        break;
      case 'NOT_ENOUGH_ANSWERS':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_NOT_ENOUGH_ANSWERS,
            context);
        Navigator.of(context).pop();
        break;
      case 'NO_SUCH_CLIENT':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_NO_SUCH_CLIENT, context);
        Navigator.of(context).pop();
        break;
      case 'OPERATION_NOT_ALLOWED':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_OPERATION_NOT_ALLOWED,
            context);
        Navigator.of(context).pop();
        break;
      case 'REPLAYED_OTP':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_REPLAYED_OTP, context);
        Navigator.of(context).pop();
        break;
      case 'REPLAYED_REQUEST':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_REPLAYED_REQUEST,
            context);
        Navigator.of(context).pop();
        break;
      case 'RESPONSE_KO':
        UIUtil.showSnackbar(
            AppLocalization.of(context)!.yubikeyError_RESPONSE_KO, context);
        Navigator.of(context).pop();
        break;
      case 'OK':
        UIUtil.showSnackbar(verificationResponse.status, context);
        _preferences.resetLockAttempts();
        Navigator.of(context).pop(true);
        break;
      default:
        UIUtil.showSnackbar(verificationResponse.status, context);
        Navigator.of(context).pop();
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                top: MediaQuery.of(context).size.height * 0.10,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildIconWidget(
                              context, 'assets/icons/key-ring.png', 90, 90),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            child: AutoSizeText(
                              'OTP',
                              style:
                                  AppStyles.textStyleSize16W400Primary(context),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              stepGranularity: 0.1,
                            ),
                          ),
                          if (isNFCAvailable)
                            ElevatedButton(
                                child: Text(buttonNFCLabel,
                                    style: AppStyles.textStyleSize16W200Primary(
                                        context)),
                                onPressed: () {
                                  setState(() {
                                    buttonNFCLabel =
                                        'Hold your device near the Yubikey';
                                  });
                                  _tagRead();
                                })
                          else
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: AutoSizeText(
                                'Please, connect your Yubikey',
                                style: AppStyles.textStyleSize16W200Primary(
                                    context),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                stepGranularity: 0.1,
                              ),
                            ),
                          if (isNFCAvailable)
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                            )
                          else
                            AppTextField(
                              topMargin: 30,
                              maxLines: 3,
                              padding: const EdgeInsetsDirectional.only(
                                  start: 16, end: 16),
                              focusNode: enterOTPFocusNode,
                              controller: enterOTPController,
                              textInputAction: TextInputAction.go,
                              autofocus: true,
                              onSubmitted: (value) async {
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (String value) async {
                                if (value.trim().length == 44) {
                                  EventTaxiImpl.singleton()
                                      .fire(OTPReceiveEvent(otp: value));
                                }
                              },
                              inputFormatters: <
                                  LengthLimitingTextInputFormatter>[
                                LengthLimitingTextInputFormatter(45),
                              ],
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyles.textStyleSize16W600Primary(context),
                              suffixButton: TextFieldButton(
                                icon: FontAwesomeIcons.paste,
                                onPressed: () {
                                  Clipboard.getData('text/plain')
                                      .then((ClipboardData? data) async {
                                    if (data == null || data.text == null) {
                                      return;
                                    }
                                    enterOTPController!.text = data.text!;
                                    EventTaxiImpl.singleton().fire(
                                        OTPReceiveEvent(
                                            otp: enterOTPController!.text));
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _tagRead() async {
    await sl.get<NFCUtil>().authenticateWithNFCYubikey(context);
  }
}
