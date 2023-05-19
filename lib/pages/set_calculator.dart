import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu/others/actions.dart';
import 'package:menu/others/text_field_items.dart';
import 'package:menu/pages/calculator.dart';
import 'package:menu/ui/ui_elements.dart';

class SetCalculator extends StatefulWidget {
  const SetCalculator({Key? key}) : super(key: key);

  @override
  State<SetCalculator> createState() => _SetCalculatorState();
}

class _SetCalculatorState extends State<SetCalculator> {
  List<TextEditingController> foodCountControllers = <TextEditingController>[];
  List<TextEditingController> personCountControllers = <TextEditingController>[];
  List<TextEditingController> nameControllers = <TextEditingController>[];
  int foodCount = 0;
  UIElements elements = UIElements();
  Actions_ actions = Actions_();
  int counter = 1;
  TextEditingController menuFoodCountController = TextEditingController();

  List<FoodControllers> breakfast = <FoodControllers>[];
  List<FoodControllers> lunch = <FoodControllers>[];
  List<FoodControllers> dinner = <FoodControllers>[];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Set calculator"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              width: size.width / 2,
              height: size.height / 1.2,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey, width: 2)),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  elements.buildProgress(counter),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width / 2.2,
                    padding: EdgeInsets.only(left: 2),
                    child: TextField(
                        onChanged: (value) {
                          onChange(value);
                        },
                        controller: menuFoodCountController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.restaurant_outlined),
                          labelText: "Таом сонини киритинг Макс. 10",
                          labelStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(0))),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          NumberRangeInputFormatter(10),
                        ]),
                  ), //Food count
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: elements.buildFoodIngredientsPlaceHolders(
                                foodCountControllers, personCountControllers,nameControllers,
                                size.width / 2.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          child: Text("ОРКАГА"),
                          onPressed: previous,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          child: Text((counter == 3 ? "ЯРАТИШ" : "КЕЙИНГИ")),
                          onPressed: next,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }

  void onChange(String value) {
    foodCount = value.isNotEmpty ? int.parse(value) : 0;
    setState(() {
      foodCountControllers = actions.getControllers(foodCount);
      nameControllers = actions.getControllers(foodCount);
      personCountControllers = actions.getControllers(foodCount);
    });
  }

  void next() {
    print("breakfast: ${breakfast.length}");
    print("lunch: ${lunch.length}");
    print("dinner: ${dinner.length}");

    if (checkValues() && foodCount != 0) {
      if (counter != 4) {
        setState(() {
          counter++;
          menuFoodCountController.text = "";
          onChange("");
        });
      }
      if (counter == 4) {
        setState(() {
          foodCountControllers.clear();
          nameControllers.clear();
          counter = 1;
          menuFoodCountController.text = "";
          onChange("");
        });
        var route = MaterialPageRoute(
            builder: (context) => Calculator(breakfast, lunch, dinner));
        Navigator.push(context, route);
      }
    }
  }

  void previous() {
    if (counter != 1) {
      setState(() {
        foodCountControllers.clear();
        nameControllers.clear();
        personCountControllers.clear();
        counter--;
        menuFoodCountController.text = "";
        onChange("");
      });
    }
  }

  bool checkValues() {
    List<FoodControllers> menu = <FoodControllers>[];
    bool correct = true;
    for (int i = 0; i < foodCountControllers.length; i++) {
      if (foodCountControllers[i].text.isNotEmpty &&
          nameControllers[i].text.length >= 2 &&
          personCountControllers[i].text.isNotEmpty) {
        int c = int.parse(foodCountControllers[i].text);
        FoodControllers food = FoodControllers();
        food.ingredientsControllers = actions.getIngredientsControllers(c);
        food.foodName = nameControllers[i].text;
        food.personCount = int.parse(personCountControllers[i].text);
        menu.add(food);
      } else {
        correct = false;
        break;
      }
    }

    if (correct) {
      switch (counter) {
        case 1:
          breakfast.clear();
          breakfast.addAll(menu);
          break;
        case 2:
          lunch.clear();
          lunch.addAll(menu);
          break;
        case 3:
          dinner.clear();
          dinner.addAll(menu);
          break;
      }
      foodCountControllers.clear();
    }
    debugPrint("menu: ${menu.length}");
    debugPrint("breakfast: ${breakfast.length}");
    return correct;
  }
}
