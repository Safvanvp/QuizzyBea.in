import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/assets/animation.dart';
import 'package:quizzybea_in/screens/auth/login_page.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/widgets/components/my_button.dart';
import 'package:quizzybea_in/widgets/components/my_textfield.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _registerKey = GlobalKey<FormState>();

  Future<void> register(BuildContext context) async {
    final authServices = AuthServices();
    try {
      await authServices.signUpWithEmailAndPassword(
          emailController.text, passwordController.text, nameController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Signup Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _registerKey,
            child: Column(
              children: [
                Lottie.asset(AppAnimations.login, height: 350),
                const Text('Sign Up',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(
                  height: 20,
                ),
                const Text('Create an account to get started',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87)),
                const SizedBox(
                  height: 40,
                ),
                MyTextfield(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                    hintText: 'Name',
                    obscureText: false,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                    hintText: 'Password',
                    obscureText: false,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                    hintText: 'Confirm Password',
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 30,
                ),
                MyButton(
                    onTap: () {
                      if (_registerKey.currentState!.validate()) {
                        register(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Failed'),
                            content: const Text('Please fill all fields'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    text: 'Sign Up'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have a account?,",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: const Text('Signup now',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
