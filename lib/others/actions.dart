import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu/others/text_field_items.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:excel/excel.dart';

import 'package:url_launcher/url_launcher.dart';

class Actions_ {
  List<TextEditingController> getControllers(int count) {
    List<TextEditingController> list = <TextEditingController>[];
    for (int i = 0; i < count; i++) {
      list.add(TextEditingController());
    }
    return list;
  }

  List<IngredientsControllers> getIngredientsControllers(int count) {
    List<IngredientsControllers> list = <IngredientsControllers>[];
    for (int i = 0; i < count; i++) {
      list.add(IngredientsControllers());
    }
    return list;
  }

  bool isNotEmpty(IngredientsControllers controllers) {
    bool calculated = true;

    if (controllers.ingredientName.text.isEmpty) {
      calculated = false;
    }
    if (controllers.measureName.text.isEmpty) {
      calculated = false;
    }
    if (controllers.price.text.isEmpty) {
      calculated = false;
    }
    if (controllers.forOnePerson.text.isEmpty) {
      calculated = false;
    }

    return calculated;
  }


  String formatNumber(String numberString) {
    var number = double.tryParse(numberString.replaceAll(',', '.'));
    var formatter = NumberFormat('# ##0.###', 'en_US');
    return formatter.format(number);
  }

  void showErrorAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Хатолик'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ок"))
          ],
        );
      },
    );
  }

  void showIsExportAlertDialog(
      BuildContext context,
      List<FoodControllers> breakfast,
      List<FoodControllers> lunch,
      List<FoodControllers> dinner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Меню мувафакийатли хисобланди'),
          content: Text("Менью ни excel файлига экспорт килишни хохлайсизми?"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showSaveAlertDialog(context, breakfast, lunch, dinner);
                },
                child: Text("ха")
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("йок")
            ),
          ],
        );
      },
    );
  }


  void showSaveAlertDialog(
      BuildContext context,
      List<FoodControllers> breakfast,
      List<FoodControllers> lunch,
      List<FoodControllers> dinner
      ) {
    TextEditingController menuNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Меню номини киритинг'),
          content: TextField(
            controller: menuNameController,
            decoration: InputDecoration(hintText: 'Меню номи'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Бекор килиш'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('давом этиш'),
              onPressed: () {
                String menuName = menuNameController.text;
                if(menuName.isNotEmpty){
                  exportToExcel(menuName, breakfast, lunch, dinner);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> exportToExcel(
      String menuName,
      List<FoodControllers> breakfast,
      List<FoodControllers> lunch,
      List<FoodControllers> dinner) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    double breakfastTotalCost = 0;
    double lunchTotalCost = 0;
    double dinnerTotalCost = 0;

    //Breakfast
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','ЭРТАЛАБГИ НОНУШТА','','','']);
    sheet.appendRow(['','','','','','']);
    for(int i = 0; i < breakfast.length ; i++){
      var food = breakfast[i];
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Таом номи','${food.foodName}']);
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Одам сони','Масалик номи','Улчов бирлиги','Бахоси','Бир одам учун','Умумий микдор','Жами сумма']);
      for(int q = 0; q < food.ingredientsControllers.length;q++){
        var ingredient = food.ingredientsControllers[q];
        sheet.appendRow([food.personCount,ingredient.ingredientName.text,ingredient.measureName.text,ingredient.price.text,ingredient.forOnePerson.text,ingredient.totalAmount.text,ingredient.totalCost.text]);
      }
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['${food.personCount} та одам учун','${food.totalCost}','','','','1 та одам учун','${food.onePersonCost}']);
      sheet.appendRow(['','','','','','']);
      //sheet.appendRow(['','','','','','${food.personCount} та одам учун: ${food.totalCost}']);
      breakfastTotalCost += food.totalCost;
    }
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','Нонушта жами','$breakfastTotalCost']);


    //Lunch
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','ТУШЛИК','','','']);
    sheet.appendRow(['','','','','','']);
    for(int i = 0; i < lunch.length ; i++){
      var food = lunch[i];
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Таом номи','${food.foodName}']);
      sheet.appendRow(['Одам сон: ${food.personCount}']);
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Одам сони','Масалик номи','Улчов бирлиги','Бахоси','Бир одам учун','Умумий микдор','Жами сумма']);
      for(int q = 0; q < food.ingredientsControllers.length;q++){
        var ingredient = food.ingredientsControllers[q];
        sheet.appendRow([food.personCount,ingredient.ingredientName.text,ingredient.measureName.text,ingredient.price.text,ingredient.forOnePerson.text,ingredient.totalAmount.text,ingredient.totalCost.text]);
      }
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['${food.personCount} та одам учун','${food.totalCost}','','','','1 та одам учун','${food.onePersonCost}']);
      //sheet.appendRow(['','','','','','${food.personCount} та одам учун: ${food.totalCost}']);
      lunchTotalCost += food.totalCost;
    }
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','Тушлик жами','$lunchTotalCost']);

    //Breakfast
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','КЕЧГИ ОВКАТ','','','']);
    sheet.appendRow(['','','','','','']);
    for(int i = 0; i < dinner.length ; i++){
      var food = dinner[i];
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Таом номи','${food.foodName}']);
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['Одам сони','Масалик номи','Улчов бирлиги','Бахоси','Бир одам учун','Умумий микдор','Жами сумма']);
      for(int q = 0; q < food.ingredientsControllers.length;q++){
        var ingredient = food.ingredientsControllers[q];
        sheet.appendRow([food.personCount,ingredient.ingredientName.text,ingredient.measureName.text,ingredient.price.text,ingredient.forOnePerson.text,ingredient.totalAmount.text,ingredient.totalCost.text]);
      }
      sheet.appendRow(['','','','','','']);
      sheet.appendRow(['${food.personCount} та одам учун','${food.totalCost}','','','','1 та одам учун','${food.onePersonCost}']);
      //sheet.appendRow(['','','','','','${food.personCount} та одам учун: ${food.totalCost}']);
      dinnerTotalCost += food.totalCost;
    }
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','Кечги овкат жами','${breakfastTotalCost + lunchTotalCost + dinnerTotalCost}']);
    sheet.appendRow(['','','','','','']);
    sheet.appendRow(['','','','','','Менью жами','${breakfastTotalCost + dinnerTotalCost + lunchTotalCost}']);

    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/$menuName.xlsx');
    await file.writeAsBytes(excel.save()!);

    String filePath = file.path;
    open(file.path);
    print('File exported at path: $filePath');
  }

  void open(String path) async {
    if (Platform.isWindows) {
      await Process.run('explorer.exe', [path]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [path]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [path]);
    }
  }








}
