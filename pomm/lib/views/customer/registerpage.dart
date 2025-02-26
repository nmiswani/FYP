import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/customer/loginpage.dart';
import 'dart:convert';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(
          91, 158, 113, 0.612), // Set background color to green
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
                  Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Create an account, it's free!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 60),
                  makeInput(
                    icon: Icons.account_circle,
                    hint: "Name",
                    controller: nameController,
                    validator: _validateName,
                  ),
                  makeInput(
                    icon: Icons.email,
                    hint: "Email",
                    controller: emailController,
                    validator: _validateEmail,
                  ),
                  makeInput(
                    icon: Icons.phone,
                    hint: "Phone Number",
                    controller: phoneNumberController,
                    validator: _validatePhoneNumber,
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
                  const SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            showConfirmationDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, // Set button color to white
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
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
      ),
    );
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
          height: 75, // Fixed height for TextField and error message
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.poppins(
                color: Colors.black), // Text color inside TextBox
            decoration: InputDecoration(
              filled: true, // Enables background color for TextBox
              fillColor: Colors.white, // Background color
              hintText: hint, // Hint text that stays inside the TextBox
              prefixIcon: Icon(
                icon,
                color: Colors.black, // Icon color set to black
              ),
              suffixIcon: showVisibilityToggle
                  ? IconButton(
                      icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors
                              .black), // Visibility icon color set to black
                      onPressed: onTapVisibilityToggle,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(91, 158, 113, 0.612)), // Border color
                borderRadius: BorderRadius.zero, // Removed rounded borders
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(91, 158, 113, 0.9)), // Focused border
                borderRadius: BorderRadius.zero, // Removed rounded borders
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red), // Error border
                borderRadius: BorderRadius.zero, // Removed rounded borders
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red), // Error focus border
                borderRadius: BorderRadius.zero, // Removed rounded borders
              ),
              errorStyle: GoogleFonts.poppins(
                color: Colors.white, // Set error text color to white
              ),
              hintStyle: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 68, 68, 68), // Hint text color
                fontSize: 14, // Updated font size
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginCustomerPage(),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter name';
    }
    if (RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Name cannot contain symbols';
    }
    if (value.contains(RegExp(r'\s'))) {
      return 'Name cannot contain space';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      // EDIT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email format"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return 'Enter valid email (e.g. abu@gmail.com)';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      // EDIT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("These field are required"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return 'Enter phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter valid phone number (e.g. 0123456789)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password';
    } else {
      if (value.length < 6) {
        return 'Password must be at least 6 characters long';
      }
    }
    return null;
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Register new account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _registerSuccessful();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registration Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void _registerSuccessful() {
    String _name = nameController.text;
    String _email = emailController.text;
    String _phone = phoneNumberController.text;
    String _pass = passwordController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/register_customer.php"),
        body: {
          "name": _name,
          "email": _email,
          "phone": _phone,
          "password": _pass
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You have successfully registered"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => const LoginCustomerPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
