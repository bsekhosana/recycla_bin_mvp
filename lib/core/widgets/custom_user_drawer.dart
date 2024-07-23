import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_drawer_list_tile.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';

import '../../features/authentication/provider/auth_provider.dart';
import '../../features/profile/provider/user_provider.dart';

import '../../../features/authentication/data/models/user.dart' as local_user;

class CustomUserDrawer extends StatefulWidget {

  final int selectedIndex;

  const CustomUserDrawer({super.key, required this.selectedIndex});

  @override
  State<CustomUserDrawer> createState() => _CustomUserDrawerState();
}

class _CustomUserDrawerState extends State<CustomUserDrawer> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    switch(index){
      case 0:
        Navigator.pushNamed(context, 'schedulecollection');
      case 1:
        Navigator.pushNamed(context, 'schedulecollection');
      case 2:
        Navigator.pushNamed(context, 'profile');
      case 3:
        Navigator.pushNamed(context, 'profile');
      case 4:
        try {
          await context.read<AuthProvider>().logout();
          // Navigate to the login page after signing out
          Navigator.pushNamedAndRemoveUntil(context, '/landing', (Route<dynamic> route) => false);
          showCustomSnackbar(context, 'Logged out success', backgroundColor: Colors.green);
        } catch (e) {
          showCustomSnackbar(context, 'Failed to logout with error: ${e.toString()}', backgroundColor: Colors.red);
        }

    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final local_user.User? user = userProvider.user;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _selectedIndex = widget.selectedIndex;

    return Drawer(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: -(width*0.5),
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/splash/logo.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.1),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0), // Space for the border
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Utils.hexToColor(AppStrings.kRBSecondaryColor),
                            width: 2.0),
                      ),
                      child: CircleAvatar(
                        radius: width * 0.15,
                        backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      user != null ? user.username : 'Test User',
                      style: TextStyle(
                          color: Utils.hexToColor(AppStrings.kRBSecondaryColor),
                          fontSize: 18),
                    ),
                    SizedBox(height: height * 0.002),
                    Text(
                      user != null ? user.email : 'test@email.com',
                      style: TextStyle(
                          color: Utils.hexToColor(AppStrings.kRBSecondaryColor),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              Divider(),
              SizedBox(height: height * 0.02),
              CustomDrawerListTile(
                icon: Icons.home,
                title: 'Home',
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              CustomDrawerListTile(
                icon: Icons.collections,
                title: 'Collections',
                isSelected: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              CustomDrawerListTile(
                icon: Icons.notifications,
                title: 'Notifications',
                isSelected: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              CustomDrawerListTile(
                icon: Icons.person,
                title: 'Profile',
                isSelected: _selectedIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
              CustomDrawerListTile(
                icon: Icons.logout,
                title: 'Logout',
                isSelected: _selectedIndex == 4,
                onTap: () => _onItemTapped(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
