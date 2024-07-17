import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_app_bar.dart';

class UserScaffold extends StatefulWidget {

  final Widget? body;

  final String title;

  final bool showMenu;

  final bool isDateCollectionPage;


  const UserScaffold({super.key, required this.body, required this.title, this.showMenu = true, this.isDateCollectionPage = false});

  @override
  State<UserScaffold> createState() => _UserScaffoldState();
}

class _UserScaffoldState extends State<UserScaffold> with SingleTickerProviderStateMixin  {

  int _selectedIndex = 0;

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

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
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'profile-pic',
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tanjina Hemi',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'hemi02@gmail.com',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.green : null),
              title: Text('Home', style: TextStyle(color: _selectedIndex == 0 ? Colors.green : null)),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pushNamed(context, 'schedulecollection');
              },
            ),
            ListTile(
              leading: Icon(Icons.collections, color: _selectedIndex == 1 ? Colors.green : null),
              title: Text('Collections', style: TextStyle(color: _selectedIndex == 1 ? Colors.green : null)),
              selected: _selectedIndex == 1,
              onTap: ()  {
                Navigator.pushNamed(context, 'schedulecollection');
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: _selectedIndex == 2 ? Colors.green : null),
              title: Text('Notifications', style: TextStyle(color: _selectedIndex == 2 ? Colors.green : null)),
              selected: _selectedIndex == 2,
              onTap: ()  {
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.green : null),
              title: Text('Profile', style: TextStyle(color: _selectedIndex == 3 ? Colors.green : null)),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: _selectedIndex == 4 ? Colors.green : null),
              title: Text('Logout', style: TextStyle(color: _selectedIndex == 4 ? Colors.green : null)),
              selected: _selectedIndex == 4,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/landing', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
