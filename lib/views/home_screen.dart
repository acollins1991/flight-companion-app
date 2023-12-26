import 'package:flight_companion_app/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: "Home",
        body: Container(
            child: MaterialButton(
          onPressed: () => context.go("/chat"),
          child: Text("Go to chat"),
        )));
  }
}
