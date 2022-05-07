import 'package:flutter/material.dart';
import 'package:grecipe/src/controller/food_vision_ing_controller.dart';
import 'package:grecipe/src/data/model/recipe_model.dart';
import 'package:grecipe/src/controller/fv_recipe_controller.dart';
import 'package:get/get.dart';
import 'package:grecipe/src/data/list.dart';
import 'package:grecipe/src/ui/widget/landing_page.dart';

class foodVisionRecipePage extends StatelessWidget {
  final fvRecipeController =
      Get.put(FoodVisionRecipeController(), permanent: false);
  final fvingController = Get.put(FoodVisionIngController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(children: [
              AppBar(
                leading: BackButton(
                  color: mainColor,
                  onPressed: () {
                    Get.back();
                  },
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.star_border_outlined,
                        color: mainColor,
                      ))
                ],
              ),
              SingleChildScrollView(
                  child: recipes(fvRecipeController.selectedRecipe.value)),
            ]),
          ),
        ),
      ),
    );
  }

  recipes(index) {
    return FutureBuilder<Recipes>(
      future: fvRecipeController.recipe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> result = [];
          for (int i = 0; i < 1358; i++) {
            int count = 0;
            result = snapshot.data!.COOKRCP02.row
                .elementAt(i)
                .RCPPARTSDTLS
                .split(',');
            for (int j = 0; j < result.length; j++) {
              for (int k = 0; k < fvingController.ingResult.length - 1; k++) {
                //if(k ==0){ingDbController.ingResult.add('${dataBox.value.toMap()[k]?.toString().split(',')[1].substring(17).toString()}');}
                if (result[j].contains(fvingController.ingResult[k])) {
                  // include로 변경
                  count++;
                }
              }
              if (count == result.length) {
                print(
                    'here2 $result, ${result.length}, ${snapshot.data!.COOKRCP02.row.elementAt(i).RCPNM}');
              }
            }
          }
          return Column(
            children: [
              SizedBox(
                width: displayWidth,
                height: displayHeight * 0.2,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.network(snapshot.data!.COOKRCP02.row
                        .elementAt(index)
                        .ATTFILENOMAIN)),
              ),
              Container(
                width: displayWidth * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    //Text(recipeController.recipe.asStream().toString()),
                    Container(
                        width: displayWidth * 0.8,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10, bottom: 13),
                        child: Text(
                          snapshot.data!.COOKRCP02.row.elementAt(index).RCPNM,
                          style: TextStyle(
                              fontSize: displayHeight * 0.025,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "재료",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: displayHeight * 0.02,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(snapshot.data!.COOKRCP02.row
                            .elementAt(index)
                            .RCPPARTSDTLS)),
                    Container(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        alignment: Alignment.center,
                        child: Text(
                          "조리순서",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: displayHeight * 0.02,
                              fontWeight: FontWeight.bold),
                        )),
                    ...manualList(snapshot, index),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // 기본적으로 로딩 Spinner를 보여줍니다.
        return const CircularProgressIndicator();
      },
    );
  }
}

List<Widget> manualList(snapshot, index) {
  var manualWigets = <Widget>[];
  for (int i = 1; i <= 20; i++) {
    String manual = 'MANUAL' + i.toString();
    String manualImg = 'MANUAL_IMG' + i.toString();
    if (i < 10) {
      manual = 'MANUAL0' + i.toString();
      manualImg = 'MANUAL_IMG0' + i.toString();
    }
    var a = snapshot.data!.COOKRCP02.row.elementAt(index).get(manual);
    var b = snapshot.data!.COOKRCP02.row.elementAt(index).get(manualImg);
    if (a != '' && b != '') {
      manualWigets.add(Text(a));
      manualWigets.add(SizedBox(
        height: displayHeight * 0.05,
      ));
      manualWigets.add(Image.network(b));
    } else if (a != '' && b == '') {
      manualWigets.add(Text(a));
      manualWigets.add(SizedBox(
        height: displayHeight * 0.05,
      ));
    }
  }
  return manualWigets;
}
