import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return UserScaffold(
        body: Text('settings'),
        title: 'Settings',
        selectedIndex: 4,
    );
  }
}
