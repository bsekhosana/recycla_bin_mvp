import 'package:flutter/material.dart';

class CustomDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomDrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height*0.02),
      child: Container(
        width: double.infinity,
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? Colors.green : null,
            size: width*0.08,
          ),
          title: Text(title,
              style: TextStyle(
                  color: isSelected ? Colors.green : null,
                fontSize: width*0.05,
                fontWeight: FontWeight.bold
              ),
          ),
          selected: isSelected,
          onTap: onTap,
        ),
      ),
    );
  }
}
