import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart'; // Import the dialog utils

import '../../../authentication/data/models/rb_user_model.dart';
import '../../../profile/provider/user_provider.dart';
import '../../data/models/rb_collection.dart';
import '../../data/models/rb_product.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var cardNumberKey;

  var cvvCodeKey;

  var cardHolderKey;

  var expiryDateKey;

  void onCreditCardModelChange(CreditCardModel model) {
    setState(() {
      cardNumber = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

  List<RBProduct> products = [];
  int totalQuantity = 0;
  String date = "2021/05/18";
  String time = "13:00 PM - 14:00 PM";
  double cost = 47.45;
  RBCollection? _collection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RBCollection? collection = ModalRoute.of(context)!.settings.arguments as RBCollection?;
      if (collection != null) {
        setState(() {
          products = List.from(collection.products ?? []);
          totalQuantity = collection.getTotalQuantity();
          _collection = collection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context);
    final RBUserModel? user = userProvider.user;
    return UserScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              height: height * 0.22,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              width: double.infinity,
              isHolderNameVisible: true,
              labelCardHolder: 'CARD HOLDER',
              backgroundImage: 'assets/credit_card/card_bg.png',
              onCreditCardWidgetChange: (CreditCardBrand) {},
              enableFloatingCard: true,
              floatingConfig: FloatingConfig(
                isGlareEnabled: true,
                isShadowEnabled: true,
                shadowConfig: FloatingShadowConfig(),
              ),
            ),
            Container(
              color: Colors.grey.shade100,
              child: CreditCardForm(
                formKey: formKey,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                cardNumberKey: cardNumberKey,
                cvvCodeKey: cvvCodeKey,
                expiryDateKey: expiryDateKey,
                cardHolderKey: cardHolderKey,
                onCreditCardModelChange: onCreditCardModelChange,
                obscureCvv: true,
                obscureNumber: true,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                enableCvv: true,
                cvvValidationMessage: 'Please input a valid CVV',
                dateValidationMessage: 'Please input a valid date',
                numberValidationMessage: 'Please input a valid number',
                cardNumberValidator: (String? cardNumber) {
                  if (cardNumber == null || cardNumber.isEmpty) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
                expiryDateValidator: (String? expiryDate) {
                  if (expiryDate == null || expiryDate.isEmpty) {
                    return 'Please enter a valid expiry date';
                  }
                  return null;
                },
                cvvValidator: (String? cvv) {
                  if (cvv == null || cvv.isEmpty) {
                    return 'Please enter a valid CVV';
                  }
                  return null;
                },
                cardHolderValidator: (String? cardHolderName) {
                  if (cardHolderName == null || cardHolderName.isEmpty) {
                    return 'Please enter the card holder name';
                  }
                  return null;
                },
                onFormComplete: () {
                  // callback to execute at the end of filling card data
                },
                autovalidateMode: AutovalidateMode.always,
                disableCardNumberAutoFillHints: false,
                inputConfiguration: InputConfiguration(
                  cardNumberDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                  expiryDateDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expired Date',
                    hintText: 'MM/YY',
                  ),
                  cvvCodeDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CVV',
                    hintText: 'XXX',
                  ),
                  cardHolderDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Holder',
                  ),
                  cardNumberTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  cardHolderTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  expiryDateTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  cvvCodeTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total\n\$47.45',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: width * 0.35,
                    child: CustomElevatedButton(
                      text: 'Pay Now',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          showLoadingDialog(context);
                          await Future.delayed(Duration(seconds: 3));
                          hideLoadingDialog(context);
                          Navigator.pushNamedAndRemoveUntil(context, 'paymentcomplete', (Route<dynamic> route) => false, arguments: _collection);
                        }
                      },
                      primaryButton: true,
                    ),
                  )
                ],
              ),
            ),
            Text(
              'This is the final step, after selecting Pay Now button, the payment will be processed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      title: 'Confirm Payment',
      showMenu: false,
    );
  }
}
