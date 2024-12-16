import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  static const platform = MethodChannel('STRUTFIT_TRACKING_PIXEL_CHANNEL');

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
      'productCode': "Timberland",
      'name': 'Hiking Boots',
      'description': 'Tough hiking boots for rugged terrain and long hikes.',
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/59c09d14be42d6447733c5f8/1610330740560-QFFGP1S5P9RX9QR1T7O0/timberland+male.png?format=500w'
    },
  ];

  Future<void> triggerTrackingPixel() async {
    final orderDetails = {
      'organizationUnitId': 5,
      'orderReference': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
      'orderValue': 399.99,
      'currencyCode': 'USD',
      'userEmail': 'customer@example.com',
      'items': products.map((product) {
        return {
          'productIdentifier': product['productCode'],
          'price': 99.99,
          'quantity': 1,
          'size': '10 US',
        };
      }).toList()
    };

    try {
      final result =
          await platform.invokeMethod('registerOrderForStrutFit', orderDetails);
      print('Tracking Pixel Response: $result');
    } catch (e) {
      print('Failed to send tracking pixel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                        builder: (context) =>
                            ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: triggerTrackingPixel,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              child: Text(
                'Track Pixel for All Products',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
