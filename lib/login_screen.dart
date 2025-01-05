import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 139, 196, 247),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset('assets/login_image.png'),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.all(25),
                      filled: true,
                      fillColor: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    contentPadding: const EdgeInsets.all(25),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _obscureText = !_obscureText;
                        setState(() {});
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 75, 148, 243),
                        foregroundColor: const Color.fromARGB(255, 13, 13, 14),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Center(child: Text('craete an account'))
              ],
            ),
          ),
        ));
  }
}
