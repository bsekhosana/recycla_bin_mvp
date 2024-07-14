import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/custom_textfield.dart';
import '../../data/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthRepository authRepository = AuthRepository();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

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
              padding: EdgeInsets.only(top: height*0.02),
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
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: usernameController,
                          leadingIcon: Icons.person,
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
                          leadingIcon: Icons.lock,
                          hintText: 'Enter your password',
                          labelText: 'Password',
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                          validationMessage: 'Password cannot be empty',
                        ),
                        const SizedBox(height: 20),

                      ],
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
                        offset: Offset(width*0.55, height*0.003),
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
                    height: height*0.03,
                  ),
                  CustomElevatedButton(
                      text: 'Login',
                      onPressed: () => {
                        if(usernameController.text.isEmpty){
                          showCustomSnackbar(context, 'Username cannot be empty', backgroundColor: Colors.red)
                        }else if(passwordController.text.isEmpty){
                          showCustomSnackbar(context, 'Password cannot be empty', backgroundColor: Colors.red)
                        }else{
                          Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false,)
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
                              thickness: 2,
                              indent: width*0.2,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            'or Sign in with',
                            style: TextStyle(
                                fontSize: width*0.04,
                              color: Colors.black54,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black12,
                              thickness: 2,
                              indent: 10,
                              endIndent: width*0.2,
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
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.blue,
                              size: 30,
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
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.googlePlusG,
                              color: Colors.red,
                              size: 30,
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
