import 'package:booknest/pages/sign_up_page.dart';
import 'package:booknest/pages/user_dashboard_page.dart';
import 'package:booknest/providers/auth_provider.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/widgets/button_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signInUser() async {
    final authService = ref.watch(authServiceProvider);
    String auth = await authService.signInUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (auth == 'success') {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        ref.read(currentUserProvider.notifier).state = user.uid;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserDashboardPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth, textAlign: TextAlign.center),
        backgroundColor: Color.fromARGB(255, 255, 165, 143),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Log in',
              style: TextStyle(color: Color.fromARGB(255, 255, 246, 220)),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 128, 162, 121),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                textAlign: TextAlign.center,
                "Log into you account",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 159, 178),
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputWidget(
                controller: emailController,
                labelText: "e-mail",
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputWidget(
                controller: passwordController,
                labelText: "password",
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                onPressed: signInUser,
                text: 'Log In',
              ),
              TextButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      foregroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 255, 159, 178))),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text(
                    "Don't have an account? Register here!",
                    style: TextStyle(fontSize: 15),
                  ))
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 246, 220));
  }
}
