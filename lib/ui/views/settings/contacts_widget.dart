// ignore_for_file: cancel_subscriptions, must_be_immutable

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// Package imports:
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
import 'package:archethic_wallet/ui/views/contacts/add_contact.dart';
import 'package:archethic_wallet/ui/views/contacts/contact_details.dart';
import 'package:archethic_wallet/ui/widgets/components/buttons.dart';
import 'package:archethic_wallet/ui/widgets/components/sheet_util.dart';

class ContactsList extends StatefulWidget {
  ContactsList(this.contactsController, this.contactsOpen, {Key? key})
      : super(key: key);

  final AnimationController contactsController;
  bool contactsOpen;

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _registerBus();
    // Initial contacts list
    _contacts = List<Contact>.empty(growable: true);
    _updateContacts();
  }

  @override
  void dispose() {
    if (_contactAddedSub != null) {
      _contactAddedSub!.cancel();
    }
    if (_contactRemovedSub != null) {
      _contactRemovedSub!.cancel();
    }
    super.dispose();
  }

  StreamSubscription<ContactAddedEvent>? _contactAddedSub;
  StreamSubscription<ContactRemovedEvent>? _contactRemovedSub;

  void _registerBus() {
    // Contact added bus event
    _contactAddedSub = EventTaxiImpl.singleton()
        .registerTo<ContactAddedEvent>()
        .listen((ContactAddedEvent event) {
      setState(() {
        _contacts!.add(event.contact!);
        //Sort by name
        _contacts!.sort((Contact a, Contact b) =>
            a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        StateContainer.of(context).updateContacts();
      });
      // Full update
      _updateContacts();
    });
    // Contact removed bus event
    _contactRemovedSub = EventTaxiImpl.singleton()
        .registerTo<ContactRemovedEvent>()
        .listen((ContactRemovedEvent event) {
      setState(() {
        _contacts!.remove(event.contact);
      });
    });
  }

  void _updateContacts() {
    sl.get<DBHelper>().getContacts().then((List<Contact> contacts) {
      for (Contact c in contacts) {
        if (!_contacts!.contains(c)) {
          setState(() {
            _contacts!.add(c);
          });
        }
      }
      // Re-sort list
      setState(() {
        _contacts!.sort((Contact a, Contact b) =>
            a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
                color: StateContainer.of(context).curTheme.primary30!,
                width: 1),
          ),
          color: StateContainer.of(context).curTheme.backgroundDark,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: StateContainer.of(context).curTheme.overlay30!,
                offset: const Offset(-5, 0),
                blurRadius: 20),
          ],
        ),
        child: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.035,
            top: 60,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10.0, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              widget.contactsOpen = false;
                            });
                            widget.contactsController.reverse();
                          },
                          child: FaIcon(FontAwesomeIcons.chevronLeft,
                              color:
                                  StateContainer.of(context).curTheme.primary,
                              size: 24)),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        AppLocalization.of(context)!.addressBookHeader,
                        style: AppStyles.textStyleSize28W700Primary(context),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // Contacts list + top and bottom gradients
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Contacts list
                    ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                      itemCount: _contacts!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Build contact
                        return buildSingleContact(context, _contacts![index]);
                      },
                    ),
                    //List Top Gradient End
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 20.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark!,
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark00!
                            ],
                            begin: const AlignmentDirectional(0.5, -1.0),
                            end: const AlignmentDirectional(0.5, 1.0),
                          ),
                        ),
                      ),
                    ),
                    //List Bottom Gradient End
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 15.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark00!,
                              StateContainer.of(context)
                                  .curTheme
                                  .backgroundDark!,
                            ],
                            begin: const AlignmentDirectional(0.5, -1.0),
                            end: const AlignmentDirectional(0.5, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    AppButton.buildAppButton(
                        context,
                        AppButtonType.primary,
                        AppLocalization.of(context)!.addContact,
                        Dimens.buttonBottomDimens, onPressed: () {
                      Sheets.showAppHeightNineSheet(
                          context: context, widget: const AddContactSheet());
                    }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSingleContact(BuildContext context, Contact contact) {
    return TextButton(
      onPressed: () {
        ContactDetailsSheet(contact).mainBottomSheet(context);
      },
      child: Column(children: <Widget>[
        Divider(
          height: 2,
          color: StateContainer.of(context).curTheme.primary15,
        ),
        // Main Container
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          margin: const EdgeInsetsDirectional.only(start: 12.0, end: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Contact info
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsetsDirectional.only(start: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Contact name
                      Text(contact.name!,
                          style: AppStyles.textStyleSize16W600Primary(context)),
                      //Contact address
                      Text(
                        contact.address!,
                        style: AppStyles.textStyleSize12W100Text60(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
