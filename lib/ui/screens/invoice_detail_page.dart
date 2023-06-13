import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_invoice/providers/invoice_provider.dart';
import 'package:intl/intl.dart';

import 'package:simple_invoice/providers/user_provider.dart';

import '../../services/helpers/save_pdf.dart';

class InvoiceDetailPage extends ConsumerWidget {
  const InvoiceDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoice = ref.watch(invoiceProvider);
    final user = ref.watch(userAuthProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Detail'),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 8.h,
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  await generatePdf(ref, true);
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
            const VerticalDivider(
                // thickness: 2,
                ),
            Expanded(
              child: TextButton.icon(
                onPressed: () async {
                  await generatePdf(ref, false);
                },
                icon: const Icon(Icons.file_download),
                label: const Text('download as pdf'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  user.value!.logoUrl.isEmpty
                      ? const Icon(Icons.business_outlined)
                      : Image.network(
                          user.value!.logoUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    user.value!.name,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                user.value!.address,
              ),
              Text(
                user.value!.email,
              ),
              Text(
                user.value!.mobile,
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'INVOICE DETAILS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(invoice.id),
                          Text(
                            DateFormat("MMMM dd, yyy")
                                .format(invoice.createdAt),
                          ),
                        ],
                      ),
                      Text("Customer Name:  ${invoice.customerName}"),
                      Text("Customer Address: ${invoice.customerAddress}"),
                      Text("Customer Mobile No: ${invoice.mobile}"),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                ),
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(10.w),
                    1: FixedColumnWidth(36.w),
                    2: FixedColumnWidth(17.w),
                    3: FixedColumnWidth(17.w),
                    4: FixedColumnWidth(17.w),
                  },
                  // defaultColumnWidth: FixedColumnWidth(20.w),
                  children: [
                    const TableRow(
                        decoration:
                            BoxDecoration(border: Border(bottom: BorderSide())),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text("Sr No."),
                          ),
                          Text("Item Description"),
                          Text("Price"),
                          Text("Quantity"),
                          Text("Amount"),
                        ]),
                    for (int i = 0; i < invoice.itemList.length; i++)
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text((i + 1).toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4, top: 8, bottom: 8),
                          child: Text(invoice.itemList.elementAt(i).itemName),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              invoice.itemList.elementAt(i).price.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(invoice.itemList
                              .elementAt(i)
                              .quantity
                              .toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text((invoice.itemList.elementAt(i).quantity *
                                  invoice.itemList.elementAt(i).price)
                              .toString()),
                        ),
                      ])
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        const Text("Total:  "),
                        Text("${ref.watch(totalAmountProvider)}  /- "),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              const Divider(),
              const Text(
                "This is an electronically generated receipt and no signature is required.",
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
