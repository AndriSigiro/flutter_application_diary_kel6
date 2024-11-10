import 'package:flutter_application_diary/Authtentication/signup.dart';
import 'package:flutter_application_diary/JsonModels/users.dart';
import 'package:flutter_application_diary/SQLite/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_diary/Views/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    var response = await db.login(Users(usrName: username.text, usrPassword: password.text));
    if (response == true) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

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
                    mainAxisSize: MainAxisSize.min, // Adjusts height based on content
                    children: [
                      Image.asset(
                        "images/profile.png",
                        width: 210,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white, // Increased opacity
                        ),
                        child: TextFormField(
                          controller: username,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username is required";
                            }
                            return null;
                          },
                          style: const TextStyle(color:Colors.black),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person, color: Colors.black),
                            border: InputBorder.none,
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white, // Increased opacity
                        ),
                        child: TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                          obscureText: !isVisible,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock, color: Colors.black),
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black54),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              login();
                            }
                          },
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                            },
                            child: const Text("Daftar Yuk!!!", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      isLoginTrue
                          ? const Text(
                              "Username or password is incorrect",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
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
}