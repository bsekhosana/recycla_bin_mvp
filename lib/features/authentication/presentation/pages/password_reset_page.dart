import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/shared_preferences_keys.dart';
import 'package:recycla_bin/core/widgets/auth_scaffold.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import '../../../../core/utilities/dialogs_utils.dart';
import '../../../../core/utilities/shared_pref_util.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../provider/rb_auth_provider.dart';
import '../../provider/forgot_password_provider.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  late bool _obscureText = true;
  late bool _obscureText1 = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPrefUtil _sharedPrefUtil = SharedPrefUtil();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleObscureText1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
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
          child: Form(
            key: _formKey,
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
                        'Reset Password',
                        style: TextStyle(
                          fontSize: width * 0.065,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Please enter your new password and confirm the password.',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 0.0, end: 15),
                      child: Icon(Icons.lock_outline, color: Colors.grey), // Prefix icon padding for alignment
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: _toggleObscureText,
                    ),
                    hintText: 'Enter New Password',
                    labelText: 'New Password',
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                TextFormField(
                  controller: passwordConfirmController,
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password confirmation cannot be empty';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 0.0, end: 15),
                      child: Icon(Icons.lock_outline, color: Colors.grey), // Prefix icon padding for alignment
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: _toggleObscureText1,
                    ),
                    hintText: 'Confirm New Password',
                    labelText: 'Confirm Password',
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                CustomElevatedButton(
                  text: 'Update',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        showLoadingDialog(context);
                        final userId = await _sharedPrefUtil.get<String>(AppSharedKeys.userIdKey);
                        print('current user id before password reset ${userId}');
                        await context.read<ForgotPasswordProvider>().resetPassword(passwordController.text, userId ?? '');
                        showCustomSnackbar(context, 'Password reset successfully', backgroundColor: Colors.green);
                        // Login user and navigate to the home page
                        // showCustomSnackbar(context, 'Password reset successfully', backgroundColor: Colors.green);
                        final userEmail = await _sharedPrefUtil.get<String>(AppSharedKeys.userEmailKey);
                        print('logging in with email: ${userEmail} and password: ${passwordController.text}');
                        await context.read<RBAuthProvider>().login(
                          email: userEmail!,
                          password: passwordController.text, context: context
                        );
                        hideLoadingDialog(context);
                        Navigator.pushNamedAndRemoveUntil(context, 'schedulecollection', (Route<dynamic> route) => false);
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
      ),
    );
  }
}
