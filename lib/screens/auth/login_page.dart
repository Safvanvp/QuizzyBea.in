import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/assets/animation.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/screens/auth/register.dart';
import 'package:quizzybea_in/screens/home/home.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/widgets/components/my_button.dart';
import 'package:quizzybea_in/widgets/components/my_logi_providers.dart';
import 'package:quizzybea_in/widgets/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();

  //login function
  Future<void> login(BuildContext context) async {
    final authServices = AuthServices();
    try {
      await authServices.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      //navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      print("Login successful!");
    } catch (e) {
      print("Login error: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _loginKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Lottie.asset(AppAnimations.login, height: 300),
                const Text('Login',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(
                  height: 10,
                ),
                const Text('Welcome back, please login to your account',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87)),
                const SizedBox(
                  height: 20,
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
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                    onTap: () {
                      if (_loginKey.currentState!.validate()) {
                        login(context);
                      }
                    },
                    text: 'Login'),
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
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Colors.black54,
                      thickness: 2,
                      endIndent: 10,
                      indent: 20,
                    )),
                    Text('or with',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Expanded(
                        child: Divider(
                      color: Colors.black54,
                      thickness: 2,
                      endIndent: 10,
                      indent: 20,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyLoginproviders(
                            providername: 'Google', image: AppImages.google)),
                    Expanded(
                        child: MyLoginproviders(
                            providername: 'Apple', image: AppImages.apple))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
