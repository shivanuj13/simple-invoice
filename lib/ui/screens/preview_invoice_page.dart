import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../routes/route_const.dart';

class PreviewInvoicePage extends StatefulWidget {
  const PreviewInvoicePage({super.key});

  @override
  State<PreviewInvoicePage> createState() => _PreviewInvoicePageState();
}

class _PreviewInvoicePageState extends State<PreviewInvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview the Invoice"),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 8.h,
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),
            const VerticalDivider(
                // thickness: 2,
                ),
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, RouteConst.invoice);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
