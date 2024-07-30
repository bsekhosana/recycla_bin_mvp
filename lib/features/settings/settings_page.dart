import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

import '../../core/services/biometric_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    // Load the current biometric setting from preferences or a similar persistent storage
    // For simplicity, we assume it is disabled by default
    setState(() {
      _biometricEnabled = false; // Replace with actual loading logic
    });
  }

  void _toggleBiometric(bool value) async {
    setState(() {
      _biometricEnabled = value;
    });
    // Save the biometric setting to preferences or a similar persistent storage
    // For simplicity, we assume it is saved successfully
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable Biometric Authentication'),
            value: _biometricEnabled,
            onChanged: (bool value) async {
              bool canCheckBiometrics = await BiometricService().checkBiometrics();
              if (canCheckBiometrics) {
                _toggleBiometric(value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Biometric authentication not available on this device')),
                );
              }
            },
          ),
          // Add more settings here
        ],
      ),
      title: 'Settings',
      selectedIndex: 4,
    );
  }
}
