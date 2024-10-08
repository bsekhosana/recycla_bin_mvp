import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_drawer_list_tile.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';

import '../../features/authentication/data/models/rb_user_model.dart';
import '../../features/authentication/provider/rb_auth_provider.dart';
import '../../features/profile/provider/user_provider.dart';

import '../../../features/authentication/data/models/rb_user_model.dart' as local_user;

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
        Navigator.pushNamed(context, 'collections');
      case 2:
        Navigator.pushNamed(context, 'notifications');
      case 3:
        Navigator.pushNamed(context, 'profile');
      case 4:
        Navigator.pushNamed(context, 'settings');
      case 5:
        try {
          await context.read<RBAuthProvider>().logout(context);
          // Navigate to the login page after signing out
          Navigator.pushNamedAndRemoveUntil(context, '/landing', (Route<dynamic> route) => false);
          showCustomSnackbar(context, 'Logged out successfully', backgroundColor: Colors.orange);
        } catch (e) {
          showCustomSnackbar(context, 'Failed to logout with error: ${e.toString()}', backgroundColor: Colors.red);
        }

    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final RBUserModel? user = userProvider.user;
    print('current user provider: ${user.toString()}');
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
                        radius: width * 0.1,
                        backgroundImage: user?.profilePicture != null
                            ? NetworkImage(user!.profilePicture!)
                            : null,
                        child: user?.profilePicture == null
                            ? Text(
                          Utils.getInitials(user!.fullName),
                          style: TextStyle(fontSize: width * 0.1, color: Colors.green),
                        )
                            : null,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      user != null ? user.fullName : 'Test User',
                      style: TextStyle(
                          color: Utils.hexToColor(AppStrings.kRBSecondaryColor),
                          fontSize: width*0.045,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: height * 0.002),
                    Text(
                      user != null ? user.email : 'test@email.com',
                      style: TextStyle(
                          color: Utils.hexToColor(AppStrings.kRBSecondaryColor),
                          fontSize: width*0.045,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Divider(),
              // SizedBox(height: height * 0.01),
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
                icon: Icons.settings,
                title: 'Settings',
                isSelected: _selectedIndex == 4,
                onTap: () => _onItemTapped(4),
              ),
              CustomDrawerListTile(
                icon: Icons.logout,
                title: 'Logout',
                isSelected: _selectedIndex == 5,
                onTap: () => _onItemTapped(5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
