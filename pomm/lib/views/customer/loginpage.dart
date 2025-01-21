import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/profilepage.dart';
import 'package:pomm/views/startpage.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginCustomerPage extends StatefulWidget {
  const LoginCustomerPage({super.key});

  @override
  State<LoginCustomerPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginCustomerPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // bool _isChecked = false;
  bool isPasswordVisible = false;

  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StartPage(),
      ),
    );
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const StartPage(), // Replace with actual register page
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password';
    } else {
      if (value.length < 6) {
        return 'Enter valid password';
      }
    }
    return null;
  }

  Widget makeInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    bool showVisibilityToggle = false,
    VoidCallback? onTapVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 75,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.poppins(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: Colors.black,
              ),
              suffixIcon: showVisibilityToggle
                  ? IconButton(
                      icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black),
                      onPressed: onTapVisibilityToggle,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(91, 158, 113, 0.612)),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(91, 158, 113, 0.9)),
                borderRadius: BorderRadius.zero,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.zero,
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.zero,
              ),
              errorStyle: GoogleFonts.poppins(
                color: Colors.white,
              ),
              hintStyle: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 68, 68, 68),
                fontSize: 14,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(91, 158, 113, 0.612),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 120),
                  Image.asset(
                    'assets/images/loginicon.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 30),
                  makeInput(
                    icon: Icons.email,
                    hint: "Email",
                    controller: emailController,
                    validator: _validateEmail,
                  ),
                  makeInput(
                    icon: Icons.lock,
                    hint: "Password",
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    showVisibilityToggle: true,
                    onTapVisibilityToggle: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _navigateToResetPassword,
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          _loginUser();
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
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegisterPage,
                        child: Text(
                          "Create a new account",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    String pass = passwordController.text;

    http.post(Uri.parse("${MyServerConfig.server}/pomm/php/login_customer.php"),
        body: {"email": email, "password": pass}).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Customer customer = Customer.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You have successfully logged in"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => ProfilePage(
                        customerdata: customer,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed. Please create a new account"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
