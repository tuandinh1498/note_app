import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class StringFormat{
  static String dateFormatter(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return DateFormat.yMMMd().format(
        DateTime.now(),
      );
    }
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  static String capitalizedString(String string){
    return string.substring(0, 1).toUpperCase() + string.substring(1).toLowerCase();
  }


}