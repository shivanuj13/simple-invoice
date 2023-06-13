import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_invoice/const/url_const.dart';
import 'package:simple_invoice/data/models/invoice_model.dart';
import 'package:http/http.dart' as http;

final invoiceApiProvider = Provider<InvoiceApi>((ref) {
  return InvoiceApi();
});

class InvoiceApi {
  String invoiceUrl = "$baseUrl/invoice";
  Map<String, String> headersList = {
    'Accept': '*/*',
    'User-Agent': 'Simple Invoice Android App',
    'Content-Type': 'application/json'
  };

  Future<InvoiceModel> createInvoice(InvoiceModel invoice, String token) async {
    try {
      headersList['Authorization'] = "Bearer $token";
      http.Response response = await http.post(
        Uri.parse("$invoiceUrl/create"),
        body: invoice.toJson(),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        InvoiceModel invoiceModel = InvoiceModel.fromMap(res["data"]);
        return invoiceModel;
      } else {
        throw Exception(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<List<InvoiceModel>> getAllInvoices(String token) async {
    try {
      headersList['Authorization'] = "Bearer $token";
      http.Response response = await http.get(
        Uri.parse("$invoiceUrl/getAllInvoices"),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        List<InvoiceModel> invoices = [];
        List<dynamic> list = res["data"];
        invoices.addAll(list.map((e) => InvoiceModel.fromMap(e)));

        return invoices;
      } else {
        throw Exception(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }
}
