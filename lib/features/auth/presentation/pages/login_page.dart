import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },);
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign In.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              Gap(30),
              AuthField(
                hintText: "Email",
                controller: emailController,
              ),
              Gap(15),
              AuthField(
                hintText: "Password",
                controller: passwordController,
                isObsureText: true,
              ),
              Gap(20),
              AuthGradientButton(
                buttonText: 'Sign In',
              ),
              Gap(20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,SignupPage.route());
                },
                child: RichText(
                    text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                      TextSpan(
                        text: "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold),
                      )
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}
