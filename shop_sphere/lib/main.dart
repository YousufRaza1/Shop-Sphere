import 'package:flutter/material.dart';
import 'common/theme_manager/theme_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common/network_connectivity_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'base_module/Authentication/View/login_screen.dart';
import 'base_module/Authentication/ViewModel/AuthViewModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qmztbpmejhngubxxowml.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtenRicG1lamhuZ3VieHhvd21sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAyODA0MDUsImV4cCI6MjA0NTg1NjQwNX0.RttRGru4XlycSn5-C1JFBZMp_u4QssG2vQVW9aI0muM'
  );

  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyAppController appController = Get.put(MyAppController());
  final NetworkStatusController _controller = Get.put(NetworkStatusController());
  // final HomeViewModel homeViewModel = Get.put(HomeViewModel());
  final AuthService _authViewModel = Get.put(AuthService());


  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      locale: appController.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'), // Arabic
        Locale('en'), // English
        Locale('bn'), // Bangla
      ],
      themeMode: appController.themeMode,
      theme: ThemeDataStyle.light,
      darkTheme: ThemeDataStyle.dark,
      home: LoginScreen(),
    ));
  }
}

class MyAppController extends GetxController {
  // Initially set the locale to Bangla and theme mode to System
  var _locale = Locale('en').obs;
  var _themeMode = ThemeMode.system.obs;

  // Getters for locale and theme
  Locale get locale => _locale.value;
  ThemeMode get themeMode => _themeMode.value;

  // Method to change the language
  void changeLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        _locale.value = Locale('en');
        break;
      case 'bn':
        _locale.value = Locale('bn');
        break;
      case 'ar':
      default:
        _locale.value = Locale('ar');
        break;
    }

    // Update the locale for the app
    Get.updateLocale(_locale.value);
  }

  // Method to change the theme
  void changeTheme(ThemeMode mode) {
    _themeMode.value = mode;
  }
}
