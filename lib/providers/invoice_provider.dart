import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_invoice/data/models/item_model.dart';
import 'package:simple_invoice/providers/user_provider.dart';
import 'package:simple_invoice/services/api/invoice_api.dart';
import 'package:simple_invoice/ui/screens/home_page.dart';

import '../data/models/invoice_model.dart';

final totalAmountProvider = StateProvider<double>((ref) {
  return 0;
});

final invoiceProvider = NotifierProvider<InvoiceNotifier, InvoiceModel>(() {
  return InvoiceNotifier();
});

class InvoiceNotifier extends Notifier<InvoiceModel> {
  @override
  build() {
    return InvoiceModel(
        createdAt: DateTime.now(),
        id: "",
        customerName: "",
        customerAddress: "",
        mobile: "",
        itemList: [],
        createdBy: "");
  }

  void calculateTotalPrice() {
    double total = 0;

    for (ItemModel e in state.itemList) {
      total = total + (e.price * e.quantity);
    }
    ref.read(totalAmountProvider.notifier).state = total;
  }

  void updateState(InvoiceModel invoice) {
    state = invoice;
    calculateTotalPrice();
  }

  void updateName(String name) {
    state = state.copyWith(customerName: name);
    // printf();
  }

  void updateAddress(String address) {
    state = state.copyWith(customerAddress: address);
    // printf();
  }

  void updateMobile(String mobile) {
    state = state.copyWith(mobile: mobile);
    // printf
  }

  void addItem(ItemModel item) {
    // ref.read(totalAmountProvider.notifier).state =
    //     ref.read(totalAmountProvider) + (item.price * item.quantity);
    state = state.copyWith(itemList: [...state.itemList, item]);
  }

  void removeItem(int index) {
    // ref.read(totalAmountProvider.notifier).state =
    //     ref.read(totalAmountProvider) -
    //         (state.itemList.elementAt(index).price *
    //             state.itemList.elementAt(index).quantity);
    state = state.copyWith(itemList: [
      for (int i = 0; i < state.itemList.length; i++)
        if (i != index) state.itemList.elementAt(i)
    ]);
  }
}

class InvoiceListNotifier extends AutoDisposeAsyncNotifier<List<InvoiceModel>> {
  @override
  FutureOr<List<InvoiceModel>> build() {
    return getAllInvoices();
  }

  List<InvoiceModel> _cachedInvoice = [];

  Future<List<InvoiceModel>> getAllInvoices() async {
    String? token = ref.read(userAuthProvider).value?.token;
    if (token != null) {
      return _cachedInvoice =
          await ref.read(invoiceApiProvider).getAllInvoices(token);
    }
    throw Exception("User not Authorized");
  }

  Future<void> fetchList () async {
   state = await AsyncValue.guard(() async {
      return await getAllInvoices();
    });
  }

  Future<void> createInvoice() async {
    String? token = ref.read(userAuthProvider).value?.token;
    InvoiceModel invoiceModel = ref.read(invoiceProvider);
    if (token != null) {
      ref.read(isGeneratingProvider.notifier).state = true;
      ref.read(invoiceProvider.notifier).updateState(
            await ref
                .read(invoiceApiProvider)
                .createInvoice(invoiceModel, token),
          );
      ref.read(isGeneratingProvider.notifier).state = false;
    }
    state = await AsyncValue.guard(() async {
      return await getAllInvoices();
    });
  }

  void filterByDate(DateTime date) {
    state = AsyncValue.data(_cachedInvoice
        .where((element) => dateCompare(date, element.createdAt))
        .toList());
  }
}

final invoiceListProvider =
    AsyncNotifierProvider.autoDispose<InvoiceListNotifier, List<InvoiceModel>>(
        InvoiceListNotifier.new);

final isGeneratingProvider = StateProvider<bool>((ref) {
  return false;
});