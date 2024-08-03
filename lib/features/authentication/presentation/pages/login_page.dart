import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/custom_textfield.dart';
import '../../../../core/utilities/dialogs_utils.dart';
import '../../../../core/utilities/validators.dart';
import '../../data/repositories/rb_auth_repository.dart';
import '../../provider/rb_auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RBAuthRepository authRepository = RBAuthRepository();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSelected = false;

  void _handleRadioValueChange(bool? value) {
    setState(() {
      _isSelected = value!;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AuthScaffold(
      body: SizedBox(
        height: height*0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height*0.01, bottom: height*0.014),
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
                  Text('Login', style: TextStyle(
                      fontSize: width*0.07,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
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
                            controller: emailController,
                            leadingIcon: Icons.email_outlined,
                            trailingIcon: null,
                            hintText: 'Enter Email',
                            labelText: 'Email',
                            inputType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: height*0.04),
                          CustomTextField(
                            controller: passwordController,
                            leadingIcon: Icons.lock_outlined,
                            hintText: 'Enter your password',
                            labelText: 'Password',
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: Validators.validatePassword,
                          ),
                          SizedBox(height: height*0.02),

                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Transform.translate(
                          offset: const Offset(-30, 0),
                        child: ListTile(
                          title: const Text('Remember me'),
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
                      Transform.translate(
                        offset: Offset(width*0.54, height*0.003),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotpassword');
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      )
                    ]
                  ),
                  SizedBox(
                    height: height*0.05,
                  ),
                  CustomElevatedButton(
                      text: 'Login',
                      onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text.isEmpty) {
                              showCustomSnackbar(
                                  context, 'Email cannot be empty',
                                  backgroundColor: Colors.red);
                            } else if (passwordController.text.isEmpty) {
                              showCustomSnackbar(
                                  context, 'Password cannot be empty',
                                  backgroundColor: Colors.red);
                            } else {
                              try {
                                showLoadingDialog(context);
                                await context.read<RBAuthProvider>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context,
                                    shouldPersist: _isSelected
                                );
                                hideLoadingDialog(
                                    context); // Hide loading indicator
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'schedulecollection', (
                                    Route<dynamic> route) => false);
                                showCustomSnackbar(context, 'Login successful',
                                    backgroundColor: Colors.green);
                              } catch (e) {
                                hideLoadingDialog(
                                    context); // Hide loading indicator
                                showCustomSnackbar(context, e.toString(),
                                    backgroundColor: Colors.red);
                              }
                            }
                          }
                      },
                      primaryButton: true),
                  SizedBox(
                    height: height*0.04,
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
                            'or Sign in with',
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
                          const Text('Dont have an account?'),
                          Transform.translate(
                            offset: const Offset(-5, 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: const Text('Sign Up'),
                            ),
                          )

                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
