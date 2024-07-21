import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/custom_textfield.dart';

import '../../../../core/utilities/dialogs_utils.dart';
import '../../../../core/utilities/validators.dart';
import '../../provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSelected = false;

  void _handleRadioValueChange(bool? value) {
    setState(() {
      _isSelected = value!;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AuthScaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.04, bottom: height * 0.014),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: height * 0.004),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        width: width * 0.845,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: phoneNumberController,
                              leadingIcon: Icons.phone_iphone_outlined,
                              trailingIcon: null,
                              hintText: 'Enter Phone Number',
                              labelText: 'Phone Number',
                              inputType: TextInputType.phone,
                              obscureText: false,
                              validator: Validators.validatePhoneNumber,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: emailController,
                              leadingIcon: Icons.email_outlined,
                              trailingIcon: null,
                              hintText: 'Enter Email',
                              labelText: 'Email',
                              inputType: TextInputType.emailAddress,
                              obscureText: false,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: usernameController,
                              leadingIcon: Icons.person_outline,
                              trailingIcon: null,
                              hintText: 'Enter Username',
                              labelText: 'Username',
                              inputType: TextInputType.text,
                              obscureText: false,
                              validator: Validators.validateUsername,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: passwordController,
                              leadingIcon: Icons.lock_outlined,
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              inputType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: Validators.validatePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Transform.translate(
                          offset: const Offset(-30, 0),
                          child: ListTile(
                            title: Text(
                              'Accept terms and conditions',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: width * 0.03,
                              ),
                            ),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: _isSelected ? true : null,
                              onChanged: (bool? value) {
                                _handleRadioValueChange(!_isSelected);
                              },
                            ),
                            onTap: () {
                              _handleRadioValueChange(!_isSelected);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),

                    CustomElevatedButton(
                      text: 'Create Account',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if(!_isSelected){
                            showCustomSnackbar(context, 'Please accept terms and conditions', backgroundColor: Colors.red);
                          }else{
                            try {
                              showLoadingDialog(context); // Show loading indicator
                              await context.read<AuthProvider>().register(
                                username: usernameController.text,
                                email: emailController.text,
                                phoneNumber: phoneNumberController.text,
                                password: passwordController.text,
                              );
                              hideLoadingDialog(context); // Hide loading indicator
                              Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false);
                              // Handle successful registration (e.g., navigate to a different page)
                              showCustomSnackbar(context, 'Registration successful', backgroundColor: Colors.green);
                            } catch (e) {
                              hideLoadingDialog(context); // Hide loading indicator
                              showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                              // Handle registration error (e.g., show a snackbar)
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text(e.toString())),
                              // );
                            }
                          }
                        }
                      },
                      primaryButton: true,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                                indent: width * 0.24,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              'or Sign up with',
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                                indent: 10,
                                endIndent: width * 0.24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showLoadingDialog(context); // Show loading indicator
                                  await context.read<AuthProvider>().signInWithFacebook();
                                  hideLoadingDialog(context); // Hide loading indicator
                                  Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false);
                                } catch (e) {
                                  hideLoadingDialog(context); // Hide loading indicator
                                  showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.all(width * 0.04),
                              ),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue,
                                size: width * 0.05,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showLoadingDialog(context); // Show loading indicator
                                  await context.read<AuthProvider>().signInWithGoogle();
                                  hideLoadingDialog(context); // Hide loading indicator
                                  Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false);
                                } catch (e) {
                                  hideLoadingDialog(context); // Hide loading indicator
                                  showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.all(width * 0.04),
                              ),
                              child: Icon(
                                FontAwesomeIcons.googlePlusG,
                                color: Colors.red,
                                size: width * 0.05,
                              ),
                            ),
                            if (Platform.isIOS)
                              SizedBox(
                                width: width * 0.1,
                              ),
                            if (Platform.isIOS)
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    showLoadingDialog(context); // Show loading indicator
                                    await context.read<AuthProvider>().signInWithApple();
                                    hideLoadingDialog(context); // Hide loading indicator
                                    Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false);
                                  } catch (e) {
                                    hideLoadingDialog(context); // Hide loading indicator
                                    showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(width * 0.04),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.apple,
                                  color: Colors.black,
                                  size: width * 0.05,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            Transform.translate(
                              offset: const Offset(-5, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text('Sign In'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
