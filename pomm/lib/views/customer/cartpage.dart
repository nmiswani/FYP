import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/billpage.dart';

class CartPage extends StatefulWidget {
  final Customer customer;

  const CartPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = [];
  double total = 0.0;
  // List<List<Cart>> _groupedCartItems = [];

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "My Cart",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: cartList.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartList[index];

                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(
                            cartItem.productTitle.toString(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "RM${cartItem.productPrice.toString()}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              "${MyServerConfig.server}/pomm/assets/products/${cartItem.productId}.png",
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => decrementQuantity(cartItem),
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                cartItem.cartQty.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () => incrementQuantity(cartItem),
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () => showRemoveItemDialog(cartItem),
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "RM${calculateSubtotal().toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Delivery Charge",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showDeliveryInfoDialog();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "RM${(calculateTotal() - calculateSubtotal()).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total RM${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => const BillPage(),
                                  ),
                                );
                                loadUserCart();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.deepOrange,
                                backgroundColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                minimumSize: Size.zero,
                                side: const BorderSide(
                                  color: Colors.deepOrange,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                "Checkout",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void loadUserCart() async {
    try {
      String customerid = widget.customer.customerid.toString();
      final response = await http.get(
        Uri.parse(
            "${MyServerConfig.server}/pomm/php/load_cart.php?customerid=$customerid"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          data['data']['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            total +=
                double.parse(v['product_price']) * int.parse(v['cart_qty']);
          });
          total = calculateTotal();
          setState(() {});
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      print("Error loading customer cart: $error");
    }
  }

  incrementQuantity(Cart cartItem) async {
    updateQuantity(cartItem, int.parse(cartItem.cartQty!) + 1);
  }

  decrementQuantity(Cart cartItem) async {
    int currentQuantity = int.parse(cartItem.cartQty!);
    if (currentQuantity > 1) {
      updateQuantity(cartItem, currentQuantity - 1);
    } else {
      showRemoveItemDialog(cartItem);
    }
  }

  void showRemoveItemDialog(Cart cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Remove product",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text("Are you sure want to remove ${cartItem.productTitle}?"),
        actions: [
          TextButton(
            onPressed: () {
              RemoveCartItem(cartItem);
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  updateQuantity(Cart cartItem, int newQuantity) async {
    setState(() {
      cartItem.cartQty = newQuantity.toString();
      total = calculateTotal();
    });

    await updateCartQuantity(cartItem.cartId!, cartItem.cartQty!);
  }

  updateCartQuantity(String cartId, String newQuantity) async {
    try {
      await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_cart.php"),
        body: {
          "cart_id": cartId,
          "cart_qty": newQuantity,
        },
      );

      loadUserCart();
    } catch (error) {
      print("Error updating cart quantity: $error");
    }
  }

  RemoveCartItem(Cart cartItem) async {
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/delete_cart.php"),
        body: {
          "cart_id": cartItem.cartId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          cartList.remove(cartItem);
          total = calculateTotal();
        });
        loadUserCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to remove item"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print("Error deleting cart item: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double calculateSubtotal() {
    double subtotal = 0.0;

    cartList.forEach((item) {
      subtotal += double.parse(item.productPrice!) * int.parse(item.cartQty!);
    });

    return subtotal;
  }

  double calculateTotal() {
    double newTotal = 0.0;

    // Calculate the total directly from cartList
    cartList.forEach((item) {
      newTotal += double.parse(item.productPrice!) * int.parse(item.cartQty!);
    });

    // Add any fixed charges like shipping (if applicable)
    newTotal += 10.0; // Assuming a fixed charge of 10.0
    return newTotal;
  }

  int calculateTotalItems() {
    int totalItems = 0;

    cartList.forEach((item) {
      totalItems += int.parse(item.cartQty!);
    });

    return totalItems;
  }

  void _showDeliveryInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delivery info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text("Charge for delivery is RM5"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
