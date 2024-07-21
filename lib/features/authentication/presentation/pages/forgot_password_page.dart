import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/phone_number_input.dart';
import '../../../../core/utilities/dialogs_utils.dart';
import '../../provider/forgot_password_provider.dart';
// import '../providers/forgot_password_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AuthScaffold(
      body: SizedBox(
        height: height * 0.8,
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontSize: width * 0.065, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      'Please enter your registered Phone Number to reset your password.',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.08),
              Form(
                key: _formKey,
                child: SizedBox(
                  width: width * 0.85,
                  child: PhoneNumberInput(
                    controller: phoneNumberController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Phone number cannot be empty';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
              CustomElevatedButton(
                text: 'Send Code',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      showLoadingDialog(context);
                      await context
                          .read<ForgotPasswordProvider>()
                          .sendCode(phoneNumberController.text);
                      hideLoadingDialog(context);
                      Navigator.pushNamed(context, '/phoneverification');
                      showCustomSnackbar(context, 'Code sent to: ${phoneNumberController.text}', backgroundColor: Colors.green);
                    } catch (e) {
                      hideLoadingDialog(context);
                      showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                    }
                  }
                },
                primaryButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
