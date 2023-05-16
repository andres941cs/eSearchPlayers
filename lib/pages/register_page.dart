import 'package:esearchplayers/components/my_botton.dart';
import 'package:esearchplayers/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final Function()? oneTap;
  const RegisterPage({super.key, required this.oneTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final tagController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        await addUserDetails(userCredential.user!.uid, usernameController.text,
            tagController.text);
      } else {
        showErrorMessage("Passwords do not match");
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  Future<void> addUserDetails(
      String userId, String username, String tag) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      "username": username,
      "email": emailController.text,
      "tag": tag,
      "search": false,
      "guild": false,
      "profileImageUrl": ''
    });
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
                // Logo
                const Text("Create your account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 50.0),
                // Register Form
                MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                    icon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                    obscureText: false),
                const SizedBox(height: 10.0),
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
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    icon:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    obscureText: true),
                const SizedBox(height: 10.0),
                MyTextField(
                    controller: tagController,
                    hintText: "Tag#****",
                    icon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                    obscureText: false),
                const SizedBox(height: 20.0),
                MyButton(
                    text: "Sign In",
                    onTap: registerUser,
                    width: 200.0,
                    height: 50.0),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Aready have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: widget.oneTap,
                      child: Text(
                        "Login Now",
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
