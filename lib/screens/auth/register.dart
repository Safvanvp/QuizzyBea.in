import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/assets/animation.dart';
import 'package:quizzybea_in/widgets/components/my_button.dart';
import 'package:quizzybea_in/widgets/components/my_textfield.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _registerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _registerKey,
            child: Column(
              children: [
                Lottie.asset(AppAnimations.login, height: 350),
                const Text('Login',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(
                  height: 20,
                ),
                const Text('Welcome back, please login to your account',
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
                MyButton(onTap: () {}, text: 'Sign Up'),
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
                                builder: (context) => Register()));
                      },
                      child: Text('Register now',
                          style: TextStyle(
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
