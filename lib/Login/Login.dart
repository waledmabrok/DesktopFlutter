import 'package:flutter/material.dart';
import 'package:yourcolor_project/home/home.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Flag for password visibility

  String errorMessage = ''; // Error message for invalid login

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword; // Change the visibility state
    });
  }

  // Login function to validate username and password
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check if the username and password are correct
    if (username == 'admin' && password == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QRCodeServer()), // Navigate to the next page after successful login
      );
    } else {
      setState(() {
        errorMessage = 'اسم المستخدم أو كلمة المرور غير صحيحة'; // Show error message if credentials are incorrect
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0), // Padding around the form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Optional: Image can be added here
                // Image.asset('assets/logo-icon__1__1_.png', width: 100, height: 100),
                Container(
                  width: 500, // Container width
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "من فضلك ادخل البيانات", // Instruction text
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BalooBhaijaan2',
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xffefefef),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'اسم المستخدم', // Username label
                            style: TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Username input field
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'الاسم', // Placeholder text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'BalooBhaijaan2',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل االاسم'; // Validation message for empty input
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      // Password input field
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xffefefef),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'الباسورد', // Password label
                            style: TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword, // Hide password text initially
                        decoration: InputDecoration(
                          hintText: 'الباسورد', // Placeholder text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'BalooBhaijaan2',
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off), // Toggle password visibility
                            onPressed: _togglePasswordVisibility, // Call the function to toggle visibility
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black, width: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل الباسورد'; // Validation message for empty input
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage, // Display error message if credentials are incorrect
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 40),
                      // Submit Button
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF7557e4), Color(0xFF7585ec)], // Gradient background
                                stops: [0.3, 1.2],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: _login, // Call the login function on press
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'تسجيل الدخول', // Button label
                                style: TextStyle(
                                  fontFamily: 'BalooBhaijaan2',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
