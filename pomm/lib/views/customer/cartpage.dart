import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/checkoutpage.dart';

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
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body: cartList.isEmpty
          ? Center(
              child: Text(
                "Loading...",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartList[index];

                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(248, 214, 227, 216),
                          borderRadius: BorderRadius.zero,
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
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "RM${cartItem.productPrice.toString()}",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              "${MyServerConfig.server}/pomm/assets/products/${cartItem.productId}.jpg",
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
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
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
                          Text(
                            "Total RM${calculateSubtotal().toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => CheckoutPage(
                                      customerdata: widget.customer,
                                    ),
                                  ),
                                );
                                loadUserCart();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 55, 97, 70),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Text(
                                "Checkout",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
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

  int calculateTotalItems() {
    int totalItems = 0;

    cartList.forEach((item) {
      totalItems += int.parse(item.cartQty!);
    });

    return totalItems;
  }
}
