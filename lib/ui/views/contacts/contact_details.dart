// Dart imports:
import 'dart:async';

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
import 'package:archethic_wallet/model/data/appdb.dart';
import 'package:archethic_wallet/model/data/hive_db.dart';
import 'package:archethic_wallet/util/service_locator.dart';
import 'package:archethic_wallet/ui/util/styles.dart';
import 'package:archethic_wallet/ui/util/ui_util.dart';
import 'package:archethic_wallet/ui/views/transfer/transfer_uco_sheet.dart';
import 'package:archethic_wallet/ui/widgets/components/buttons.dart';
import 'package:archethic_wallet/ui/widgets/components/dialog.dart';
import 'package:archethic_wallet/ui/widgets/components/sheet_util.dart';
import 'package:archethic_wallet/util/case_converter.dart';

// Contact Details Sheet
class ContactDetailsSheet {
  ContactDetailsSheet(this.contact);

  Contact contact;

  // State variables
  bool _addressCopied = false;
  // Timer reference so we can cancel repeated events
  Timer? _addressCopiedTimer;

  void mainBottomSheet(BuildContext context) {
    Sheets.showAppHeightEightSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                minimum: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.035),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Trashcan Button
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsetsDirectional.only(
                              top: 10.0, start: 10.0),
                          child: TextButton(
                            onPressed: () {
                              AppDialogs.showConfirmDialog(
                                  context,
                                  AppLocalization.of(context)!.removeContact,
                                  AppLocalization.of(context)!
                                      .removeContactConfirmation
                                      .replaceAll('%1', contact.name!),
                                  CaseChange.toUpperCase(
                                      AppLocalization.of(context)!.yes,
                                      context), () {
                                sl
                                    .get<DBHelper>()
                                    .deleteContact(contact)
                                    .then((_) {
                                  EventTaxiImpl.singleton().fire(
                                      ContactRemovedEvent(contact: contact));
                                  EventTaxiImpl.singleton().fire(
                                      ContactModifiedEvent(contact: contact));
                                  UIUtil.showSnackbar(
                                      AppLocalization.of(context)!
                                          .contactRemoved
                                          .replaceAll('%1', contact.name!),
                                      context);
                                  Navigator.of(context).pop();
                                });
                              },
                                  cancelText: CaseChange.toUpperCase(
                                      AppLocalization.of(context)!.no,
                                      context));
                            },
                            child: FaIcon(FontAwesomeIcons.trash,
                                size: 24,
                                color: StateContainer.of(context)
                                    .curTheme
                                    .primary),
                          ),
                        ),
                        // The header of the sheet
                        Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 140),
                          child: Column(
                            children: <Widget>[
                              AutoSizeText(
                                AppLocalization.of(context)!.contactHeader,
                                style: AppStyles.textStyleSize24W700Primary(
                                    context),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                stepGranularity: 0.1,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),

                    // The main container that holds Contact Name and Contact Address
                    Expanded(
                      child: Container(
                        padding: const EdgeInsetsDirectional.only(
                            top: 4, bottom: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Contact Name container
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.105,
                                right:
                                    MediaQuery.of(context).size.width * 0.105,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                color: StateContainer.of(context)
                                    .curTheme
                                    .backgroundDarkest,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: StateContainer.of(context)
                                        .curTheme
                                        .backgroundDarkest!,
                                  )
                                ],
                              ),
                              child: Text(contact.name!,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.textStyleSize16W600Primary(
                                      context)),
                            ),
                            // Contact Address
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: contact.address));
                                setState(() {
                                  _addressCopied = true;
                                });
                                if (_addressCopiedTimer != null) {
                                  _addressCopiedTimer!.cancel();
                                }
                                _addressCopiedTimer = Timer(
                                    const Duration(milliseconds: 800), () {
                                  setState(() {
                                    _addressCopied = false;
                                  });
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.105,
                                    right: MediaQuery.of(context).size.width *
                                        0.105,
                                    top: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: StateContainer.of(context)
                                      .curTheme
                                      .backgroundDarkest,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: StateContainer.of(context)
                                          .curTheme
                                          .backgroundDarkest!,
                                    )
                                  ],
                                ),
                                child:
                                    UIUtil.threeLinetextStyleSmallestW400Text(
                                        context, contact.address!,
                                        type: _addressCopied
                                            ? ThreeLineAddressTextType
                                                .successFull
                                            : ThreeLineAddressTextType.primary),
                              ),
                            ),
                            // Address Copied text container
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                  _addressCopied
                                      ? AppLocalization.of(context)!
                                          .addressCopied
                                      : '',
                                  style: AppStyles.textStyleSize14W600Success(
                                      context)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            // Send Button
                            if (StateContainer.of(context)
                                    .wallet!
                                    .accountBalance
                                    .uco! >
                                0)
                              AppButton.buildAppButton(
                                  context,
                                  AppButtonType.primary,
                                  AppLocalization.of(context)!.send,
                                  Dimens.buttonTopDimens, onPressed: () {
                                Navigator.of(context).pop();
                                Sheets.showAppHeightNineSheet(
                                    context: context,
                                    widget: TransferUcoSheet(
                                        contactsRef: StateContainer.of(context)
                                            .contactsRef,
                                        localCurrency:
                                            StateContainer.of(context)
                                                .curCurrency,
                                        contact: contact));
                              })
                            else
                              const SizedBox(),
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
                ));
          });
        });
  }
}
