import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_app_bar.dart';
import 'package:recycla_bin/core/widgets/custom_user_drawer.dart';

class UserScaffold extends StatefulWidget {

  final Widget? body;

  final String title;

  final bool showMenu;

  final bool isDateCollectionPage;

  final int selectedIndex;

  const UserScaffold({super.key,
    required this.body,
    required this.title,
    this.selectedIndex = 0,
    this.showMenu = true,
    this.isDateCollectionPage = false});

  @override
  State<UserScaffold> createState() => _UserScaffoldState();
}

class _UserScaffoldState extends State<UserScaffold> with SingleTickerProviderStateMixin  {


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.hexToColor(AppStrings.kRBThirdColor),
      body: Column(
        children: [
          CustomAppBar(title: widget.title, showMenuIcon: widget.showMenu,height: height*0.14, isDateCollectionPage: widget.isDateCollectionPage,),
          Container(
              width: width,
              decoration: BoxDecoration(
                color: Utils.hexToColor(AppStrings.kRBThirdColor),
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
                                padding: EdgeInsets.only(left: 5, top: height*0.035),
                                child: SingleChildScrollView(child: widget.body),
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
      drawer: CustomUserDrawer(selectedIndex: widget.selectedIndex,),
    );
  }
}
