import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      body: Column(
        children: [
          CreditCardWidget(
            height: height*0.22,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            width: double.infinity,
            // cardType: CardType.mastercard,
            isHolderNameVisible: true,
            labelCardHolder: 'CARD HOLDER',
            backgroundImage: 'assets/credit_card/card_bg.png',
            // backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
            onCreditCardWidgetChange: (CreditCardBrand) {

            },
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
              formKey: formKey, // Required
              cardNumber: cardNumber, // Required
              expiryDate: expiryDate, // Required
              cardHolderName: cardHolderName, // Required
              cvvCode: cvvCode, // Required
              cardNumberKey: cardNumberKey,
              cvvCodeKey: cvvCodeKey,
              expiryDateKey: expiryDateKey,
              cardHolderKey: cardHolderKey,
              onCreditCardModelChange: (CreditCardModel data) {}, // Required
              obscureCvv: true,
              obscureNumber: true,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cvvValidationMessage: 'Please input a valid CVV',
              dateValidationMessage: 'Please input a valid date',
              numberValidationMessage: 'Please input a valid number',
              cardNumberValidator: (String? cardNumber){},
              expiryDateValidator: (String? expiryDate){},
              cvvValidator: (String? cvv){},
              cardHolderValidator: (String? cardHolderName){},
              onFormComplete: () {
                // callback to execute at the end of filling card data
              },
              autovalidateMode: AutovalidateMode.always,
              disableCardNumberAutoFillHints: false,
              inputConfiguration: const InputConfiguration(
                cardNumberDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
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
                  width: width*0.35,
                  child: CustomElevatedButton(
                      text: 'Pay Now',
                      onPressed: (){
                        Navigator.pushNamed(context, 'paymentcomplete');
                      },
                      primaryButton: true
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
      title: 'Confirm Payment',
      showMenu: false,
    );
  }
}
