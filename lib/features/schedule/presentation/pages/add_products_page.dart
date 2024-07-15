import 'package:flutter/material.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';

import '../../../../core/widgets/user_scaffold.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({super.key});

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  int selectedIndex = -1;
  final List<String> images = [
    'assets/images/7up.png', // Update these paths to match your assets
    'assets/images/coke.png',
    'assets/images/fanta.png',
    'assets/images/milk.png',
    'assets/images/sprite.png',
    'assets/images/coke_bottle.png',
  ];



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
        body: Column(
          children: [
            SizedBox(
              height: height*0.013,
            ),

            Container(
              decoration: BoxDecoration(
                color: Utils.hexToColor("#f3ffdc"),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              // padding: EdgeInsets.all(10),
              height: height*0.3,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: width*0.04, right: width*0.04),
                child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndex == index ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(
              height: height*0.13,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    'OR', style: TextStyle(
                    color: Colors.grey,
                    // fontWeight: FontWeight.w700,
                    fontSize: width*0.04
                  ),
                  ),
                ),

                SizedBox(
                  height: height*0.02,
                ),

                CustomElevatedButton(
                    text: 'Scan Product',
                    onPressed: (){

                    },
                    primaryButton: true
                ),

                SizedBox(
                  height: height*0.02,
                ),

                Center(
                  child: Text(
                    'OR', style: TextStyle(
                      color: Colors.grey,
                      // fontWeight: FontWeight.w700,
                      fontSize: width*0.04
                  ),
                  ),
                ),

                SizedBox(
                  height: height*0.02,
                ),

                CustomElevatedButton(
                    text: 'Add Product',
                    onPressed: (){

                    },
                    primaryButton: false
                ),
              ],
            )
          ],
        ),
        title: 'Products',
        showMenu: false,
    );
  }
}
