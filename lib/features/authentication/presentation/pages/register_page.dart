import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_textfield.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthRepository authRepository = AuthRepository();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        // height: height*0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height*0.04, bottom: height*0.014),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Welcome',
                    style: TextStyle(
                      fontSize: width*0.05,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: height*0.004,),
                  Text('Sign Up', style: TextStyle(
                      fontSize: width*0.07,
                      fontWeight: FontWeight.w700
                  ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        width: width*0.845,
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
                              validationMessage: 'Phone number cannot be empty',
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
                              validationMessage: 'Email cannot be empty',
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
                              validationMessage: 'Username cannot be empty',
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: passwordController,
                              leadingIcon: Icons.lock_outlined,
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              inputType: TextInputType.visiblePassword,
                              obscureText: true,
                              validationMessage: 'Password cannot be empty',
                            ),
                            // const SizedBox(height: 20),

                          ],
                        ),
                      ),
                    ),
                    Stack(
                        children: [
                          Transform.translate(
                            offset: const Offset(-30, 0),
                            child: ListTile(
                              title:  Text('Accept terms and conditions',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: width*0.03,
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
                          // Transform.translate(
                          //   offset: Offset(width*0.55, height*0.003),
                          //   child: TextButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/forgotpassword');
                          //     },
                          //     child: const Text('Forgot Password?'),
                          //   ),
                          // )
                        ]
                    ),
                    SizedBox(
                      height: height*0.015,
                    ),
                    CustomElevatedButton(
                        text: 'Create Account',
                        onPressed: () => {},
                        primaryButton: true),
                    SizedBox(
                      height: height*0.02,
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
                                indent: width*0.24,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              'or Sign up with',
                              style: TextStyle(
                                fontSize: width*0.03,
                                color: Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black12,
                                thickness: 1,
                                indent: 10,
                                endIndent: width*0.24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height*0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle Facebook login
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,// button background color
                                shape: const CircleBorder(),
                                padding:  EdgeInsets.all(width*0.04),
                              ),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue,
                                size: width*0.05,
                              ),
                            ),
                            SizedBox(
                              width: width*0.1,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle Google login
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,//// button background color
                                shape: const CircleBorder(),
                                padding: EdgeInsets.all(width*0.04),
                              ),
                              child:  Icon(
                                FontAwesomeIcons.googlePlusG,
                                color: Colors.red,
                                size: width*0.05,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height*0.03,
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
                            )

                          ],
                        ),
                        SizedBox(
                          height: height*0.03,
                        )
                      ],
                    )
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
