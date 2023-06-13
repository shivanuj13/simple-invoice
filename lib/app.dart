import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/const/string_const.dart';
import 'package:simple_invoice/providers/theme_provider.dart';

import 'routes/route_generator.dart';

class InvoiceApp extends ConsumerWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        theme: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          colorSchemeSeed: const Color.fromARGB(255, 107, 243, 33),
          useMaterial3: true,
        ),
        title: StringConst.appName,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: RouteGenerator.initialRoute,
      );
    });
  }
}
