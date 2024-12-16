import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final creationParams = {
      'organizationId': 5,
      'productCode': product['productCode'],
      'sizeUnit': 'US',
      'apparelSizeUnit': 'US',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              product['imageUrl'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Product Description
                  Text(
                    product['description'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),

                  const SizedBox(
                      height: 20), // Spacing before the StrutFit button

                  // StrutFit Button
                  Text(
                    'Find your perfect size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 500, // Width of StrutFit button
                    height: 60, // Height of StrutFit button
                    alignment: Alignment.center,
                    child: Platform.isAndroid
                        ? AndroidView(
                            key: UniqueKey(),
                            viewType: 'strutfit_button_view',
                            layoutDirection: TextDirection.ltr,
                            creationParams: creationParams,
                            creationParamsCodec: const StandardMessageCodec(),
                          )
                        : UiKitView(
                            key: UniqueKey(),
                            viewType: 'strutfit_button_view',
                            layoutDirection: TextDirection.ltr,
                            creationParams: {
                              ...creationParams,
                              'key': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString()
                            },
                            creationParamsCodec: const StandardMessageCodec(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}