import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/dialogs_utils.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_collection.dart';
import 'package:recycla_bin/features/schedule/providers/rb_collection_provider.dart';

import '../../core/constants/strings.dart';
import '../../core/widgets/custom_icon_button.dart';
import '../profile/provider/user_provider.dart';

class ScheduleCollectionPage extends StatefulWidget {
  const ScheduleCollectionPage({super.key});

  @override
  State<ScheduleCollectionPage> createState() => _ScheduleCollectionPageState();
}

class _ScheduleCollectionPageState extends State<ScheduleCollectionPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      selectedIndex: 0,
      title: 'Schedule Collection',
      body: Stack(
        children: [
          // Background Image with Opacity
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2, // Set the opacity to 50%
              child: Container(
                child: Image.asset(
                  'assets/images/recycl.png',
                  width: width*0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Consumer<RBCollectionProvider>(
            builder: (context, provider, child) {
              final numberOfProducts = provider.getNumberOfProducts();
              final totalQuantity = provider.getTotalQuantity();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        schedule_collection_list_item(
                          title: 'Date of Collection',
                          value: provider.collection?.date ?? '',
                          callback: () {
                            // Handle button press
                            Navigator.pushNamed(context, 'collectiondate');
                          },
                          iconData: Icons.calendar_today_outlined,
                        ),
                        SizedBox(height: height * 0.023),
                        schedule_collection_list_item(
                          title: 'Period/Time',
                          value: provider.collection?.time ?? '',
                          callback: () {
                            // Handle button press
                            Navigator.pushNamed(context, 'collectiondate');
                          },
                          iconData: Icons.access_time,
                        ),
                        SizedBox(height: height * 0.023),
                        schedule_collection_list_item(
                          title: 'Add Location',
                          value: provider.collection?.address ?? '',
                          callback: () {
                            // Handle button press
                            Navigator.pushNamed(context, 'locationpage');
                          },
                          iconData: Icons.location_on_outlined,
                        ),
                        SizedBox(height: height * 0.023),
                        schedule_collection_list_item(
                          title: 'Add Products',
                          value: numberOfProducts == 0
                              ? ''
                              : '$numberOfProducts Products, Quantity($totalQuantity)',
                          callback: () {
                            // Handle button press
                            Navigator.pushNamed(context, 'addproductspage');
                          },
                          iconData: Icons.local_drink_outlined,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.1),
                    CustomElevatedButton(
                      text: 'Schedule Collection',
                      onPressed: () async {
                        if(provider.collection == null || !provider.areAllFieldsFilled()){
                          showCustomSnackbar(context, 'Please make sure all collection details are captured before scheduling a collection.',
                              backgroundColor: Colors.orange);
                        }else{
                          try{
                            showLoadingDialog(context);
                            await provider.saveCollectionToFirestore(userProvider.user!.id!);
                            provider.removeCollection();
                            hideLoadingDialog(context);
                            showCustomSnackbar(
                                context,
                                'Collection synced to ro server successfully.',
                                backgroundColor: Colors.green);
                            Navigator.pushNamed(context, 'collectionsummary');
                          }catch(e){
                            hideLoadingDialog(context);
                            showCustomSnackbar(context, e.toString(), backgroundColor: Colors.red);
                          }

                        }
                      },
                      primaryButton: true,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomElevatedButton(
                      text: 'Reset Collection',
                      onPressed: () {
                        if(provider.collection == null){
                          showCustomSnackbar(context, 'There is no collection data to reset.',
                              backgroundColor: Colors.orange);
                        }else{
                          showCustomSnackbar(context, 'Cached collection scheduling cleared.',
                              backgroundColor: Colors.green);
                          provider.removeCollection();
                        }
                         // Navigator.pushNamed(context, 'collectionsummary');
                      },
                      primaryButton: false,
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class schedule_collection_list_item extends StatelessWidget {
  const schedule_collection_list_item({
    super.key,
    required this.title,
    this.value = '',
    required this.iconData,
    required this.callback,
  });

  final String title;
  final String value;
  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: height * 0.087,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 20.0,
              spreadRadius: 4.0,
              offset: const Offset(-1, 6),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: width * 0.05),
            SizedBox(
              width: width * 0.095,
              height: height * 0.04,
              child: CustomIconButton(
                icon: iconData,
                onPressed: callback,
              ),
            ),
            SizedBox(width: width * 0.08),
            Container(
              width: width*0.48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    title,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.043,
                    ),
                  ),
                  value != ''
                      ? Text(
                                      value,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                      color: Colors.green,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    )
                      : SizedBox(),
                ],
              ),
            ),

            value == '' ?
                SizedBox() :

                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.015),
                    child: Icon(
                        Icons.check,
                      color: Colors.green,
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
