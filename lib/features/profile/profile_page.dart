import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  with SingleTickerProviderStateMixin {

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
    return UserScaffold(
        body: Column(
          children: [
            Container(
              height: height*0.2,
              width: width,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
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
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1.208',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Green Credit',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '20',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Reward',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    // Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green, backgroundColor: Colors.white,
                      ),
                      child: Text(isEditing ? 'Done Editing' : 'Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Bank'),
                Tab(text: 'Password'),
              ],
            ),
            SizedBox(
              height: height*0.6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  DetailsTab(isEditing: isEditing),
                  BankTab(isEditing: isEditing),
                  PasswordTab(isEditing: isEditing),
                ],
              ),
            ),
          ],
        ),
        title: 'Profile'
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
