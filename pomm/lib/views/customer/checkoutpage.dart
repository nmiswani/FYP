import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/billpage.dart';

class CheckoutPage extends StatefulWidget {
  final Customer customerdata;

  const CheckoutPage({Key? key, required this.customerdata}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Cart> cartList = [];
  double total = 0.0;
  // List<List<Cart>> _groupedCartItems = [];

  String selectedShippingOption = 'Delivery';
  double deliveryCharge = 5.00;

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    double total = calculateSubtotal() +
        (selectedShippingOption == 'Delivery' ? deliveryCharge : 0);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0.0,
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
                // Cart Items Section
                Expanded(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartList[index];
                      return _buildCartItemCard(cartItem);
                    },
                  ),
                ),
                // Summary Section
                _buildSummarySection(total),
              ],
            ),
    );
  }

  // Widget for Cart Item Card
  Widget _buildCartItemCard(cartItem) {
    return Column(
      children: [
        // Cart Item Card
        Card(
          color: const Color.fromARGB(248, 214, 227, 216),
          margin: const EdgeInsets.all(16),
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              cartItem.productTitle.toString(),
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w600),
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
            trailing: Text(
              "Qty: ${cartItem.cartQty}",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
            ),
          ),
        ),

        // Remove or reduce SizedBox
        const SizedBox(height: 10), // Adjust the height as needed

        // Shipping Option Card
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          color: const Color.fromARGB(248, 214, 227, 216),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shipping Information",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedShippingOption,
                  isExpanded: true,
                  items: ['Delivery', 'In-store Pickup']
                      .map((option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedShippingOption = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget for Summary Section
  Widget _buildSummarySection(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
              Text(
                "RM${calculateSubtotal().toStringAsFixed(2)}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Delivery Charge",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
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
                ],
              ),
              Text(
                selectedShippingOption == 'Delivery'
                    ? "RM${deliveryCharge.toStringAsFixed(2)}"
                    : "RM0.00",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total RM${total.toStringAsFixed(2)}",
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
                        builder: (content) => const BillPage(),
                      ),
                    );
                    loadUserCart();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Place Order",
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void loadUserCart() async {
    try {
      String customerid = widget.customerdata.customerid.toString();
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

  CartQuantity(String cartId, String newQuantity) async {
    try {
      await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/load_cart.php"),
        body: {
          "cart_id": cartId,
          "cart_qty": newQuantity,
        },
      );
    } catch (error) {
      print("Error updating cart quantity: $error");
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
    newTotal += 5.0; // Assuming a fixed charge of 10.0
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
