import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

import '../../data/models/rb_transaction_model.dart';
import '../../provider/rb_transaction_provider.dart';
import '../../provider/user_provider.dart';

class TopUpWalletPage extends StatefulWidget {
  @override
  State<TopUpWalletPage> createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends State<TopUpWalletPage> {
  bool _isToppingUp = true;
  bool _isLoading = false;
  final List<int> amounts = List<int>.generate(200, (index) => (index + 2) * 50);
  int selectedAmount = 100;

  RBTransactionModel? _transaction;

  void _resetState() {
    setState(() {
      _isToppingUp = true;
      _isLoading = false;
      selectedAmount = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final transactionProvider = Provider.of<RBTransactionProvider>(context, listen: false);


    return UserScaffold(
      title: 'Wallet Top Up',
      showMenu: false,
      body: _isToppingUp ?
      Container(
        height: height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.03,),
            DropdownButtonFormField<int>(
              value: selectedAmount,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefix: Text('R '),
              ),
              items: amounts.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedAmount = newValue!;
                });
              },
            ),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'R',
                        style: TextStyle(
                          fontSize: width * 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: '$selectedAmount',
                        style: TextStyle(
                          fontSize: width * 0.2,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Which translates to ',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'Tk$selectedAmount',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ', that would be added to your REBPay wallet',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isLoading
                ? CircularProgressIndicator(backgroundColor: Colors.green,)
                : CustomElevatedButton(
              text: 'Send Amount',
              onPressed: () async {
                try{
                  setState(() {
                    _isLoading = true;
                  });

                   _transaction = await transactionProvider.createTransaction(
                                    icon: Icons.input_outlined,
                                    title: 'Top Up Wallet',
                                    details: 'Topping up wallet with Tk$selectedAmount(R$selectedAmount)',
                                    amount: selectedAmount.toDouble(),
                                    type: RBTransactionType.TopUp,
                                    status: RBTransactionStatus.Paid,
                                    userProvider: userProvider,
                                  );
                  setState(() {
                    _isLoading = false;
                    _isToppingUp = false;
                    showCustomSnackbar(
                        context, 'REBPay Wallet topped up with Tk$selectedAmount successfully',
                        backgroundColor: Colors.green);
                  });
                }catch (e){
                  setState(() {
                    _isLoading = false;
                    _isToppingUp = true;
                    showCustomSnackbar(
                        context, e.toString(),
                        backgroundColor: Colors.red);
                  });
                }

                //
                // Future.delayed(Duration(seconds: 3), () {
                //
                // });
              },
              primaryButton: true,
            ),
          ],
        ),
      ) :  _transaction == null
              ? Center(
            child: Text('Transaction failed or not created'),
          )
          :  Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Background Image covering the entire column
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -20,
                    child: Image.asset(
                      'assets/images/torn_paper.png', // Path to your torn paper image
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Slight opacity to blend with the background
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Money Sent',
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.public,
                              size: width * 0.08,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          DateFormat('dd/MM/yy hh:mm a').format(_transaction!.createdAt),
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'R$selectedAmount',
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaction ID',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${_transaction!.id != null ? _transaction!.id!.substring(0, 15) : ''}...',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaction Type',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Top Up Wallet',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Account Number',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_transaction!.userId.substring(0, 15)}...',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Sent to',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RecyclaBin',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05,),
              CustomElevatedButton(
                text: 'New Top Up',
                onPressed: _resetState,
                primaryButton: false,
              ),
            ],
          )

        ),
      ),
    );
  }
}
