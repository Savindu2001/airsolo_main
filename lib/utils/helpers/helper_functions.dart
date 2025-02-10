import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class AHelperFunctions {

  
  
  static void showSnackBar(String message){
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message){
    showDialog(
      context: Get.context!, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('OK'),
              )
          ],
        );
      }
      );
  }

  static  void navigateToScreen (BuildContext context, Widget screen){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => screen ),
      );
  }

  static String truncateText(String text,int maxLength){
    if (text.length <= maxLength){
      return text;
    }else{
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd-MM-yyyy'}){
    return DateFormat(format).format(date);
  }

  static List<A> removeDuplicates<A> (List<A> list){
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSizes){
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSizes){
      final rowChildren = widgets.sublist(i, i + rowSizes > widgets.length ? widgets.length : i + rowSizes);
      wrappedList.add(Row(children: rowChildren,));
    }
    return wrappedList;
  }
}