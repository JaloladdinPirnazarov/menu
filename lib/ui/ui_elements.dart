import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu/others/text_field_items.dart';

class NumberRangeInputFormatter extends TextInputFormatter {
  int maxValue;

  NumberRangeInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final intValue = int.tryParse(newValue.text);
    if (intValue != null && intValue >= 1 && intValue <= maxValue) {
      return newValue;
    } else if (newValue.text.isEmpty) {
      // Allow deleting the last digit
      return newValue;
    }
    return oldValue;
  }
}

class UIElements {
  List<TextInputFormatter> all = [];
  List<TextInputFormatter> digits_ = [FilteringTextInputFormatter.digitsOnly];
  List<TextInputFormatter> double_ = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}'))
  ];

  Widget buildPlaceHolder(String labelText, List<TextInputFormatter> formatter,
      bool isEnabled, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(0)))),
      inputFormatters: formatter,
    );
  }

  Widget buildTitle(String title, double size,String image) {
    return Row(
      children: [
        Image.asset(
         image,
         width: 60,
         height: 60,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: size, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> buildIngredientsPlaceholders(
    List<IngredientsControllers> controllers,
  ) {
    TextEditingController dummyController = TextEditingController();
    var list = <Widget>[
      Row(
        children: [

          Expanded(
            flex: 1,
            child:
                buildPlaceHolder("Масаллик номи", all, false, dummyController),
          ),
          Expanded(
            flex: 1,
            child:
                buildPlaceHolder("Улчов бирлиги", all, false, dummyController),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("Бахоси", digits_, false, dummyController),
          ),
          Expanded(
            flex: 1,
            child:
                buildPlaceHolder("1 одам ун", double_, false, dummyController),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder(
                "Умумий микдор", double_, false, dummyController),
          ),
          Expanded(
            flex: 1,
            child:
                buildPlaceHolder("Жами сумма", digits_, false, dummyController),
          ),
        ],
      )
    ];
    ;

    for (int i = 0; i < controllers.length; i++) {
      IngredientsControllers controller = controllers[i];
      list.add(Row(
        children: [
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", all, true, controller.ingredientName),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", all, true, controller.measureName),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", digits_, true, controller.price),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", double_, true, controller.forOnePerson),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", double_, false, controller.totalAmount),
          ),
          Expanded(
            flex: 1,
            child: buildPlaceHolder("", digits_, false, controller.totalCost),
          ),
        ],
      ));
    }

    return list;
  }

  List<Widget> buildMenu(
    List<FoodControllers> controller,
  ) {
    List<Widget> list = <Widget>[];

    for (int i = 0; i < controller.length; i++) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Таом номи: ${controller[i].foodName}",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
        Text(
          "Одам сони: ${controller[i].personCount}",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: buildIngredientsPlaceholders(
                controller[i].ingredientsControllers),
          ),
          SizedBox(
            height: 20,
          ),
          buildTotalText("1 та одам учун: ${controller[i].onePersonCost}", false),
          SizedBox(
            height: 20,
          ),
          buildTotalText("${controller[i].personCount} та одам учун: ${controller[i].totalCost}", false)
        ],
      ));
    }

    return list;
  }

  Widget buildDividerLine() {
    return Expanded(
        child: Container(
      width: double.infinity,
      height: 2,
      color: Colors.black,
    ));
  }

  Widget buildCircleText(String count) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
      child: Text(
        count,
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget buildCircleTick() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      child: Icon(
        Icons.done,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget buildStick(Color color) {
    return Container(
      color: color,
      width: 45,
      height: 4,
    );
  }

  Widget buildProgress(int counter) {
    String title = "";
    switch (counter) {
      case 1:
        title = "ЭРТАЛАБКИ НОНУШТА";
        break;
      case 2:
        title = "ТУШЛИК";
        break;
      default :
        title = "КЕЧГИ ОВКАТ";
        break;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            counter > 1 ? buildCircleTick() : buildCircleText("1"),
            buildStick(counter > 1 ? Colors.blue : Colors.blueGrey),
            counter > 2 ? buildCircleTick() : buildCircleText("2"),
            buildStick(counter > 2 ? Colors.blue : Colors.blueGrey),
            buildCircleText("3")
          ],
        ),
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 20),
        )
      ],
    );
  }

  List<Widget> buildFoodIngredientsPlaceHolders(
      List<TextEditingController> countControllers,
      List<TextEditingController> personCountControllers,
      List<TextEditingController> nameControllers,

      double width) {
    List<Widget> list = <Widget>[];
    for (int i = 0; i < countControllers.length; i++) {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                width: width * 0.40,
                padding: EdgeInsets.only(right: 4),
                child: TextField(
                  controller: nameControllers[i],
                  decoration: InputDecoration(
                      labelText: "${i + 1} нчи таом номини киритинг",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(0)))),
                )),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                width: width * 0.30,
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: TextField(
                  controller: personCountControllers[i],
                  decoration: InputDecoration(
                      labelText: "Одам сонини киритинг",
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(0)))),
                  inputFormatters: digits_,
                )),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                width: width * 0.30,
                padding: EdgeInsets.only(left: 4),
                child: TextField(
                  controller: countControllers[i],
                  decoration: InputDecoration(
                      labelText: "масалликлар сони (макс. 30)",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(0)))),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeInputFormatter(30),
                  ],
                )),
          ],
        ),
      );
    }
    return list;
  }

  Widget buildTotalText(String txt, bool isBold){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(txt, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: isBold ? FontWeight.bold: FontWeight.normal),),
        ),
      ],
    );
  }
}
