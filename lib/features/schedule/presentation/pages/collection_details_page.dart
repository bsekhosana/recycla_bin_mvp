import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

import '../../../authentication/data/models/rb_user_model.dart';
import '../../../profile/provider/user_provider.dart';
import '../../data/models/rb_collection.dart';
import '../../data/models/rb_product.dart';

class CollectionDetailsPage extends StatefulWidget {
  const CollectionDetailsPage({super.key});

  @override
  State<CollectionDetailsPage> createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> {
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
    double fontSizeMultiplier = width / 414; // Assuming 414 is the base width
    double paddingMultiplier = width / 414; // Assuming 414 is the base width
    return UserScaffold(
      body: Container(
        height: height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Time',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    Container(
                      width: width * 0.2,
                      child: Text(
                        textAlign: TextAlign.center,
                        _collection?.time ?? 'N/A',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Utils.hexToColor(AppStrings.kRBLightPrimaryColor),
                      borderRadius: BorderRadius.circular(width * 0.04),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pickup item: Plastic',
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.more_vert, color: Colors.grey.shade700),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Text(
                          'Weight: 20 kg',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: width * 0.04),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              child: Text(
                                _collection?.address ?? 'N/A',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black54,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: width * 0.04,
                              backgroundImage: user?.profilePicture != null
                                  ? NetworkImage(user!.profilePicture!)
                                  : null,
                              child: user?.profilePicture == null
                                  ? Text(
                                Utils.getInitials(user!.fullName),
                                style: TextStyle(fontSize: width * 0.04, color: Colors.green),
                              )
                                  : null,
                            ),
                            // CircleAvatar(
                            //   radius: width * 0.04,
                            //   child: ClipOval(
                            //     child: Icon(
                            //       Icons.person, // Choose the icon you want
                            //       size: width * 0.08, // Adjust the size as needed
                            //       color: Colors.white, // Set the icon color
                            //     ),
                            //   ),
                            //   // backgroundImage: AssetImage('assets/images/user.png'), // Update with actual user image
                            // ),
                            SizedBox(width: width * 0.02),
                            Text(
                              user!.fullName,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.04),
                        SizedBox(
                          height: width * 0.25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                                child: Container(
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: products[index].imgUrl == products[0].imgUrl
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(width * 0.03),
                                    color: Colors.white,
                                  ),
                                  child: Image.network(
                                    products[index].imgUrl!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CustomElevatedButton(
              text: 'Confirm Payment',
              onPressed: () {
                Navigator.pushNamed(context, 'confirmpayment', arguments: _collection);
              },
              primaryButton: true,
            ),
          ],
        ),
      ),
      title: 'Collection Details',
      showMenu: false,
    );
  }
}
