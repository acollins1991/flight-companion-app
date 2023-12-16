import 'package:flutter/material.dart';

class Route extends StatefulWidget {
  const Route({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  State<Route> createState() => _RouteState();
}

class _RouteState extends State<Route> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: widget.body,
    );
  }
}
