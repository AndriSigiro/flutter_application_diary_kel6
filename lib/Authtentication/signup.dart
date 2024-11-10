import 'package:flutter_application_diary/Authtentication/login.dart';
import 'package:flutter_application_diary/JsonModels/users.dart';
import 'package:flutter_application_diary/SQLite/sqlite.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the entire screen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/diary.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for better visibility of input fields
          Container(
            color: Colors.black54,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Register New Account",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // Username field
                      _buildTextField(
                        controller: username,
                        icon: Icons.person,
                        hint: "Username",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                      ),

                      // Password field
                      _buildTextField(
                        controller: password,
                        icon: Icons.lock,
                        hint: "Password",
                        obscureText: !isVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),

                      // Confirm Password field
                      _buildTextField(
                        controller: confirmPassword,
                        icon: Icons.lock,
                        hint: "Confirm Password",
                        obscureText: !isVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          } else if (password.text != confirmPassword.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      // Sign Up button
                      Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red,
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final db = DatabaseHelper();
                              db.signup(Users(
                                usrName: username.text,
                                usrPassword: password.text,
                              )).whenComplete(() {
                                // After successful user creation, go to login screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              });
                            }
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,),
                          ),
                        ),
                      ),

                      // Sign up prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?", style: TextStyle(color: Colors.white)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text("Login", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Increased opacity for visibility
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          suffixIcon: obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                )
              : null,
        ),
      ),
    );
  }
}