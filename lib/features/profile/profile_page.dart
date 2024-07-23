import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/widgets/custom_user_drawer.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

import '../../core/utilities/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? _tabController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.hexToColor(AppStrings.kRBThirdColor),
      drawer: CustomUserDrawer(selectedIndex: 3,),
      body: Column(
        children: [
          PreferredSize(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width*0.08,
                        ),

                        TextButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                            backgroundColor: Colors.white.withAlpha(30), // Set background color with opacity
                          ),
                          child: Image.asset('assets/images/icon/burger.png',
                            width: width * 0.05, // Set the width of the image
                          ),
                        ),
                        SizedBox(
                          width: width*0.05,
                        ),

                        Text("Profile",
                          style: TextStyle(
                              fontSize: width*0.055,
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
          ),

          Container(
              width: width,
              decoration: BoxDecoration(
                color: Utils.hexToColor(AppStrings.kRBThirdColor),
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
                      child: Column(
                        children: [
                          Row(
                            children: [

                            ],
                          ),

                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
                              child: SizedBox(
                                  height: height*0.632,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, top: height*0.035),
                                    child: SingleChildScrollView(
                                        child: Text('test')
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
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

class DetailsTab extends StatelessWidget {
  final bool isEditing;

  DetailsTab({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Full Name', hintText: 'Tanjina Hemi'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Username', hintText: 'Hemi02'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Email', hintText: 'hemi02@gmail.com'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Phone', hintText: '+88 0123456789'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEditing ? () {} : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Center(
              child: Text(
                'Update',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BankTab extends StatelessWidget {
  final bool isEditing;

  BankTab({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Card Holder’s Name', hintText: 'Banu Elson'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Card Number', hintText: '5470 0004 0003 0002', suffixIcon: Icon(Icons.credit_card)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: 'Expire Date', hintText: 'Month'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: 'Year', hintText: 'Year'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            decoration: InputDecoration(labelText: 'Security Code', hintText: '574', suffixIcon: Icon(Icons.info_outline)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Checkbox(value: false, onChanged: isEditing ? (value) {} : null),
              Text('Remember my card for next purchases.'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEditing ? () {} : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Center(
              child: Text(
                'Update',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordTab extends StatelessWidget {
  final bool isEditing;

  PasswordTab({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: isEditing,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password', hintText: '********'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: isEditing,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Confirm Password', hintText: '********'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEditing ? () {} : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Center(
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
