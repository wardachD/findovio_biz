// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
// Intro
  static const INTRO = '/intro';
  static const INTRO_LOGIN = '/intro/login_or_register';
  static const INTRO_LOGIN_EMAIL = '/intro/login_or_register/login';
  static const INTRO_REGISTER_EMAIL_NAME =
      '/intro/login_or_register/register_email_name';
  static const INTRO_REGISTER = '/intro/login_or_register/register';
// Home
  static const HOME = '/';
  static const CREATE_SALON_DETAIL = '/create/';
// Profile
  static const PROFILE = '/profile';
// Wallet
  static const WALLET = '/wallet';
  static const WALLET_DETAILS = '/wallet/details';
// No internet
  static const NO_INTERNET = '/no_internet';
}
