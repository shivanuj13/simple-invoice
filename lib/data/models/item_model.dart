import 'dart:convert';

class ItemModel {
  String itemName;
  double price;
  double quantity;
  ItemModel({
    this.itemName = "",
    this.price = double.minPositive,
    this.quantity = double.minPositive,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemName: map['itemName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ItemModel(itemName: $itemName, price: $price, quantity: $quantity)';
}
