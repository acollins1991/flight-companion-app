import 'package:flight_companion_app/router.dart';
import 'package:flutter/material.dart';

const seedColour = Color.fromRGBO(135, 206, 235, 1);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: seedColour),
    //     useMaterial3: true,
    //   ),
    // );
  }
}
