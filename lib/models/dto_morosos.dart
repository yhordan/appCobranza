// ignore_for_file: camel_case_types

import 'package:app_leon_xiii/models/app_morosos.dart';
import 'package:app_leon_xiii/models/app_morosovisitas.dart';

class dto_morosos {
  final App_morosos morosos;
  final app_morosovisitas morosovisitas;

  dto_morosos({
    required this.morosos,
    required this.morosovisitas,
  });

  factory dto_morosos.fromJson(Map<String, dynamic> json) {
    return dto_morosos(
      morosos:App_morosos.fromJson(json["morosos"] as Map<String, dynamic>),
      morosovisitas:app_morosovisitas.fromJson(json["morosovisitas"] as Map<String, dynamic>),
    );
  }
}
