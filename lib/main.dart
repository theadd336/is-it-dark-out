import 'dart:async';
import 'package:flutter/material.dart';
import 'ffi.io.dart' show api;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is It Dark Out?',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true),
      home: const AppPage(),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  bool isItDarkOut = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(minutes: 1), ((timer) => _evaluateDarkness()));
  }

  Future<void> _evaluateDarkness() async {
    final darknessStatus = await api.isItDarkOut();
    if (mounted) setState(() => isItDarkOut = darknessStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String message;
    final Color backgroundColor;
    final Color textColor;
    if (isItDarkOut) {
      backgroundColor = Colors.black;
      textColor = Colors.white;
      message = "YES";
    } else {
      textColor = Colors.black;
      backgroundColor = Colors.white;
      message = "NO";
    }
    final textStyle = theme.textTheme.displayLarge!.copyWith(color: textColor);
    return Container(
        color: backgroundColor,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text(message, style: textStyle)],
        )));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
