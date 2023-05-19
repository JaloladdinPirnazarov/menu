
import 'package:flutter/cupertino.dart';

class IngredientsControllers{
  TextEditingController ingredientName = TextEditingController();
  TextEditingController measureName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController forOnePerson = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  TextEditingController totalCost = TextEditingController();
}

class FoodControllers{
  List<IngredientsControllers> ingredientsControllers = <IngredientsControllers>[];
  TextEditingController foodCountController = TextEditingController();
  String foodName = "";
  double onePersonCost = 0;
  double totalCost = 0;
  int personCount = 0;
}


