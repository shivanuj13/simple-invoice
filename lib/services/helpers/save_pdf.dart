import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/providers/invoice_provider.dart';
import 'package:simple_invoice/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

Future<void> generatePdf(WidgetRef ref, bool isShare) async {
  final invoice = ref.read(invoiceProvider);
  final user = ref.read(userAuthProvider);
  final pdf = pw.Document();
  late pw.ImageProvider logo;
  if (user.value!.logoUrl.isNotEmpty) {
    logo = await networkImage(user.value!.logoUrl);
  }
  final container = pw.Padding(
    padding: const pw.EdgeInsets.all(12.0),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            if (user.value!.logoUrl.isNotEmpty) ...[
              pw.Image(
                logo,
                height: 50,
                width: 50,
                fit: pw.BoxFit.cover,
              ),
              pw.SizedBox(
                width: 5.w,
              )
            ],
            pw.Text(
              user.value!.name,
              style: pw.TextStyle(fontSize: 18.sp),
            ),
          ],
        ),
        pw.SizedBox(
          height: 2.h,
        ),
        pw.Text(
          user.value!.address,
        ),
        pw.Text(
          user.value!.email,
        ),
        pw.Text(
          user.value!.mobile,
        ),
        pw.Divider(),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 2.h),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'INVOICE DETAILS',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ),
                pw.SizedBox(
                  height: 2.h,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Invoice Id: ${invoice.id}"),
                    pw.Text(
                      DateFormat("MMMM dd, yyy").format(DateTime.now()),
                    ),
                  ],
                ),
                pw.Text("Customer Name:  ${invoice.customerName}"),
                pw.Text("Customer Address: ${invoice.customerAddress}"),
                pw.Text("Customer Mobile No: ${invoice.mobile}"),
              ],
            ),
          ),
        ),
        pw.Divider(),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(
            vertical: 2.h,
          ),
          child: pw.Table(
            columnWidths: {
              0: pw.FixedColumnWidth(10.w),
              1: pw.FixedColumnWidth(36.w),
              2: pw.FixedColumnWidth(17.w),
              3: pw.FixedColumnWidth(17.w),
              4: pw.FixedColumnWidth(17.w),
            },
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide())),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8.0),
                      child: pw.Text("Sr No."),
                    ),
                    pw.Text("Item Description"),
                    pw.Text("Price"),
                    pw.Text("Quantity"),
                    pw.Text("Amount"),
                  ]),
              for (int i = 0; i < invoice.itemList.length; i++)
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                    child: pw.Text((i + 1).toString()),
                  ),
                  pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(right: 4, top: 8, bottom: 8),
                    child: pw.Text(invoice.itemList.elementAt(i).itemName),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                    child:
                        pw.Text(invoice.itemList.elementAt(i).price.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                    child: pw.Text(
                        invoice.itemList.elementAt(i).quantity.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                    child: pw.Text((invoice.itemList.elementAt(i).quantity *
                            invoice.itemList.elementAt(i).price)
                        .toString()),
                  ),
                ])
            ],
          ),
        ),
        pw.Divider(),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Table(
              defaultColumnWidth: const pw.IntrinsicColumnWidth(),
              children: [
                pw.TableRow(children: [
                  pw.Text("Total:  "),
                  pw.Text("${ref.watch(totalAmountProvider)}  /- "),
                ]),
              ],
            ),
          ),
        ),
        pw.SizedBox(
          height: 4.h,
        ),
        pw.Divider(),
        pw.Text(
          "This is an electronically generated receipt and no signature is required.",
          textAlign: pw.TextAlign.justify,
        )
      ],
    ),
  );

  pdf.addPage(pw.MultiPage(build: (context) {
    return [container];
  }));
  if (isShare) {
    final bytes = await pdf.save();
    Printing.sharePdf(
        bytes: bytes, filename: "${invoice.customerName} invoice.pdf");
  } else {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/${invoice.customerName} invoice.pdf');
    await file.writeAsBytes(await pdf.save());
    try {
      await DocumentFileSavePlus().saveFile(file.readAsBytesSync(),
          "${invoice.customerName} invoice.pdf", "application/pdf");
    } on Exception catch (e) {
      print(e.toString());
    }

    await OpenFilex.open(file.path);
  }
}
