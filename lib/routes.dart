import 'package:flutter/material.dart';
import 'package:recycla_bin/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:recycla_bin/features/authentication/presentation/pages/password_reset_page.dart';
import 'package:recycla_bin/features/authentication/presentation/pages/phone_verification_page.dart';
import 'package:recycla_bin/features/notifications/notifications_page.dart';
import 'package:recycla_bin/features/profile/presentation/pages/top_up_wallet_page.dart';
import 'package:recycla_bin/features/profile/profile_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/add_products_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/collection_date_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/collection_details_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/collection_summary_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/confirm_payment_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/location_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/payment_complete_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/scan_page.dart';
import 'package:recycla_bin/features/schedule/presentation/pages/track_collection_page.dart';
import 'package:recycla_bin/features/schedule/schedule_page.dart';
import 'package:recycla_bin/features/settings/settings_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/authentication/presentation/pages/landing_page.dart';
import 'features/schedule/collections_page.dart';
import 'features/protected_page.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{

    // AUTH FEATURE ============================================================
    '/login': (BuildContext context) => const LoginPage(),
    '/signup': (BuildContext context) => const RegisterPage(),
    '/forgotpassword': (BuildContext context) => const ForgotPasswordPage(),
    // '/phoneverification': (BuildContext context) => const PhoneVerificationPage(),
    // '/phoneverification': (context) => PhoneVerificationPage(phoneNumber: ''),
    '/passwordreset': (BuildContext context) => const PasswordResetPage(),
    '/landing': (BuildContext context) => const LandingPage(),
    '/protected': (BuildContext context) => ProtectedPage(),
    // =========================================================================

    // SCHEDULE COLLECTION FEATURE =============================================
    'schedulecollection': (BuildContext context) => const ScheduleCollectionPage(),
    'collectiondate': (BuildContext context) => const CollectionDatePage(),
    'locationpage': (BuildContext context) => const LocationPage(),
    'addproductspage': (BuildContext context) => const AddProductsPage(),
    'scanpage': (BuildContext context) => ScanPage(),
    'collectionsummary': (BuildContext context) => CollectionSummaryPage(),
    'collectiondetails': (BuildContext context) => CollectionDetailsPage(),
    'confirmpayment': (BuildContext context) => ConfirmPaymentPage(),
    'paymentcomplete': (BuildContext context) => PaymentCompletePage(),
    'trackcollection': (BuildContext context) => TrackCollectionPage(),


    // PROFILE FEATURE
    'profile': (BuildContext context) => ProfilePage(),
    'topupwallet':  (BuildContext context) => TopUpWalletPage(),

    // NOTIFICATIONS FEATURE
    'notifications': (BuildContext context) => NotificationsPage(),

    // COLLECTIONS FEATURE
    'collections': (BuildContext context) => CollectionsPage(),

    // SETTINGS FEATURE
    'settings': (BuildContext context) => SettingsPage(),
  };
}
