import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/assets/animation.dart';
import 'package:quizzybea_in/widgets/components/my_button.dart';
import 'package:quizzybea_in/widgets/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(AppAnimations.login, height: 400),
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
                  controller: emailController),
              const SizedBox(
                height: 20,
              ),
              MyTextfield(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController),
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
              MyButton(onTap: () {}, text: 'Login'),
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
                    onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
