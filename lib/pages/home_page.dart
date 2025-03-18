import 'package:booknest/pages/sign_in_page.dart';
import 'package:booknest/pages/sign_up_page.dart';
import 'package:booknest/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 128, 162, 121),
        title: const Center(
            child: Text(
          "BookNest",
          style: TextStyle(color: Color.fromARGB(255, 255, 246, 220)),
        )),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/booknest.jpg',
              height: 200,
            ),
            const Text("Welcome!",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 165, 143),
                  fontSize: 25,
                )),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SignInPage()));
              },
              text: "Sign in",
              backgroundColor: Color.fromARGB(255, 255, 165, 143),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                text: "Sign up",
                backgroundColor: Color.fromARGB(255, 255, 165, 143)),
          ],
        ),
      ),
    );
  }
}
