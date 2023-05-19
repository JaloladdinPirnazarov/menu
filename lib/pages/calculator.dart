import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu/others/actions.dart';
import 'package:menu/ui/ui_elements.dart';
import '../others/text_field_items.dart';

class Calculator extends StatefulWidget {
  List<FoodControllers> breakfast;
  List<FoodControllers> lunch;
  List<FoodControllers> dinner;

  Calculator(this.breakfast, this.lunch, this.dinner);

  @override
  State<Calculator> createState() => _CalculatorState(breakfast, lunch, dinner);
}

class _CalculatorState extends State<Calculator> {
  List<FoodControllers> breakfast;
  List<FoodControllers> lunch;
  List<FoodControllers> dinner;
  _CalculatorState(this.breakfast, this.lunch, this.dinner);

  UIElements elements = UIElements();
  Actions_ actions = Actions_();
  bool calculated = true;
  double breakfastTotal = 0;
  double lunchTotal = 0;
  double dinnerTotal = 0;
  double dayTotalCost = 0;
  @override
  void initState() {
    super.initState();
    debugPrint("breakBastSize: ${breakfast[0].ingredientsControllers.length}");
    debugPrint("lunchBastSize: ${lunch.length}");
    debugPrint("dinnerBastSize: ${dinner.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),
        child: Column(
          children: [
            Expanded(child: ListView(
              children: [
                elements.buildTitle("ЭРТАЛАБГИ НОНУШТА", 25, "assets/img.png"),
                SizedBox(
                  height: 20,
                ),
                Column(children: elements.buildMenu(breakfast)),
                SizedBox(height: 10,),
                elements.buildTotalText("Нонушта жами: ${actions.formatNumber(breakfastTotal.toString())}",false),
                SizedBox(
                  height: 30,
                ),
                elements.buildTitle("ТУШЛИК", 25, "assets/img_1.png"),
                SizedBox(
                  height: 20,
                ),
                Column(children: elements.buildMenu(lunch)),
                SizedBox(height: 10,),
                elements.buildTotalText("тушлик жами: ${actions.formatNumber(lunchTotal.toString())}",false),
                SizedBox(
                  height: 30,
                ),
                elements.buildTitle("КЕЧГИ ОВКАТ", 25, "assets/img_2.png"),
                SizedBox(
                  height: 20,
                ),
                Column(children: elements.buildMenu(dinner)),
                SizedBox(height: 10,),
                elements.buildTotalText("Кечги овкат жами: ${actions.formatNumber(dinnerTotal.toString())}",false),
                SizedBox(
                  height: 20,
                ),
              ],
            ),),
            elements.buildTotalText("Бир кунлик жами сумма: ${actions.formatNumber(dayTotalCost.toString())}",true),
            ElevatedButton(
              child: Text(
                "HISOBLASH",
                style: TextStyle(fontSize: 30),
              ),
              onPressed: ()=>calculateClicked(),
            ),
          ],
        ),
      ),
    );
  }

  void calculateClicked(){
    dayTotalCost = 0;
    var tempCost = calculate(breakfast);
    if(calculated){
      setState(() {
        breakfastTotal = tempCost;
        dayTotalCost += tempCost;
      });
    }
    tempCost = calculate(lunch);
    if(calculated){
      setState(() {
        lunchTotal = tempCost;
        dayTotalCost += tempCost;
      });
    }
    tempCost = calculate(dinner);
    if(calculated){
      setState(() {
        dinnerTotal = tempCost;
        dayTotalCost += tempCost;
      });
    }
    if(!calculated){
      actions.showErrorAlertDialog(context,"Илтимос барча майдонларни толдиринг");
      calculated = true;
    }else{
      actions.showIsExportAlertDialog(context,breakfast, lunch, dinner);
    }
  }

  double calculate(List<FoodControllers> menu) {
    double totalCost = 0;
        for (int i = 0; i < menu.length; i++) {
      var food = menu[i];
      double onePersonCost = 0;
      double allPersonCost = 0;
      if (!calculated) {
        break;
      }
      for (int q = 0; q < food.ingredientsControllers.length; q++) {
        double ingredientAmount = 0;
        double ingredientTotalCost = 0;
        var ingredient = food.ingredientsControllers[q];
        if (actions.isNotEmpty(food.ingredientsControllers[q])) {
           ingredientAmount = double.parse(ingredient.forOnePerson.text) * food.personCount;
           ingredientTotalCost = ingredientAmount * double.parse(ingredient.price.text);
           onePersonCost += ingredientTotalCost / food.personCount;
          ingredient.totalAmount.text = ingredientAmount.toString();
          ingredient.totalCost.text = ingredientTotalCost.toString();
          allPersonCost = onePersonCost * food.personCount;
        } else {
          calculated = false;
          break;
        }
      }
      totalCost += allPersonCost;
      setState(() {
        food.onePersonCost = onePersonCost;
        food.totalCost = allPersonCost;
      });
    }
    return totalCost;
  }
}
