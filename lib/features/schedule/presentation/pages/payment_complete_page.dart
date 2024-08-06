import 'package:flutter/material.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

import '../../../../core/constants/strings.dart';
import '../../data/models/rb_collection.dart';

class PaymentCompletePage extends StatefulWidget {
  const PaymentCompletePage({super.key});

  @override
  State<PaymentCompletePage> createState() => _PaymentCompletePageState();
}

class _PaymentCompletePageState extends State<PaymentCompletePage> {

  RBCollection? _collection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RBCollection? collection = ModalRoute.of(context)!.settings.arguments as RBCollection?;
      if (collection != null) {
        setState(() {
          _collection = collection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      hidePrefixIcon: true,
        body: Container(
          height: height*0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height*0.0001,
              ),

              Padding(
                padding: EdgeInsets.only(bottom: height*0.05),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: width*0.3,
                            child: Image.asset('assets/images/payment_success.png'),
                          ),
                          // SizedBox(height: 20),
                          Text(
                            'Yay!!!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Utils.hexToColor(AppStrings.kRBPrimaryColor),
                            ),
                          ),
                          Text(
                            'Your Collection is scheduled for ${Utils.formatDateString(_collection!.date!)} at ${_collection!.time}',
                            style: TextStyle(
                              fontSize: width*0.06,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10)
                  ],
                ),
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: width*0.35,
                    height: height*0.08,
                    child: CustomElevatedButton(
                        text: 'Track Collection',
                        onPressed:(){},
                        primaryButton: true,
                    ),
                  ),
                  Container(
                    width: width*0.35,
                    height: height*0.08,
                    child: CustomElevatedButton(
                      text: 'New Collection',
                      onPressed:(){
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'schedulecollection', (
                            Route<dynamic> route) => false);
                      },
                      primaryButton: true,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 20),
            ],
          ),
        ),
        title: 'Payment Complete',
      showMenu: false,
    );
  }
}
