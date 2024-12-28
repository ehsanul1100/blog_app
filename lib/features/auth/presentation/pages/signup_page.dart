import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) {
          return const SignupPage();
        },
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              Gap(30),
              AuthField(
                hintText: "Name",
                controller: nameController,
              ),
              Gap(15),
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
                buttonText: 'Sign Up',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(AuthSignUp(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim()));
                  }
                },
              ),
              Gap(20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, LoginPage.route());
                },
                child: RichText(
                    text: TextSpan(
                        text: "Already have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                      TextSpan(
                        text: "Sign In",
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