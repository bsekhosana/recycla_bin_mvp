import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class CollectionDetailsPage extends StatefulWidget {
  const CollectionDetailsPage({super.key});

  @override
  State<CollectionDetailsPage> createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> {
  final List<String> imagePaths = [
    'assets/images/sprite.png', // Update these paths to match your assets
    'assets/images/coke.png',
    'assets/images/milk.png',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double fontSizeMultiplier = width / 414; // Assuming 414 is the base width
    double paddingMultiplier = width / 414; // Assuming 414 is the base width
    return UserScaffold(
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    Text(
                      '13:05',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey.shade400,
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
                                '200 Eastern Pkwy, Brooklyn, NY 11238',
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
                              backgroundImage: AssetImage('assets/images/user.png'), // Update with actual user image
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              'Brooklyn Williamson',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: imagePaths.map((path) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                              child: Container(
                                width: width * 0.2,
                                height: width * 0.2,
                                decoration: BoxDecoration(
                                  border: path == 'assets/images/sprite.png' ? Border.all(color: Colors.green, width: 2) : null,
                                  borderRadius: BorderRadius.circular(width * 0.02),
                                  color: Colors.white,
                                ),
                                child: Image.asset(path, fit: BoxFit.contain),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        title: 'Collection Details',
        showMenu: false,
    );
  }
}
