import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image to Text Converter GetX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), // ThemeData
      home: Home(),
    ); // GetMaterialApp
  }
}