import 'dart:convert';

import 'item_model.dart';

class InvoiceModel {
  String id;
  String customerName;
  String customerAddress;
  String mobile;
  List<ItemModel> itemList;
  DateTime createdAt;
  String createdBy;
  InvoiceModel({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.mobile,
    required this.itemList,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'mobile': mobile,
      'itemList': itemList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['_id'] ?? '',
      customerName: map['customerName'] ?? '',
      customerAddress: map['customerAddress'] ?? '',
      mobile: map['mobile'] ?? '',
      itemList: List<ItemModel>.from(
          map['itemList'].map((x) => ItemModel.fromMap(x))),
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      createdBy: map['createdBy'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InvoiceModel(id: $id, customerName: $customerName, customerAddress: $customerAddress, mobile: $mobile, itemList: $itemList, createdAt: $createdAt, createdBy: $createdBy)';
  }

  InvoiceModel copyWith({
    String? id,
    String? customerName,
    String? customerAddress,
    String? mobile,
    List<ItemModel>? itemList,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      mobile: mobile ?? this.mobile,
      itemList: itemList ?? this.itemList,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
