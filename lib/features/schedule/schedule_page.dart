import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
import 'package:recycla_bin/features/schedule/data/models/rb_collection.dart';
import 'package:recycla_bin/features/schedule/presentation/providers/rb_collection_provider.dart';

import '../../core/constants/strings.dart';
import '../../core/widgets/custom_icon_button.dart';

class ScheduleCollectionPage extends StatefulWidget {
  const ScheduleCollectionPage({super.key});

  @override
  State<ScheduleCollectionPage> createState() => _ScheduleCollectionPageState();
}

class _ScheduleCollectionPageState extends State<ScheduleCollectionPage> {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RBCollectionProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      selectedIndex: 0,
      title: 'Schedule Collection',
        body: Column(
          children: [
            Column(
              children: [

                schedule_collection_list_item(
                  title: 'Date of Collection',
                  value: provider.collection?.date ??  '',
                  callback: () {
                    // Handle button press
                    Navigator.pushNamed(context, 'collectiondate');
                  },
                  iconData: Icons.calendar_today_outlined,
                ),

                SizedBox(
                  height: height*0.023,
                ),

                schedule_collection_list_item(
                  title: 'Period/Time',
                  value: provider.collection?.time ??  '',
                  callback: () {
                    // Handle button press
                    Navigator.pushNamed(context, 'collectiondate');
                  },
                  iconData: Icons.access_time,
                ),

                SizedBox(
                  height: height*0.023,
                ),

                schedule_collection_list_item(
                  title: 'Add Location',
                  value: provider.collection?.location ??  '',
                  callback: () {
                    // Handle button press
                    Navigator.pushNamed(context, 'locationpage');
                  },
                  iconData: Icons.location_on_outlined,
                ),

                SizedBox(
                  height: height*0.023,
                ),

                schedule_collection_list_item(
                  title: 'Add Products',
                  value: provider.collection?.products?.length.toString() ??  '',
                  callback: () {
                    // Handle button press
                    Navigator.pushNamed(context, 'addproductspage');
                  },
                  iconData: Icons.local_drink_outlined,
                )

              ],
            ),

            Center(
              child: SizedBox(
                width: width*0.6,
                height: height*0.4,
                child: Image.asset('assets/images/recycl.png'),
              ),
            ),

            SizedBox(
              height: height*0.023,
            ),

            CustomElevatedButton(
                text: 'Schedule Collection',
                onPressed: (){
                    Navigator.pushNamed(context, 'collectionsummary');
                },
                primaryButton: true
            ),

            SizedBox(
              height: height*0.045,
            ),
          ],
        )
    );
  }
}

class schedule_collection_list_item extends StatelessWidget {
  const schedule_collection_list_item({
    super.key,
    required this.title,
    this.value = '',
    required this.iconData,
    required this.callback
  });

  final String title;
  final String value;
  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height*0.087,
      // color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 20.0,
            spreadRadius: 4.0,
            offset: const Offset(-1, 6)
          ),
        ],
        color: Colors.white
      ),
      child: Row(
        children: [

          SizedBox(
            width: width*0.05,
          ),

          SizedBox(
            width: width*0.095,
            height: height*0.04,
            child: CustomIconButton(
              icon: iconData,
              onPressed: callback,
            ),
          ),

          SizedBox(
            width: width*0.08,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: width*0.043
                ),
              ),

              value != '' ?
              Text(value,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: width*0.03
                ),
              ) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}


