import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/views/admin/dailyreportpage.dart';
import 'package:pomm/views/startpage.dart';

class AdminDashboardPage extends StatefulWidget {
  final Admin admindata;
  const AdminDashboardPage({Key? key, required this.admindata})
      : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentIndex = 0;

  // List of pages for BottomNavigationBar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildProductPage(),
      const Center(
        child: Text(
          "Order Page",
          style: TextStyle(fontSize: 18),
        ),
      ),
      _buildSalesReportPage(), // Report page
    ];
  }

  // Method for the Product page
  Widget _buildProductPage() {
    final List<Map<String, dynamic>> products = [
      {
        'image': 'assets/images/product1.jpeg',
        'name': 'Phone Case',
        'quantity': 10
      },
      {
        'image': 'assets/images/product2.jpeg',
        'name': 'Screen Protector',
        'quantity': 15
      },
      {
        'image': 'assets/images/product3.jpeg',
        'name': 'Charger',
        'quantity': 20
      },
      {
        'image': 'assets/images/product4.jpeg',
        'name': 'Headphone',
        'quantity': 8
      },
      {'image': 'assets/images/product5.jpeg', 'name': 'Audio', 'quantity': 12},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            " Product Categories",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Column(
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      color: const Color.fromARGB(248, 214, 227, 216),
                      elevation: 2,
                      child: ListTile(
                        leading: Image.asset(product['image'],
                            width: 60, height: 70),
                        title: Text(
                          product['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Quantity: ${product['quantity']}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                    ),
                    // Add a SizedBox with a fixed height between cards
                    const SizedBox(height: 2), // You can adjust the height here
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Method for the Report page
  Widget _buildSalesReportPage() {
    final List<Map<String, dynamic>> reports = [
      {
        'title': 'Daily',
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (content) => const DailyReportPage()))
      },
      {'title': 'Monthly', 'onTap': () => {}},
      {'title': 'Yearly', 'onTap': () => {}},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            " Sales Report",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return SizedBox(
                  width: double.infinity, // Make the card span the full width
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    color: const Color.fromARGB(248, 214, 227, 216),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        report['title'],
                        style: GoogleFonts.poppins(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      onTap: report['onTap'] as void Function()?,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 55, 97, 70)),
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => const StartPage(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
        },
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
            icon: Icon(Icons.bar_chart),
            label: 'Sales Report',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 55, 97, 70),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
