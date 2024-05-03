import 'package:chat_app/pages/auth/splash_screen.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String main = "/main";

  static String getInitial() => initial;
  static String getMain() => main;

  static List<GetPage> routes = [
    GetPage(name: "/", page: () => const SplashScreenPage()),
    GetPage(name: main, page: () => const MainPage()),
  ];
}
