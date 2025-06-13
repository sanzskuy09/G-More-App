import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmore/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';

import 'package:gmore/ui/pages/customer_form.dart';
import 'package:gmore/ui/pages/home_page.dart';
import 'package:gmore/ui/pages/ktp_ocr_page.dart';
import 'package:gmore/ui/pages/login_user_page.dart';
import 'package:gmore/ui/pages/main_page.dart';
import 'package:gmore/ui/pages/progress_page.dart';
import 'package:gmore/ui/pages/settings_page.dart';
import 'package:gmore/ui/pages/settings_pages/about_page.dart';
import 'package:gmore/ui/pages/settings_pages/log_page.dart';
import 'package:gmore/ui/pages/settings_pages/profile_page.dart';
import 'package:gmore/ui/pages/settings_pages/promo_page.dart';
import 'package:gmore/ui/pages/splash_page.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

  // WAJIB: Inisialisasi kamera sebelum runApp
  cameras = await availableCameras();

  await initializeDateFormatting('id_ID', null); // ⬅️ initialize for 'id_ID'
  Intl.defaultLocale = 'id_ID';

  // WAJIB: Inisialisasi Hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(KonsumenModelAdapter());

  await Hive.openBox<KonsumenModel>('konsumen');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: whiteColor),
            titleTextStyle: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
        ),
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginUserPage(),
          '/main': (context) => const MainPage(),
          '/homepage': (context) => const HomePage(),
          '/customer-form': (context) => const CustomerFormPage(),
          '/ocr-ktp': (context) => const KtpOcrPage(),
          '/settings': (context) => const SettingsPage(),
          '/progress': (context) => const ProgressPage(),
          '/daftar-konsumen': (context) => const MainPage(selectedIndex: 1),
          // detail setting pages
          '/profile': (context) => const ProfilePage(),
          '/log': (context) => const LogPage(),
          '/promo': (context) => const PromoPage(),
          '/about': (context) => const AboutPage(),
        },
      ),
    );
  }
}
