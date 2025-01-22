class Product {
  String? productId;
  String? productTitle;
  String? productDesc;
  String? productPrice;
  String? productQty;

  Product(
      {this.productId,
      this.productTitle,
      this.productDesc,
      this.productPrice,
      this.productQty});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productTitle = json['product_title'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['product_desc'] = productDesc;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    return data;
  }
}
