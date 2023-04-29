import 'package:esearchplayers/components/my_botton.dart';
import 'package:esearchplayers/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? oneTap;
  const LoginPage({super.key, required this.oneTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final tagController = TextEditingController();

  void loginUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                // Logo
                Icon(Icons.gamepad,
                    size: 100.0, color: Theme.of(context).primaryColor),
                const SizedBox(height: 50.0),
                // Login Form
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icon(Icons.email,
                        color: Theme.of(context).primaryColor),
                    obscureText: false),
                const SizedBox(height: 10.0),
                MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    obscureText: true),
                const SizedBox(height: 10.0),
                Text(
                  "Forgot Password?",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 20.0),
                MyButton(
                    text: "Sign In",
                    onTap: loginUser,
                    width: 200.0,
                    height: 50.0),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: widget.oneTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
