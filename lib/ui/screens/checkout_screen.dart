import 'package:flutter/material.dart';
import 'package:flutter_products/model/products_response.dart';
import 'package:flutter_products/ui/widgets/product_detail_cell.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Products> products;

  const CheckoutScreen({Key key, this.products}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                var product = widget.products[index];
                return ProductDetailCell(
                  onTap: () {},
                  product: product,
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: RaisedButton(
                child: Text('Place Order'),
                onPressed: () {
                  print(widget.products.toString());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
