import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Tambahkan ini

// Import halaman-halaman lain
import 'package:opulenza/akun.dart';
import 'package:opulenza/chatcustomerservice.dart';
import 'package:opulenza/explore.dart';
import 'package:opulenza/get_started.dart';
import 'package:opulenza/home.dart';
import 'package:opulenza/pengajuan_penjualan.dart';
import 'package:opulenza/penjualan.dart';
import 'package:opulenza/pertemuanku.dart';
import 'package:opulenza/report_pembelian.dart';
import 'package:opulenza/report_penjualan.dart';
import 'package:opulenza/sign_in.dart';
import 'package:opulenza/voucher.dart';
import 'package:opulenza/wishlist.dart';
import 'package:opulenza/detail_pakaian.dart';
import 'splash_screen.dart';
import 'splash_screen1.dart';
import 'splash_screen2.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Inisialisasi Firebase
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opulenza',
      debugShowCheckedModeBanner: false,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFBFA87F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5C4F43),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFF3A2E2E),
            fontSize: 16,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _createRoute(const SplashScreen());
          case '/splashscreen':
            return _createRoute(const SplashScreen1());
          case '/splash1':
            return _createRoute(const SplashScreen2());
          case '/splash2':
            return _createRoute(const GetStartedPage());
          case '/signin':
            return _createRoute(const SignInPage());
          case '/register':
            return _createRoute(const SignUpPage());
          case '/home':
            return _createRoute(const HomePage());
          case '/explore':
            return _createRoute(ExplorePage());
          case '/pengajuanpenjualan':
            return _createRoute(PengajuanPenjualanPage());
          case '/penjualan':
            return _createRoute(const PenjualanPage());
          case '/akun':
            return _createRoute(AkunPage());
          case '/reportpembelian':
            return _createRoute(ReportPembelianPage());
          case '/reportpenjualan':
            return _createRoute(ReportPenjualanPage());
          case '/voucher':
            return _createRoute(VoucherPage());
          case '/wishlist':
            return _createRoute(WishlistPage());
          case '/pertemuanku':
            return _createRoute(PertemuankuPage());
          case '/chatcs':
            return _createRoute(const ChatCustomerService());
        // ⚠️ Fix: Jangan duplikat route name '/chatcs'!
          case '/detailpakaian':
            return _createRoute(const DetailPakaianPage(
              name: '',
              price: '',
              images: [],
            ));
          default:
            return null;
        }
      },
    );
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
