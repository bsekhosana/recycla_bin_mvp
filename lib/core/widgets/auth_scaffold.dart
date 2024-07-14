import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';

class AuthScaffold extends StatelessWidget {

  final Widget? body;

  const AuthScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.hexToColor(AppStrings.kRBPrimaryColor),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: width*0.22,
        leading: IconButton(
          icon: Padding(
              padding: const EdgeInsets.only(top: 16),
            child: Icon(
              Icons.chevron_left,
              size: width*0.11,
            ),
          ),
          onPressed: () => {
            Navigator.of(context).pop()
          },
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)], // Gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.only(top: height*0.2),
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
                    child: body,
                  ),
                )
              ),
            ),
          )
      )
    );
  }
}
