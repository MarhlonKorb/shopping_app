import 'package:flutter/material.dart';
import 'package:shop/pages/products_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato'),
        home: ProductsOverviewPage());
  }
}
