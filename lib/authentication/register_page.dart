import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './components/my_button.dart';
import './components/my_textfield.dart';
import './components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final handleController = TextEditingController();
  final pfpURLController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign user up method
  void signUserUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

// Try sign up
    try {
      // check if password and confirmed password match
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': emailController.text,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'handle': handleController.text,
          'pfpURL': pfpURLController.text,
        });
      } else {
        // show error message, passwords do not match
        showErrorMessage("Passwords don't match");
      }
      // Pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // show error code
      showErrorMessage(e.code);
    }
  }

// show error
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Center(
              child:
                  Text(message, style: const TextStyle(color: Colors.white))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),

                // icon place holder

                Icon(
                  Icons.android,
                  size: 50,
                ),

                // Welcome

                Text(
                  "Create an account here!",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),

                SizedBox(height: 15),

                // Email Textfield

                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: firstNameController,
                        hintText: 'First Name',
                        obscureText: false,
                      ),
                    ),
                    SizedBox(width: 0.5), // Spacer (10 pixels
                    Expanded(
                      child: MyTextField(
                        controller: lastNameController,
                        hintText: 'Last Name',
                        obscureText: false,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                MyTextField(
                  controller: handleController,
                  hintText: 'Handle',
                  obscureText: false,
                ),

                SizedBox(height: 10),

                MyTextField(
                  controller: pfpURLController,
                  hintText: 'Profile Picture URL',
                  obscureText: false,
                ),

                SizedBox(height: 10),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                // Password Textfield

                SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                // CONFIRM Password Textfield

                SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                // Sign In Button

                SizedBox(height: 10),

                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),

                SizedBox(height: 35),

                // Login with Apple/Google

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or login with:",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ],
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                // Apple/Google Sign in buttons
                // ignore: prefer_const_constructors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Google button
                    SquareTile(
                        imagePath: 'lib/authentication/images/google.png'),

                    SizedBox(width: 25),

                    // Apple Button
                    SquareTile(imagePath: 'lib/authentication/images/apple.png')
                  ],
                ),

                SizedBox(height: 50),

                // Registration

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Sign in here!",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
