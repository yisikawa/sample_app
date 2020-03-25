import 'package:flutter/material.dart';
import '../constants/globals.dart' as globals;
import 'package:intl/intl.dart';

Future<void> selectDate(BuildContext context, Function updateFunc) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: globals.kSelectedDate,
    firstDate: DateTime(2018, 11),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != globals.kSelectedDate) {
    globals.kSelectedDate = picked;
    //ここで選択された値を変数なり、コントローラーに代入する
    globals.kTargetDate = DateFormat('yyyyMMdd').format(globals.kSelectedDate);
//        print('select date = ' + globals.kTargetDate);
    updateFunc;
  }
}
