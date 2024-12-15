import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('StrutFit Button Example')),
        body: Center(
          child: Container(
            width: 800, // Set button width
            height: 120, // Set button height
            child: AndroidView(
              viewType: 'strutfit_button_view',
              layoutDirection: TextDirection.ltr,
              creationParams: {
                'organizationId': 1,
                'productCode': 'TestProduct',
                'sizeUnit': 'US',
                'apparelSizeUnit': 'US',
                'width': 800,
                'height': 120,
              },
              creationParamsCodec: const StandardMessageCodec(),
            ),
          ),
        ),
      ),
    );
  }
}
