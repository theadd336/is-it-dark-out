import 'dart:async';
import 'package:flutter/material.dart';
import 'package:is_it_dark_out/bridge_generated.io.dart';
import 'ffi.io.dart' show api;

import 'package:geolocator/geolocator.dart';

enum PermissionState { serviceDisabled, permissionDenied, deniedForever, ok }

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
  bool checkPermissions = true;
  bool showPermissionScreen = false;
  bool isItDarkOut = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 10), ((timer) => _evaluateDarkness()));
  }

  Future<PermissionState> _checkPositionPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return PermissionState.serviceDisabled;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return PermissionState.permissionDenied;
    }

    if (permission == LocationPermission.deniedForever) {
      return PermissionState.deniedForever;
    }
    return PermissionState.ok;
  }

  Future<void> _evaluateDarkness() async {
    if (checkPermissions) {
      final status = await _checkPositionPermissions();
      if (status != PermissionState.ok) {
        if (mounted) {
          setState(() {
            showPermissionScreen = true;
            checkPermissions = false;
          });
        }
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.reduced);
    final coordinates =
        Coordinates(latitude: position.latitude, longitude: position.longitude);
    final darknessStatus = await api.isItDarkOut(position: coordinates);
    if (mounted) setState(() => isItDarkOut = darknessStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String message;
    final Color backgroundColor;
    final Color textColor;
    if (showPermissionScreen) {
      backgroundColor = Colors.black;
      textColor = Colors.white;
      message = "Location permissions are required to determine darkness.";
    } else if (isItDarkOut) {
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
