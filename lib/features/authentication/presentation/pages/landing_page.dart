import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
              width: width,
              child: Image.asset('assets/images/landing_footer.png'),
            ),
          ],
        ),
      ),
    );
  }
}