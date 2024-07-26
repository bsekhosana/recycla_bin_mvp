import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/features/authentication/presentation/pages/landing_page.dart';
import 'package:recycla_bin/features/profile/provider/user_provider.dart';
import 'package:recycla_bin/routes.dart';

import 'core/constants/strings.dart';
import 'core/provider/app_provider.dart';
import 'features/authentication/presentation/pages/phone_verification_page.dart';
import 'features/authentication/provider/auth_provider.dart';
import 'features/authentication/provider/forgot_password_provider.dart';
import 'features/schedule/data/data_provider/shared_pref_provider.dart';
import 'features/schedule/domain/repositories/rb_collection_repository.dart';
import 'features/schedule/presentation/providers/rb_collection_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final sharedPrefProvider = SharedPrefProvider();
  final rbCollectionRepository = RBCollectionRepository(sharedPrefProvider: sharedPrefProvider);

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'recycla_bin_app',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RBCollectionProvider(repository: rbCollectionRepository)),
        // Add more providers here as needed
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routes.routes,
      initialRoute: '/landing',
      home: LandingPage(),  //this is the calling screen
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      onGenerateRoute: (settings) {
        if (settings.name == '/phoneverification') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return PhoneVerificationPage(
                phoneNumber: args['phoneNumber'],
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      // home: LandingPage(),
    );
  }
}