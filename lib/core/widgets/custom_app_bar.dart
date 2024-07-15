import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool showMenuIcon;
  final bool isDateCollectionPage;

  const CustomAppBar({super.key, required this.title, this.height = kToolbarHeight, required this.showMenuIcon, this.isDateCollectionPage = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String day = DateFormat('EEE').format(now); // Mon, Tue, Wed, etc.
    String date = DateFormat('dd').format(now); // 01, 02, 03, etc.
    String month = DateFormat('MMM').format(now); // Jan, Feb, Mar, etc.
    String year = DateFormat('yyyy').format(now); // 2021, 2022, etc.
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading:  false,
        title: Transform.translate(
          offset: Offset(0, height*0.03),
            // child: title
        ),
        centerTitle: true,
        flexibleSpace: Container(
          child: Padding(
            padding: EdgeInsets.only(top: height*0.1),
            child: SizedBox(
              height: height*0.1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width*0.08,
                    ),

                    isDateCollectionPage ?
                    Row(
                      children: [

                        Text(date,
                          style: TextStyle(
                              fontSize: width*0.15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        SizedBox(
                          width: width*0.05,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height*0.01,
                            ),
                            Text(day,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: width*0.05,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text("$month $year",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: width*0.05,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(
                              height: height*0.013,
                            ),
                          ],
                        ),

                        SizedBox(
                          width: width*0.15,
                        ),

                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.25,
                          child: TextButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              padding: const EdgeInsets.all(10.0), // Adjust padding as needed
                              backgroundColor: Colors.white.withAlpha(30), // Set background color with opacity
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: width * 0.15,
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: width * 0.046,
                                  color: Colors.white,
                                  height: 1.2, // Adjust line height
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ) :

                    TextButton(
                      onPressed: () {
                        // Handle button press
                        if(!showMenuIcon) {
                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                        backgroundColor: Colors.white.withAlpha(30), // Set background color with opacity
                      ),
                      child: Image.asset(
                        showMenuIcon ? 'assets/images/icon/burger.png' : 'assets/images/icon/back.png',
                        width: width * 0.05, // Set the width of the image
                      ),
                    ),
                    SizedBox(
                      width: width*0.05,
                    ),

                    Text(title,
                      style: TextStyle(
                        fontSize: width*0.055,
                        color: Colors.white
                      ),
                    )
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}