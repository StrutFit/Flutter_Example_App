import 'package:flutter/material.dart';
import 'product_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListPage(), // Start with the product list
    );
  }
}
