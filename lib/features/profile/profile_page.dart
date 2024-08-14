import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/custom_user_drawer.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:recycla_bin/features/authentication/data/models/rb_user_model.dart';
import 'package:recycla_bin/features/profile/presentation/widgets/rb_credit_card_widget.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';

import '../../core/utilities/error_handler.dart';
import '../../core/utilities/utils.dart';

import 'package:http/http.dart' as http;

import 'data/models/rb_transaction_model.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  bool isEditing = false;
  String editButtonLabel = 'Edit Profile';
  File? _image;

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImageToCloudinary();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_image == null) return;

    final cloudName = 'dq6hot9jq'; // Replace with your Cloudinary cloud name
    final apiKey = '772976592556395'; // Replace with your Cloudinary API key
    final apiSecret = '__5cXqUxkAsY5qtVNgYWCxrfB1k'; // Replace with your Cloudinary API secret

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      showLoadingDialog(context);
      final response = await http.post(
        url,
        body: {
          'file': 'data:image/jpeg;base64,$base64Image',
          'upload_preset': 'ml_default', // You can set up an upload preset in Cloudinary dashboard
        },
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['secure_url'];
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userId = userProvider.user?.id;

        if (userId == null) {
          // Handle the case where user is not authenticated or user ID is null
          hideLoadingDialog(context);
          showCustomSnackbar(context, 'User is not authenticated', backgroundColor: Colors.red);
          return;
        }

        await userProvider.user!.copyWith(profilePicture: imageUrl,);
        showCustomSnackbar(context, 'Profile picture updated successfully', backgroundColor: Colors.green);
        hideLoadingDialog(context);
      } else {
        hideLoadingDialog(context);
        showCustomSnackbar(context, 'Failed to upload image', backgroundColor: Colors.red);
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      hideLoadingDialog(context);
      print('Error uploading image: $e');
      showCustomSnackbar(context, 'Failed to update profile picture with error: ${e.toString()}', backgroundColor: Colors.red);
    }
  }
  // Future<void> _uploadImageToFirebase() async {
  //   if (_image == null) return;
  //
  //   try {
  //     final userProvider = Provider.of<UserProvider>(context, listen: false);
  //     final userId = userProvider.user?.id;
  //
  //     if (userId == null) {
  //       // Handle the case where user is not authenticated or user ID is null
  //       return;
  //     }
  //
  //     final storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child('$userId.jpg');
  //     await storageRef.putFile(_image!);
  //
  //     final imageUrl = await storageRef.getDownloadURL();
  //     await userProvider.updateUserDetails(userId, userProvider.user!.copyWith(profilePicture: imageUrl));
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated successfully')));
  //   } catch (e) {
  //     print('_uploadImageToFirebase error: ${e.toString()}');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile picture')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Utils.hexToColor(AppStrings.kRBThirdColor),
      drawer: CustomUserDrawer(selectedIndex: 3),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(height * 0.7),
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Transform.translate(
                offset: Offset(0, height * 0.03),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.1),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.08,
                          ),
                          TextButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              backgroundColor: Colors.white.withAlpha(30),
                            ),
                            child: Image.asset(
                              'assets/images/icon/burger.png',
                              width: width * 0.05,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(fontSize: width * 0.055, color: Colors.white),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.08, top: width * 0.08, bottom: width * 0.08, right: width * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.0),
                                  ),
                                  child: CircleAvatar(
                                    radius: width * 0.065,
                                    backgroundImage: user?.profilePicture != null
                                        ? NetworkImage(user!.profilePicture!)
                                        : null,
                                    child: user?.profilePicture == null
                                        ? Text(
                                      Utils.getInitials(user!.fullName),
                                      style: TextStyle(fontSize: width * 0.06, color: Colors.green),
                                    )
                                        : null,
                                  ),
                                ),
                                if (isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final action = await _showImageSourceActionSheet(context);
                                        if (action != null) {
                                          _pickImage(action);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: width * 0.03,
                                        backgroundColor: Colors.grey.withOpacity(0.7),
                                        child: Icon(
                                          Icons.edit,
                                          size: width * 0.04,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '1.208',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.white),
                                ),
                                Text(
                                  'Green Credit',
                                  style: TextStyle(fontSize: width * 0.03, color: Colors.white),
                                )
                              ],
                            ),
                            Container(
                              height: height * 0.06,
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '20',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.white),
                                ),
                                Text(
                                  'Reward',
                                  style: TextStyle(fontSize: width * 0.03, color: Colors.white),
                                )
                              ],
                            ),
                            Container(
                              height: height * 0.055,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = !isEditing;
                                    editButtonLabel = isEditing ? 'Done Editing' : 'Edit Profile';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.grey, width: 2.0),
                                  ),
                                ),
                                child: Text(
                                  editButtonLabel,
                                  style: TextStyle(fontSize: width * 0.03, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.08, top: width * 0.02, right: width * 0.08),
                        child: DefaultTabController(
                          length: 3,
                          child: Container(
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
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
                                    height: height * 0.03,
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    child: Center(child: Text('Wallet')),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    child: Center(child: Text('Password')),
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
                padding: EdgeInsets.only(top: height * 0.03),
                child: Container(
                  decoration: BoxDecoration(
                    color: Utils.hexToColor('#fcfcfc'),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(width * 0.1),
                      topRight: Radius.circular(width * 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
                          child: SizedBox(
                            height: height * 0.59,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: height * 0.035),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Center(child: DetailsTab(isEditing: isEditing)),
                                  Center(child: WalletTab(isEditing: isEditing)),
                                  Center(child: PasswordTab(isEditing: isEditing)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<ImageSource?> _showImageSourceActionSheet(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a photo'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
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
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _userProvider = Provider.of<UserProvider>(context);
    if (_userProvider.user != null) {
      _fullNameController.text = _userProvider.user!.fullName;
      _usernameController.text = _userProvider.user!.username;
      _emailController.text = _userProvider.user!.email;
      _phoneNumberController.text = _userProvider.user!.phoneNumber;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _detailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fullNameController,
              enabled: widget.isEditing,
              decoration: InputDecoration(labelText: 'Full Name', hintText: _userProvider.user!.fullName),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              enabled: widget.isEditing,
              decoration: InputDecoration(labelText: 'Username', hintText: _userProvider.user!.username),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              enabled: widget.isEditing,
              decoration: InputDecoration(labelText: 'Email', hintText: _userProvider.user!.email),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneNumberController,
              enabled: widget.isEditing,
              decoration: InputDecoration(labelText: 'Phone', hintText: _userProvider.user!.phoneNumber),
            ),
            SizedBox(height: 20),
            ProfilePageCustomElevatedButton(
                text: 'Update',
                onPressed: () async{
                  if(_detailsFormKey.currentState!.validate()){
                    try{
                      showLoadingDialog(context);
                      await _userProvider.updateUserDetails(_userProvider.user!.id!,
                          _userProvider.user!.copyWith(
                            fullName: _fullNameController.text,
                            username: _usernameController.text,
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text
                          )
                      );
                      hideLoadingDialog(context);
                      showCustomSnackbar(context, 'Updated details successfully', backgroundColor: Colors.green);
                    }catch (e){
                      hideLoadingDialog(context);
                      showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                    }
                  }
                },
                primaryButton: true,
                isEditing: widget.isEditing,
            ),
            // ElevatedButton(
            //   onPressed: widget.isEditing ? () {} : null,
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white, backgroundColor: Colors.green,
            //     padding: EdgeInsets.symmetric(vertical: 16),
            //   ),
            //   child: Center(
            //     child: Text(
            //       'Update',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class WalletTab extends StatefulWidget {
  final bool isEditing;

  WalletTab({required this.isEditing});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  @override
  Widget build(BuildContext context) {

    final _userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          RBCreditCardWidget(
            balance: 45,
            accountNumber: _userProvider.user!.id!,
            transactions: [
              // RBTransactionModel(icon: Icons.home, title: 'Home Internet', details: '**** **** 3749', amount: 15.00),
              // RBTransactionModel(icon: Icons.electrical_services, title: 'Electricity Bill', details: '**** **** 1258', amount: 100.00),
              // RBTransactionModel(icon: Icons.credit_card, title: 'Credit Pay', details: '**** **** 3749', amount: 5.00),

            ],
          )
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
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _passwordUpdateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final _userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _passwordUpdateFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              enabled: widget.isEditing,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password', hintText: '********'),
              controller: _passwordController,
            ),
            SizedBox(height: 10),
            TextField(
              enabled: widget.isEditing,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password', hintText: '********'),
              controller: _confirmPasswordController,
            ),
            SizedBox(height: 20),
            ProfilePageCustomElevatedButton(
                text: 'Change Password',
                onPressed: () async {
                  if(_passwordUpdateFormKey.currentState!.validate()){
                    if(_passwordController.text == _confirmPasswordController.text){
                      showLoadingDialog(context);
                      try{
                        await _userProvider.updateUserPassword(_userProvider.user!.id!, _passwordController.text, _userProvider.user!.hashedPassword);
                        showCustomSnackbar(context, 'Password updated successfully.', backgroundColor: Colors.green);
                        hideLoadingDialog(context);
                      }catch(e){
                        hideLoadingDialog(context);
                        showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                      }
                    }else{
                      showCustomSnackbar(context, 'Password and confirm password do not match, please try again', backgroundColor: Colors.orange);
                    }
                  }
                },
                primaryButton: true,
                isEditing: widget.isEditing,
            ),
            // ElevatedButton(
            //   onPressed: widget.isEditing ? () async {
            //     if(_passwordUpdateFormKey.currentState!.validate()){
            //         if(_passwordController.text == _confirmPasswordController.text){
            //           showLoadingDialog(context);
            //           try{
            //             await _userProvider.updateUserPassword(_userProvider.user!.id!, _passwordController.text, _userProvider.user!.hashedPassword);
            //             showCustomSnackbar(context, 'Password updated successfully.', backgroundColor: Colors.green);
            //             hideLoadingDialog(context);
            //           }catch(e){
            //             hideLoadingDialog(context);
            //             showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
            //           }
            //         }else{
            //           showCustomSnackbar(context, 'Password and confirm password do not match, please try again', backgroundColor: Colors.orange);
            //         }
            //     }
            //   } : null,
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white, backgroundColor: Colors.green,
            //     padding: EdgeInsets.symmetric(vertical: 16),
            //   ),
            //   child: Center(
            //     child: Text(
            //       'Change Password',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ProfilePageCustomElevatedButton extends StatefulWidget {

  final bool isEditing;
  final String text;
  final bool primaryButton;
  final VoidCallback onPressed;

  const ProfilePageCustomElevatedButton({super.key, required this.text, required this.onPressed, required this.primaryButton, required this.isEditing});

  @override
  State<ProfilePageCustomElevatedButton> createState() => _ProfilePageCustomElevatedButtonState();
}

class _ProfilePageCustomElevatedButtonState extends State<ProfilePageCustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.067,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient:  !widget.primaryButton
            ? null
            :  LinearGradient(
          colors: widget.isEditing ? [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)] : [Colors.white, Colors.grey], // Gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(color: Utils.hexToColor(widget.primaryButton ? AppStrings.kRBPrimaryColor : AppStrings.kRBSecondaryColor), width: 1), // Green border
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.isEditing ? widget.onPressed : null,
        child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(color: !widget.primaryButton
                ?Colors.black : Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,

            ) // Text color
        ),
      ),
    );
  }
}
