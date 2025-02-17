// Package imports:
import 'package:archethic_lib_dart/archethic_lib_dart.dart' show Balance;
import 'package:event_taxi/event_taxi.dart';

// Project imports:
import 'package:archethic_wallet/model/data/hive_db.dart';

class BalanceGetEvent implements Event {
  BalanceGetEvent({this.response, this.account});

  final Account? account;
  final Balance? response;
}
