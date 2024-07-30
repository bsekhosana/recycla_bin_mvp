import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      selectedIndex: 1,
        body:Column(
          children: [
            Text('Collections here')
          ],
        ),
        title: 'Collections',
    );
  }
}
