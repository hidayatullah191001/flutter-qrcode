class ProductsModel {
  ProductsModel({
    required this.code,
    required this.name,
    required this.productId,
    required this.qty,
  });

  final String code;
  final String name;
  final String productId;
  final int qty;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        productId: json["productId"] ?? "",
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productId": productId,
        "qty": qty,
      };
}
