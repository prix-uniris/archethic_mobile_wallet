// Flutter imports:
import 'dart:io';

import 'package:archethic_wallet/ui/widgets/components/icon_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:animate_do/animate_do.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Project imports:
import 'package:archethic_wallet/appstate_container.dart';
import 'package:archethic_wallet/localization.dart';
import 'package:archethic_wallet/util/service_locator.dart';
import 'package:archethic_wallet/ui/util/styles.dart';
import 'package:archethic_wallet/util/case_converter.dart';

class TransactionChainExplorerSheet extends StatefulWidget {
  const TransactionChainExplorerSheet({Key? key}) : super(key: key);

  @override
  _TransactionChainExplorerSheetState createState() =>
      _TransactionChainExplorerSheetState();
}

class _TransactionChainExplorerSheetState
    extends State<TransactionChainExplorerSheet> {
  int transactionsLength = 0;

  Future<List<Transaction>> _getTransactionChain() async {
    List<Transaction>? _transactions;
    _transactions = await sl
        .get<ApiService>()
        .getTransactionChain(StateContainer.of(context).wallet!.address, 0);
    transactionsLength = _transactions.length;
    return _transactions;
  }

  @override
  void initState() {
    _getTransactionChain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // A row for the address text and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Empty SizedBox
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
            ),
            if (kIsWeb || Platform.isMacOS || Platform.isWindows)
              Stack(
                children: <Widget>[
                  const SizedBox(
                    width: 60,
                    height: 40,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 10, right: 0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              buildIconDataWidget(
                                  context, Icons.close_outlined, 30, 30),
                            ],
                          ))),
                ],
              )
            else
              const SizedBox(
                width: 60,
                height: 40,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                child: AutoSizeText(
                  AppLocalization.of(context)!.transactionChainExplorerHeader,
                  textAlign: TextAlign.center,
                  style: AppStyles.textStyleSize24W700Primary(context),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: Center(
            child: Stack(children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SafeArea(
                    minimum: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.035,
                      top: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        _firstTimelineTile(
                          context,
                          const _IconIndicator(
                            iconData: Icons.last_page,
                            size: 25,
                          ),
                        ),
                        FutureBuilder<List<Transaction>>(
                          future: _getTransactionChain(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Transaction>> transactions) {
                            return Expanded(
                              child: Stack(
                                children: <Widget>[
                                  if (!transactions.hasData)
                                    const SizedBox()
                                  else
                                    FadeIn(
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 0),
                                        itemCount: transactions.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildTimelineTile(
                                            context,
                                            isLast: index ==
                                                    transactions.data!.length -
                                                        1
                                                ? true
                                                : false,
                                            indicator: const _IconIndicator(
                                              iconData: Icons
                                                  .arrow_circle_down_outlined,
                                              size: 25,
                                            ),
                                            dateTx: DateFormat.yMd(
                                                    Localizations.localeOf(
                                                            context)
                                                        .languageCode)
                                                .add_Hms()
                                                .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            transactions
                                                                    .data![
                                                                        index]
                                                                    .validationStamp!
                                                                    .timestamp! *
                                                                1000)
                                                    .toLocal())
                                                .toString(),
                                            address: transactions
                                                .data![index].address,
                                            balance: transactions
                                                .data![index].balance!.uco
                                                .toString(),
                                          );
                                        },
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
                                          begin: const AlignmentDirectional(
                                              0.5, -1.0),
                                          end: const AlignmentDirectional(
                                              0.5, 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
            ]),
          ),
        ),
      ],
    );
  }
}

Widget buildSingleTransaction(BuildContext context, Transaction transaction) {
  return Divider(
    height: 2,
    color: StateContainer.of(context).curTheme.primary15,
  );
}

TimelineTile _buildTimelineTile(
  BuildContext context, {
  _IconIndicator? indicator,
  String? dateTx,
  String? address,
  String? balance,
  bool isLast = false,
}) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    beforeLineStyle: LineStyle(color: Colors.white.withOpacity(0.7)),
    indicatorStyle: IndicatorStyle(
      indicatorXY: 0.3,
      drawGap: true,
      width: 30,
      height: 30,
      indicator: indicator,
    ),
    isLast: isLast,
    startChild: Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 10),
      child: Text(
        dateTx!,
        textAlign: TextAlign.right,
      ),
    ),
    endChild: Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            address!,
          ),
          const SizedBox(height: 4),
          Text(
            'UTXO: ' + balance! + ' UCO',
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}

TimelineTile _firstTimelineTile(
    BuildContext context, _IconIndicator? indicator) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    beforeLineStyle: LineStyle(color: Colors.white.withOpacity(0.7)),
    indicatorStyle: IndicatorStyle(
      indicatorXY: 0.3,
      drawGap: true,
      width: 30,
      height: 30,
      indicator: indicator,
    ),
    isFirst: true,
    startChild: Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 10),
      child: Text(
        AppLocalization.of(context)!.transactionChainExplorerLastAddress,
        textAlign: TextAlign.right,
      ),
    ),
    endChild: Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            CaseChange.toUpperCase(
                StateContainer.of(context).wallet!.address, context),
          ),
          const SizedBox(height: 4),
          const Text(
            '',
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({
    Key? key,
    this.iconData,
    this.size,
  }) : super(key: key);

  final IconData? iconData;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white,
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: StateContainer.of(context).curTheme.backgroundDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
