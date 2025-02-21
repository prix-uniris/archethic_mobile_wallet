// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:archethic_wallet/appstate_container.dart';
import 'package:archethic_wallet/bus/events.dart';
import 'package:archethic_wallet/ui/util/dimens.dart';
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/model/address.dart';
import 'package:archethic_wallet/model/data/appdb.dart';
import 'package:archethic_wallet/model/data/hive_db.dart';
import 'package:archethic_wallet/util/service_locator.dart';
import 'package:archethic_wallet/ui/util/styles.dart';
import 'package:archethic_wallet/ui/util/formatters.dart';
import 'package:archethic_wallet/ui/util/ui_util.dart';
import 'package:archethic_wallet/ui/widgets/components/app_text_field.dart';
import 'package:archethic_wallet/ui/widgets/components/buttons.dart';
import 'package:archethic_wallet/ui/widgets/components/tap_outside_unfocus.dart';
import 'package:archethic_wallet/util/user_data_util.dart';

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({Key? key, this.address}) : super(key: key);

  final String? address;

  @override
  _AddContactSheetState createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  FocusNode? _nameFocusNode;
  FocusNode? _addressFocusNode;
  TextEditingController? _nameController;
  TextEditingController? _addressController;

  // State variables
  bool? _addressValid;
  bool? _showPasteButton;
  bool? _showNameHint;
  bool? _showAddressHint;
  bool? _addressValidAndUnfocused;
  String? _nameValidationText;
  String? _addressValidationText;

  @override
  void initState() {
    super.initState();
    // Text field initialization
    _nameFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    // State initializationrue;
    _addressValid = false;
    _showPasteButton = true;
    _showNameHint = true;
    _showAddressHint = true;
    _addressValidAndUnfocused = false;
    _nameValidationText = '';
    _addressValidationText = '';
    // Add focus listeners
    // On name focus change
    _nameFocusNode!.addListener(() {
      if (_nameFocusNode!.hasFocus) {
        setState(() {
          _showNameHint = false;
        });
      } else {
        setState(() {
          _showNameHint = true;
        });
      }
    });
    // On address focus change
    _addressFocusNode!.addListener(() {
      if (_addressFocusNode!.hasFocus) {
        setState(() {
          _showAddressHint = false;
          _addressValidAndUnfocused = false;
        });
        _addressController!.selection = TextSelection.fromPosition(
            TextPosition(offset: _addressController!.text.length));
      } else {
        setState(() {
          _showAddressHint = true;
          if (Address(_addressController!.text).isValid()) {
            _addressValidAndUnfocused = true;
          }
        });
      }
    });
  }

  /// Return true if textfield should be shown, false if colorized should be shown
  bool _shouldShowTextField() {
    if (widget.address != null) {
      return false;
    } else if (_addressValidAndUnfocused!) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TapOutsideUnfocus(
        child: SafeArea(
      minimum:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.035),
      child: Column(
        children: <Widget>[
          // Top row of the sheet which contains the header and the scan qr button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 60,
                height: 40,
              ),
              Column(
                children: <Widget>[
                  // Sheet handle
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 5,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: StateContainer.of(context).curTheme.primary10,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ],
              ), // Empty SizedBox
              const SizedBox(
                width: 60,
                height: 40,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // The header of the sheet
              AutoSizeText(
                AppLocalization.of(context)!.addContact,
                style: AppStyles.textStyleSize24W700Primary(context),
                textAlign: TextAlign.center,
                maxLines: 1,
                stepGranularity: 0.1,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: AutoSizeText(
              AppLocalization.of(context)!.addressBookDesc,
              style: AppStyles.textStyleSize16W200Primary(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              stepGranularity: 0.1,
            ),
          ),

          // The main container that holds "Enter Name" and "Enter Address" text fields
          Expanded(
            child: Column(
              children: <Widget>[
                // Enter Name Container
                AppTextField(
                  topMargin: MediaQuery.of(context).size.height * 0.14,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  focusNode: _nameFocusNode,
                  controller: _nameController,
                  textInputAction: widget.address != null
                      ? TextInputAction.done
                      : TextInputAction.next,
                  hintText: _showNameHint!
                      ? AppLocalization.of(context)!.contactNameHint
                      : '',
                  keyboardType: TextInputType.text,
                  style: AppStyles.textStyleSize16W600Primary(context),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(20),
                    ContactInputFormatter()
                  ],
                  onSubmitted: (String text) {
                    if (widget.address == null) {
                      if (!Address(_addressController!.text).isValid()) {
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      } else {
                        FocusScope.of(context).unfocus();
                      }
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
                // Enter Name Error Container
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(_nameValidationText!,
                      style: AppStyles.textStyleSize14W600Primary(context)),
                ),
                // Enter Address container
                AppTextField(
                  padding: !_shouldShowTextField()
                      ? const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0)
                      : EdgeInsets.zero,
                  focusNode: _addressFocusNode,
                  controller: _addressController,
                  style: _addressValid!
                      ? AppStyles.textStyleSize14W100Primary(context)
                      : AppStyles.textStyleSize14W100Text60(context),
                  inputFormatters: <LengthLimitingTextInputFormatter>[
                    LengthLimitingTextInputFormatter(66),
                  ],
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  autocorrect: false,
                  hintText: _showAddressHint!
                      ? AppLocalization.of(context)!.addressHint
                      : '',
                  prefixButton: TextFieldButton(
                      icon: FontAwesomeIcons.qrcode,
                      onPressed: () async {
                        UIUtil.cancelLockEvent();
                        final String? scanResult = await UserDataUtil.getQRData(
                            DataType.address, context);
                        if (!QRScanErrs.errorList.contains(scanResult)) {
                          if (mounted) {
                            setState(() {
                              _addressController!.text = scanResult!;
                              _addressValidationText = '';
                              _addressValid = true;
                              _addressValidAndUnfocused = true;
                            });
                            _addressFocusNode!.unfocus();
                          }
                        }
                      }),
                  fadePrefixOnCondition: true,
                  prefixShowFirstCondition: _showPasteButton,
                  suffixButton: TextFieldButton(
                    icon: FontAwesomeIcons.paste,
                    onPressed: () async {
                      if (!_showPasteButton!) {
                        return;
                      }
                      final String? data =
                          await UserDataUtil.getClipboardText(DataType.address);
                      if (data != null) {
                        setState(() {
                          _addressValid = true;
                          _showPasteButton = false;
                          _addressController!.text = data;
                          _addressValidAndUnfocused = true;
                        });
                        _addressFocusNode!.unfocus();
                      } else {
                        setState(() {
                          _showPasteButton = true;
                          _addressValid = false;
                        });
                      }
                    },
                  ),
                  fadeSuffixOnCondition: true,
                  suffixShowFirstCondition: _showPasteButton,
                  onChanged: (String text) {
                    /*Address address = Address(text);
                      if (address.isValid()) {
                            setState(() {
                              _addressValid = true;
                              _showPasteButton = true;
                              _addressController.text =
                                  address.address;
                            });
                            _addressFocusNode.unfocus();
                          } else {
                            setState(() {
                              _showPasteButton = true;
                              _addressValid = false;
                            });
                          }*/
                    setState(() {
                      _showPasteButton = true;
                      _addressValid = false;
                    });
                  },
                  overrideTextFieldWidget: !_shouldShowTextField()
                      ? GestureDetector(
                          onTap: () {
                            if (widget.address != null) {
                              return;
                            }
                            setState(() {
                              _addressValidAndUnfocused = false;
                            });
                            Future<void>.delayed(
                                const Duration(milliseconds: 50), () {
                              FocusScope.of(context)
                                  .requestFocus(_addressFocusNode);
                            });
                          },
                          child: UIUtil.threeLinetextStyleSmallestW400Text(
                              context,
                              widget.address ?? _addressController!.text))
                      : null,
                ),
                // Enter Address Error Container
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(_addressValidationText!,
                      style: AppStyles.textStyleSize14W600Primary(context)),
                ),
              ],
            ),
          ),
          //A column with "Add Contact" and "Close" buttons
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Add Contact Button
                  AppButton.buildAppButton(
                      context,
                      AppButtonType.primary,
                      AppLocalization.of(context)!.addContact,
                      Dimens.buttonTopDimens, onPressed: () async {
                    if (await validateForm()) {
                      final Contact newContact = Contact(
                          name: _nameController!.text,
                          address: widget.address ?? _addressController!.text);
                      await sl.get<DBHelper>().saveContact(newContact);

                      EventTaxiImpl.singleton()
                          .fire(ContactAddedEvent(contact: newContact));
                      UIUtil.showSnackbar(
                          AppLocalization.of(context)!
                              .contactAdded
                              .replaceAll('%1', newContact.name!),
                          context);
                      EventTaxiImpl.singleton()
                          .fire(ContactModifiedEvent(contact: newContact));
                      Navigator.of(context).pop();
                    }
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  // Close Button
                  AppButton.buildAppButton(
                      context,
                      AppButtonType.primary,
                      AppLocalization.of(context)!.close,
                      Dimens.buttonBottomDimens, onPressed: () {
                    Navigator.pop(context);
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<bool> validateForm() async {
    bool isValid = true;
    // Address Validations
    // Don't validate address if it came pre-filled in
    if (widget.address == null) {
      if (_addressController!.text.isEmpty) {
        isValid = false;
        setState(() {
          _addressValidationText = AppLocalization.of(context)!.addressMissing;
        });
      } else if (!Address(_addressController!.text).isValid()) {
        isValid = false;
        setState(() {
          _addressValidationText = AppLocalization.of(context)!.invalidAddress;
        });
      } else {
        _addressFocusNode!.unfocus();
        final bool addressExists = await sl
            .get<DBHelper>()
            .contactExistsWithAddress(_addressController!.text);
        if (addressExists) {
          setState(() {
            isValid = false;
            _addressValidationText = AppLocalization.of(context)!.contactExists;
          });
        }
      }
    }
    // Name Validations
    if (_nameController!.text.isEmpty) {
      isValid = false;
      setState(() {
        _nameValidationText = AppLocalization.of(context)!.contactNameMissing;
      });
    } else {
      final bool nameExists =
          await sl.get<DBHelper>().contactExistsWithName(_nameController!.text);
      if (nameExists) {
        setState(() {
          isValid = false;
          _nameValidationText = AppLocalization.of(context)!.contactExists;
        });
      }
    }
    return isValid;
  }
}
