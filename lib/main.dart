import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'productCode': "DrMartens",
      'name': 'Running Shoes',
      'description':
          'Lightweight running shoes designed for speed and comfort.',
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/59c09d14be42d6447733c5f8/1720735606400-ZRQ0ARY3621J7OPV29DF/images+%281%29.png?format=500w'
    },
    {
      'id': 2,
      'productCode': "Cloudrock2",
      'name': 'Trail Shoes',
      'description': 'Rugged trail running shoes for off-road adventures.',
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/59c09d14be42d6447733c5f8/1720736581642-LP8JWTMLU5X9HLB605B8/7053293.png?format=500w'
    },
    {
      'id': 3,
      'productCode': "HOKA Bondi 8",
      'name': 'Casual Sneakers',
      'description': 'Stylish everyday sneakers with a modern design.',
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/59c09d14be42d6447733c5f8/1721008507588-A2IQLRYJWX9C9PJLK0MO/yellow-sneakers-vector-isolated-600nw-569243245-ezgif.com-webp-to-jpg-converter.jpg?format=500w'
    },
    {
      'id': 4,
      'productCode': "Wrong product",
      'name': 'Hiking Boots',
      'description': 'Tough hiking boots for rugged terrain and long hikes.',
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/59c09d14be42d6447733c5f8/1610330740560-QFFGP1S5P9RX9QR1T7O0/timberland+male.png?format=500w'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product['imageUrl'],
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product['name']),
            subtitle: Text(product['description'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _showStrutFitButton = true;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final creationParams = {
      'organizationId': 5,
      'productCode': product['productCode'],
      'sizeUnit': 'US',
      'apparelSizeUnit': 'US',
    };

    print('🔍 Creation Params for ${product['name']}: $creationParams');

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
                            // key: ValueKey(product['id']),
                            viewType: 'strutfit_button_view',
                            layoutDirection: TextDirection.ltr,
                            creationParams: creationParams,
                            creationParamsCodec: const StandardMessageCodec(),
                          )
                        : UiKitView(
                            key: UniqueKey(),
                            // key: ValueKey(product['id']),
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
