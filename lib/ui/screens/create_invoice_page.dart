import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/models/item_model.dart';
import '../../providers/invoice_provider.dart';
import '../../routes/route_const.dart';
import '../widgets/custom_text_field_widget.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _product = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final List<ItemModel> items = [];
  GlobalKey<FormState> invoiceKey = GlobalKey();
  GlobalKey<FormState> itemKey = GlobalKey();
  @override
  void initState() {
    final invoice = ref.read(invoiceProvider);
    _name.text = invoice.customerName;
    _address.text = invoice.customerAddress;
    _mobile.text = invoice.mobile;
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _mobile.dispose();
    _product.dispose();
    _price.dispose();
    _quantity.dispose();
    invoiceKey.currentState?.dispose();
    itemKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoice = ref.watch(invoiceProvider);
    final invoiceNotifier = ref.read(invoiceProvider.notifier);

    ref.listen(invoiceListProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.toString()),
        ));
      } else if (next.hasValue) {
        next.whenData((value) {
          Navigator.pushReplacementNamed(context, RouteConst.invoice);
        });
      }
    });
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create New Invoice'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_rounded,
                color: Color.fromARGB(255, 226, 0, 0),
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 8.h,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            if (ref.watch(isGeneratingProvider))
              const LinearProgressIndicator(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 2.h,
                                      right: 4.w,
                                      left: 4.w,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Form(
                                    key: itemKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Add A Product to Invoice",
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          child: CustomTextFieldWidget(
                                            controller: _product,
                                            labelText: 'Product Details',
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Product can\'t be empty';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.name,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 40.w,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h),
                                                child: CustomTextFieldWidget(
                                                  controller: _price,
                                                  labelText: 'Price',
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Price can\'t be empty';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 40.w,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h),
                                                child: CustomTextFieldWidget(
                                                  controller: _quantity,
                                                  labelText: 'Quantity',
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Quantity can\'t be empty';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        // const Spacer(),
                                        FilledButton(
                                            style: FilledButton.styleFrom(
                                                fixedSize:
                                                    Size.fromWidth(100.w)),
                                            onPressed: () {
                                              if (itemKey.currentState!
                                                  .validate()) {
                                                ItemModel item = ItemModel(
                                                    itemName: _product.text,
                                                    price: double.parse(
                                                        _price.text),
                                                    quantity: double.parse(
                                                        _quantity.text));
                                                invoiceNotifier.addItem(item);
                                                _product.clear();
                                                _price.clear();
                                                _quantity.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Add")),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.add_box_rounded),
                      label: const Text('Add Item'),
                    ),
                  ),
                  const VerticalDivider(
                      // thickness: 2,
                      ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        invoiceNotifier
                          ..updateName(_name.text)
                          ..updateAddress(_address.text)
                          ..updateMobile(_mobile.text);
                        if (invoiceKey.currentState!.validate()) {
                          if (invoice.itemList.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Add minimum of 1 product!!"),
                            ));
                            return;
                          }
                          ref
                              .read(invoiceListProvider.notifier)
                              .createInvoice();
                          // Navigator.pushNamed(context, RouteConst.invoice);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Kindly fill required fields!!"),
                          ));
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      label: const Text('Generate'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Form(
                key: invoiceKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: CustomTextFieldWidget(
                        controller: _name,
                        onSubmit: (value) {
                          invoiceNotifier.updateName(value);
                        },
                        labelText: 'Customer Name',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name can\'t be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: CustomTextFieldWidget(
                        controller: _address,
                        onSubmit: (value) {
                          invoiceNotifier.updateAddress(value);
                        },
                        labelText: 'Customer Address',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: CustomTextFieldWidget(
                        controller: _mobile,
                        onSubmit: (value) {
                          invoiceNotifier.updateMobile(value);
                        },
                        labelText: 'Mobile (Optional)',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("Product description"),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: invoice.itemList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((index + 1).toString()),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            invoiceNotifier.removeItem(index);
                          },
                          icon: const Icon(Icons.delete_sweep)),
                      isThreeLine: true,
                      title: Text(
                          "Product: ${invoice.itemList.elementAt(index).itemName}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "price:  ${invoice.itemList.elementAt(index).price}"),
                          Text(
                              "quantity:  ${invoice.itemList.elementAt(index).quantity}"),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
