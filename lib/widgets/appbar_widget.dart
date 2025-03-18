import 'package:booknest/pages/user_dashboard_page.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool arrow;
  const AppBarWidget({
    super.key,
    required this.title,
    this.arrow = false,
    this.actions,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  List<Widget>? defaultActions() {
    return [
      IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserDashboardPage(),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 25),
      ),
      centerTitle: true,
      actions: widget.actions ?? defaultActions(),
      automaticallyImplyLeading: widget.arrow,
      backgroundColor: Color.fromARGB(255, 128, 162, 121),
      foregroundColor: Color.fromARGB(255, 255, 246, 220),
    );
  }
}
/*
najjasniejszy zolty Color.fromARGB(255, 250, 237, 202)
jasny zielony Color.fromARGB(255, 128, 162, 121)
zielony Color.fromARGB(255, 193, 219, 179)
fioletowy Color.fromARGB(255, 202, 153, 205)
rozowy Color.fromARGB(255, 255, 159, 178)
pomaranczowo lososiowy Color.fromARGB(255, 255, 165, 143)
ciemniejszy pomaranczowo-zolty Color.fromARGB(255, 255, 216, 167)
 */