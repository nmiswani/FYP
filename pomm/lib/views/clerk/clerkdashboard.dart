import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/clerk.dart';

class ClerkDashboardPage extends StatefulWidget {
  final Clerk clerkdata;
  const ClerkDashboardPage({Key? key, required this.clerkdata})
      : super(key: key);

  @override
  State<ClerkDashboardPage> createState() => _CartPageState();
}

class _CartPageState extends State<ClerkDashboardPage> {
  int _currentIndex = 0; // Set a valid default selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0,
        title: Text(
          "Clerk",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: showSearchDialog,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/order');
                break;
              case 2:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const Center(
            child: Text("Product Page")); // Temporary Placeholder
      case 1:
        return const Center(child: Text("Order Page")); // Temporary Placeholder
      case 2:
        return const Center(
            child: Text("Profile Page")); // Temporary Placeholder
      default:
        return const Center(child: Text("Welcome"));
    }
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search title",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Enter book title",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Logic to search books can be implemented here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
