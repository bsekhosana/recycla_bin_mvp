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
  String editButtonLabel = 'Edit Profile';

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
            preferredSize: Size.fromHeight(height*0.7),
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
                    child: Column(
                      children: [
                        Row(
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

                        Padding(
                          padding: EdgeInsets.only(left: width*0.08, top: width*0.08, bottom: width*0.08, right: width*0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.0), // Space for the border
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.0),
                                ),
                                child: CircleAvatar(
                                  radius: width * 0.065,
                                  backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1.208',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width*0.04,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    'Green Credit',
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: width*0.03,
                                        color: Colors.white
                                    ),
                                  )
                                ],
                              ),

                              Container(
                                height: height*0.06,
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '20',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width*0.04,
                                        color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    'Reward',
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        fontSize: width*0.03,
                                        color: Colors.white
                                    ),
                                  )
                                ],
                              ),

                              Container(
                                height: height*0.055,
                                child: ElevatedButton(
                                  onPressed: () => {
                                      setState(() {
                                        isEditing = !isEditing;
                                        editButtonLabel = isEditing ? 'Done Editing' : 'Edit Profile';
                                      })
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                      side: BorderSide(color: Colors.grey, width: 2.0), // Green border
                                    ),
                                  ),
                                  child: Text(
                                    editButtonLabel,
                                    style: TextStyle(
                                      fontSize: width*0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Text color
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width*0.08, top: width*0.02, right: width*0.08),
                          child: DefaultTabController(
                            length: 3,
                            child: Container(
                              // color: Colors.green,
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3), // Semi-transparent background for selected tab
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: null,
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                tabs: [
                                  Tab(
                                    child: Container(
                                        child: Center(child: Text('Details')),
                                        // width: width*0.4,
                                        height: height*0.03,
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      child: Center(child: Text('Bank')),
                                      // width: double.infinity,
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      child: Center(child: Text('Password')),
                                      // width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //
                          //   ],
                          // ),

                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
                              child: SizedBox(
                                  height: height*0.59,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, top: height*0.035),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        Center(child:DetailsTab(isEditing: isEditing,)),
                                        Center(child: BankTab(isEditing: isEditing,)),
                                        Center(child: PasswordTab(isEditing: isEditing,)),
                                      ],
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

class DetailsTab extends StatefulWidget {
  final bool isEditing;

  DetailsTab({required this.isEditing});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Full Name', hintText: 'Tanjina Hemi'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Username', hintText: 'Hemi02'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Email', hintText: 'hemi02@gmail.com'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Phone', hintText: '+88 0123456789'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.isEditing ? () {} : null,
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

class BankTab extends StatefulWidget {
  final bool isEditing;

  BankTab({required this.isEditing});

  @override
  State<BankTab> createState() => _BankTabState();
}

class _BankTabState extends State<BankTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Card Holder’s Name', hintText: 'Banu Elson'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Card Number', hintText: '5470 0004 0003 0002', suffixIcon: Icon(Icons.credit_card)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: widget.isEditing,
                  decoration: InputDecoration(labelText: 'Expire Date', hintText: 'Month'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  enabled: widget.isEditing,
                  decoration: InputDecoration(labelText: 'Year', hintText: 'Year'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            decoration: InputDecoration(labelText: 'Security Code', hintText: '574', suffixIcon: Icon(Icons.info_outline)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Checkbox(value: false, onChanged: widget.isEditing ? (value) {} : null),
              Text('Remember my card for next purchases.'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.isEditing ? () {} : null,
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

class PasswordTab extends StatefulWidget {
  final bool isEditing;

  PasswordTab({required this.isEditing});

  @override
  State<PasswordTab> createState() => _PasswordTabState();
}

class _PasswordTabState extends State<PasswordTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: widget.isEditing,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password', hintText: '********'),
          ),
          SizedBox(height: 10),
          TextField(
            enabled: widget.isEditing,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Confirm Password', hintText: '********'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.isEditing ? () {} : null,
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
