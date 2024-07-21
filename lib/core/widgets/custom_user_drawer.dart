import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';

import '../../features/authentication/provider/auth_provider.dart';

class CustomUserDrawer extends StatefulWidget {
  const CustomUserDrawer({super.key});

  @override
  State<CustomUserDrawer> createState() => _CustomUserDrawerState();
}

class _CustomUserDrawerState extends State<CustomUserDrawer> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: () async {
              try {
                await context.read<AuthProvider>().logout();
                // Navigate to the login page after signing out
                Navigator.pushNamedAndRemoveUntil(context, '/landing', (Route<dynamic> route) => false);
                showCustomSnackbar(context, 'Logged out success', backgroundColor: Colors.green);
              } catch (e) {
                showCustomSnackbar(context, 'Failed to logout with error: ${e.toString()}', backgroundColor: Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }
}
