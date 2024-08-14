import 'package:flutter/material.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class TopUpWalletPage extends StatefulWidget {
  @override
  State<TopUpWalletPage> createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends State<TopUpWalletPage> {
  bool _isToppingUp = true;
  bool _isLoading = false;
  final List<int> amounts = List<int>.generate(200, (index) => (index + 2) * 50);
  int selectedAmount = 100;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return UserScaffold(
      title: 'Wallet Top Up',
      showMenu: false,
      body: _isToppingUp ?
        Container(
          height: height*0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.03,),
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
              // SizedBox(height: height),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'R', // The smaller suffix text
                          style: TextStyle(
                            fontSize: width*0.2, // Smaller font size for the suffix
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: '$selectedAmount',
                          style: TextStyle(
                            fontSize: width*0.2,
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
                          text:'Which translates to ',
                          style: TextStyle(
                              fontSize: width*0.04,
                              color: Colors.grey
                          ),
                        ),
                        TextSpan(
                          text:'Tk$selectedAmount',
                          style: TextStyle(
                              fontSize: width*0.04,
                              color: Colors.green,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text:', that would be added to your RBWallet',
                          style: TextStyle(
                              fontSize: width*0.04,
                              color: Colors.grey
                          ),
                        )
                      ]
                    )
                  ),

                ],
              ),
              // SizedBox(height: 40),
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12.0),
              //   ),
              //   color: Colors.greenAccent,
              //   child: ListTile(
              //     leading: CircleAvatar(
              //       backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
              //     ),
              //     title: Text('Joey Climb'),
              //     subtitle: Text('ID: #78451695'),
              //   ),
              // ),
              // SizedBox(height: 40),
              CustomElevatedButton(
                  text: 'Send Amount',
                  onPressed: (){
                    showLoadingDialog(context);
                    Future.delayed(Duration(seconds: 3), (){
                      setState(() {
                        _isToppingUp = false;
                      });
                    });

                    hideLoadingDialog(context);
                  },
                primaryButton: true,
              ),
            ],
          ),
        )
      : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
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
                      '10/5/2024    12:09 PM',
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
                          '#8565 12',
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
                          'Wallet Top Up',
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
                      '+65 80466619',
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
                      '+65 48565433 (Noah Willy)',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: height * 0.03),
              // GestureDetector(
              //   onTap: () {
              //     // Handle swipe to send action
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.symmetric(vertical: 15),
              //     decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(left: 20.0),
              //           child: Icon(Icons.arrow_forward, color: Colors.white),
              //         ),
              //         Text(
              //           'Swipe to send',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: width * 0.05,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(right: 20.0),
              //           child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      )
    );
  }
}