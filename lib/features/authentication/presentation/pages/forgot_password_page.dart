import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/phone_number_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AuthScaffold(
        body:SizedBox(
            height: height*0.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height*0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Forgot Password', style: TextStyle(
                            fontSize: width*0.065,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: height*0.02,),
                        Text('Please enter your registered Phone Number to reset your password.',
                          style: TextStyle(
                            fontSize: width*0.04,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height*0.08,),

                  SizedBox(
                    width: width*0.85,
                      child: const PhoneNumberInput()
                  ),

                  SizedBox(height: height*0.04,),

                  CustomElevatedButton(
                      text: 'Send Code',
                      onPressed: () => {
                        Navigator.pushNamed(context, '/phoneverification')
                      },
                      primaryButton: true
                  ),

                ],
              ),
            ),
        ),
    );
  }
}
