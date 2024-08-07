import 'package:flutter/material.dart';
import '../features/authentication/data/repositories/rb_auth_repository.dart';
import '../../../../core/constants/strings.dart';

class ProtectedPage extends StatelessWidget {
  final RBAuthRepository authRepository = RBAuthRepository();

  ProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.protectedRoute)),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // await authRepository.logout();
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/login', (route) => false);
          },
          child: const Text(AppStrings.logout),
        ),
      ),
    );
  }
}
