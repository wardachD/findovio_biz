import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:findovio_business/screens/intro/register/screens/login_screen.dart';
import 'package:findovio_business/screens/intro/register/screens/register_screen.dart';
import 'package:findovio_business/screens/intro/register/screens/register_screen_name_email.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/create_salon_screen.dart';
import 'package:findovio_business/screens/main_menu/main_menu.dart';
import 'package:findovio_business/screens/wallet/wallet_screen.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.INTRO, page: () => const Intro3PagesScreen()),
    GetPage(name: Routes.INTRO_LOGIN_EMAIL, page: () => const LoginScreen()),
    GetPage(
        name: Routes.INTRO_REGISTER_EMAIL_NAME,
        page: () => const RegisterScreenNameEmail()),
    GetPage(
        name: Routes.INTRO_REGISTER,
        page: () => const RegisterScreen(
              email: '',
              name: '',
            )),
    GetPage(
        name: Routes.CREATE_SALON_DETAIL,
        page: () => const CreateSalonScreen()),
    GetPage(name: Routes.HOME, page: () => MinimalExample()),
    GetPage(name: Routes.WALLET, page: () => const WalletScreen()),
  ];
}
