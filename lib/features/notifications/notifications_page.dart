import 'package:flutter/material.dart';

import '../../core/widgets/user_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      selectedIndex: 2,
      body: Text('Notifications bit'),
      title: 'Notifications Page',
    );
  }
}
