import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_invoice/services/helpers/shared_pref.dart';
import '/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  var appDir = (await getTemporaryDirectory()).path;
  Directory(appDir).delete(recursive: true);
  runApp(const ProviderScope(child: InvoiceApp()));
}
