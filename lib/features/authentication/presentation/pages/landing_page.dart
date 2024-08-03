import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';

import '../../../profile/provider/user_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkUserStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkUserStatus();
    }
  }

  Future<void> _checkUserStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      Navigator.pushReplacementNamed(context, 'schedulecollection');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height*0.10),
              child: Column(
                children: [
                  SizedBox(
                      width: width*0.3,
                      child: Image.asset('assets/images/icon/logo.png')
                  ),
                  const Text(
                    'Recycling Tailored to you',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: height*0.08,
            ),
            Center(
              child: SizedBox(
                width: width*0.84,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                        text: 'Login',
                        onPressed: () => {
                          Navigator.pushNamed(context, '/login')
                        },
                        primaryButton: true),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                        text: 'Sign up',
                        onPressed: () => {
                          Navigator.pushNamed(context, '/signup')
                        },
                        primaryButton: false),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              // height: height*0.3,
              child: Image.asset('assets/images/landing_footer.png'),
            ),
          ],
        ),
      ),
    );
  }
}