import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_app_bar.dart';

class UserScaffold extends StatelessWidget {

  final Widget? body;

  final String title;

  final bool showMenu;

  final bool isDateCollectionPage;

  const UserScaffold({super.key, required this.body, required this.title, this.showMenu = true, this.isDateCollectionPage = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.hexToColor(AppStrings.kRBPrimaryColor),
      body: Column(
        children: [
          CustomAppBar(title: title, showMenuIcon: showMenu,height: height*0.14, isDateCollectionPage: isDateCollectionPage,),
          Container(
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)], // Gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: height*0.03),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Utils.hexToColor('#fcfcfc'),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width*0.1),
                            topRight: Radius.circular(width*0.1),
                          )
                      ),
                      // color: Colors.white,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
                          child: SizedBox(
                              height: height*0.77,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, top: height*0.05),
                                child: SingleChildScrollView(child: body),
                              )
                          ),
                        ),
                      )
                  ),
                ),
              )
          )
        ],
      ),

    );
  }
}
