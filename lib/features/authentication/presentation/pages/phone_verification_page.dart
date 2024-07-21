import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/verification_code_input.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationPage({super.key,required this.phoneNumber});


  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  bool _isButtonEnabled = false;

  void _onInputChanged(bool allInputsFilled) {
    setState(() {
      _isButtonEnabled = allInputsFilled;
    });
  }

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
                    Text('Phone Verification', style: TextStyle(
                        fontSize: width*0.065,
                        fontWeight: FontWeight.w700
                    ),
                    ),
                    SizedBox(height: height*0.02,),
                    Text.rich(
                      TextSpan(
                        text: 'Please enter the 6 digit code sent to you at ',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height*0.1,),

              VerificationCodeInput(onInputChanged: _onInputChanged),
              SizedBox(height: height*0.05),
              Container(
                height: MediaQuery.of(context).size.height * 0.067,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: _isButtonEnabled ? BoxDecoration(
                  gradient:  LinearGradient(
                    colors:  [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)], // Gradient colors
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  border: Border.all(color: Utils.hexToColor(AppStrings.kRBPrimaryColor), width: 1), // Green border
                ) : null,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: _isButtonEnabled ? Colors.green : Colors.grey,
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:  _isButtonEnabled ? () {
                    Navigator.pushNamed(context, '/passwordreset');
                  } : null,
                  child: Text(
                      'Verify',
                      style: TextStyle(color: _isButtonEnabled ? Colors.white : Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ) // Text color
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
