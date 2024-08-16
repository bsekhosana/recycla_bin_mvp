import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/features/profile/data/models/rb_transaction_model.dart';
import 'package:recycla_bin/features/profile/provider/rb_transaction_provider.dart';

class RBCreditCardWidget extends StatefulWidget {
  final double balance;
  final String accountNumber;
  final List<RBTransactionModel> transactions;

  RBCreditCardWidget({
    required this.balance,
    required this.accountNumber,
    required this.transactions,
  });

  @override
  State<RBCreditCardWidget> createState() => _RBCreditCardWidgetState();
}

class _RBCreditCardWidgetState extends State<RBCreditCardWidget> {
  late List<RBTransactionModel> sortedTransactions;

  @override
  void initState() {
    super.initState();
    // Sort transactions by createdAt date in descending order
    sortedTransactions = widget.transactions
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  void didUpdateWidget(covariant RBCreditCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      // Update the sorted transactions list when new transactions are added
      setState(() {
        sortedTransactions = widget.transactions
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double left = width * 0.04;
    double right = width * 0.04;
    double top = height * 0.02;
    double bottom = height * 0.02;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.21,
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                child: Text(
                  'Current Balance',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                top: height * 0.05,
                left: left,
                child: Text(
                  'Tk${widget.balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.07,
                left: left,
                child: Text(
                  'GlobeNum',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.037,
                left: left,
                child: Container(
                  width: width * 0.8, // Adjust the width to wrap text appropriately
                  child: Text(
                    widget.accountNumber.length > 15 ? '${widget.accountNumber.substring(0, 15)}...' : widget.accountNumber,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: bottom,
                right: right,
                child: Text(
                  'REBPAY',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                top: top,
                right: right,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'topupwallet');
                  },
                  child: Icon(
                    Icons.add_box_outlined,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<RBTransactionProvider>(
              builder: (context, provider, child) {
                int numberOfTransactions = provider.transactionCount;
                return Text('Transactions ($numberOfTransactions)',
                  style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),);
              },
            ),
            // Text(
            //   'Transactions',
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     // Handle view all transactions
            //   },
            //   child: Text(
            //     'View all',
            //     style: TextStyle(
            //       color: Colors.blue,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
        Consumer<RBTransactionProvider>(
          builder: (context, provider, child) {
            final transactions = provider.transactions;
            return Container(
              height: height * 0.25,
              width: double.infinity,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var transaction = transactions[index];
                  String formattedDate = DateFormat('dd/MM/yy hh:mm a').format(transaction.createdAt);
                  return Card(
                    color: Color(0xFF2A2A2A),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction.icon,
                        color: Colors.white,
                      ),
                      title: Text(
                        transaction.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width*0.04,
                        ),
                      ),
                      subtitle: Text(
                        transaction.details,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: width*0.03,
                        ),
                      ),
                      trailing: SizedBox(
                        width: width*0.24,
                        // height: height*0.05,
                        child: Column(
                          children: [
                            Text(
                              'Tk${transaction.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: width*0.025,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

      ],
    );
  }
}
