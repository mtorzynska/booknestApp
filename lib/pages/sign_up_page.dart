import 'package:booknest/pages/sign_in_page.dart';
import 'package:booknest/providers/auth_provider.dart';
import 'package:booknest/providers/goal_provider.dart';
import 'package:booknest/providers/list_provider.dart';
import 'package:booknest/widgets/button_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  void signUpUser() async {
    final authService = ref.watch(authServiceProvider);
    String res = await authService.registerUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text);

    if (!res.contains("Error") && !res.contains('Please')) {
      final listService = ref.read(listServiceProvider);
      final goalService = ref.read(goalServiceProvider);
      await goalService.createEmptyGoalsCollectionForNewUser(res);
      await listService.createDefaultListsForNewUser(res);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res, textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 255, 165, 143),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 128, 162, 121),
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Register',
          style: TextStyle(color: Color.fromARGB(255, 255, 246, 220)),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              textAlign: TextAlign.center,
              "Register a new user",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 159, 178),
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextInputWidget(controller: usernameController, labelText: "name"),
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
            ButtonWidget(onPressed: signUpUser, text: 'Register'),
            TextButton(
                style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 159, 178))),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                },
                child: const Text(
                  "Already have an account? Log in here!",
                  style: TextStyle(fontSize: 15),
                ))
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
    );
  }
}
