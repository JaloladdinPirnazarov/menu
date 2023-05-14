import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIElements {
  List<TextInputFormatter> all = [];
  List<TextInputFormatter> double_ = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}'))
  ];
  List<TextInputFormatter> digits_ = [FilteringTextInputFormatter.digitsOnly];

  Widget buildPlaceHolder(
      String labelText, List<TextInputFormatter> formatter, bool isEnabled) {
    return TextField(
      enabled: isEnabled,
      decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(0)))
      ),
      inputFormatters: formatter,
    );
  }

  Widget placeHolderRow(){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Одам сони", digits_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Масаллик номи", all, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Улчов бирлиги", all, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Бахоси", digits_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("1 одам ун", double_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Умумий микдор", double_, false),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Жами сумма", digits_, false),
        ),
        // остальные Expanded виджеты
      ],
    );
  }

  List<Widget> buildFoodPlaceHolders___(int rowCount, BuildContext context) {
    var list = <Widget>[];
    var item = Row(
      children: [
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Одам сони", digits_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Масаллик номи", all, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Улчов бирлиги", all, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Бахоси", digits_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("1 одам ун", double_, true),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Умумий микдор", double_, false),
        ),
        Expanded(
          flex: 1,
          child: buildPlaceHolder("Жами сумма", digits_, false),
        ),
        // остальные Expanded виджеты
      ],
    );

    for (int i = 0; i < rowCount; i++) {
      list.add(item);
    }

    return list;
  }

  Widget buildTitle(String title, double size) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: size,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Column buildMenu(String menuName, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: buildTitle(menuName, 20),
            )
          ],
        ),
        Expanded(
          // Обернуть buildFoodPlaceHolder в Expanded
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: buildTitle("1", 18),
              ),
              Expanded(
                flex: 1,
                child: buildPlaceHolder("Таом номи", all, true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
