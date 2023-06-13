import 'package:flutter/material.dart';
import 'package:simple_invoice/routes/route_const.dart';
import 'package:simple_invoice/services/helpers/shared_pref.dart';
import 'package:simple_invoice/ui/screens/about_page.dart';
import 'package:simple_invoice/ui/screens/create_invoice_page.dart';
import 'package:simple_invoice/ui/screens/home_page.dart';
import 'package:simple_invoice/ui/screens/preview_invoice_page.dart';
import 'package:simple_invoice/ui/screens/sign_in_page.dart';
import 'package:simple_invoice/ui/screens/update_profile.dart';

import '../ui/screens/invoice_detail_page.dart';
import '../ui/screens/sign_up_page.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case RouteConst.home:
        page = const HomePage();
        break;
      case RouteConst.invoice:
        page = const InvoiceDetailPage();
        break;
      case RouteConst.createInvoice:
        page = const CreateInvoicePage();
        break;
      case RouteConst.previewInvoice:
        page = const PreviewInvoicePage();
        break;
      case RouteConst.updateProfile:
        page = const UpdateProfilePage();
        break;
      case RouteConst.signUp:
        page = const SignUpPage();
        break;
      case RouteConst.signIn:
        page = const SignInPage();
        break;
      case RouteConst.about:
        page = const AboutPage();
      default:
        return MaterialPageRoute(builder: (context) => const SignInPage());
    }
    return MaterialPageRoute(builder: (context) => page);
  }

  static String _initialRoute() {
    bool isSignedIn = SharedPref.getUser() != null;
    return isSignedIn ? RouteConst.home : RouteConst.signIn;
  }

  static String get initialRoute => _initialRoute();
}
