import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/customer/mainpage.dart';
import 'package:pomm/views/loginpage_clerkadmin.dart';
import 'package:pomm/views/customer/loginpage.dart'; // Import the LoginPage (replace with your actual file)
import 'package:pomm/views/customer/registerpage.dart';
import 'package:pomm/views/customer/profilepage.dart'; // Import the RegisterPage (replace with your actual file)

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(91, 158, 113, 0.612),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 180),
                // Image Section
                Image.asset(
                  'assets/images/loginicon.png', // Make sure the asset path is correct
                  height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                ),

                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Register Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductPage(), // Change to your actual RegisterPage class
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: const Color.fromARGB(227, 20, 40, 28),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Login Button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Login Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegisterPage(), // Change to your actual LoginPage class
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: const Color.fromARGB(227, 20, 40, 28),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                // Clerk or Admin Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Clerk or Admin?",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Login Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginClerkAdminPage(), // Change to your actual LoginPage class
                          ),
                        );
                      },
                      child: Text(
                        " Login",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
