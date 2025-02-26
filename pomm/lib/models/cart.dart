class Cart {
  String? cartId;
  String? productId;
  String? cartQty;
  String? cartStatus;
  String? cartDate;
  String? productTitle;
  String? productPrice;
  String? productQty;

  Cart(
      {this.cartId,
      this.productId,
      this.cartQty,
      this.cartStatus,
      this.cartDate,
      this.productTitle,
      this.productPrice,
      this.productQty});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    cartQty = json['cart_qty'];
    cartStatus = json['cart_status'];
    cartDate = json['cart_date'];
    productTitle = json['product_title'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['cart_qty'] = cartQty;
    data['cart_status'] = cartStatus;
    data['cart_date'] = cartDate;
    data['product_title'] = productTitle;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    return data;
  }
}
