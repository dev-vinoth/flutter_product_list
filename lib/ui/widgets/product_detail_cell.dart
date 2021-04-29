import 'package:flutter/material.dart';
import 'package:flutter_products/model/products_response.dart';
import 'package:flutter_products/network/constants.dart';

class ProductDetailCell extends StatelessWidget {
  final Function onTap;
  final Products product;
  ProductDetailCell({Key key, this.onTap, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: product.productVariants
                    .where((element) => element.isSelected)
                    .length >
                0
            ? 300
            : 100,
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white, offset: Offset(1.1, 1.1), blurRadius: 2.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text('Product Name : ${product?.name ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                    ),
                    Container(
                      child: Text(
                          'Unit Price : ${Constants.currencySymbol + (product?.unitprice ?? '')}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black38)),
                    ),
                    Container(
                      child: Text(
                          'Special Price : ${Constants.currencySymbol + (product.sp.toString())}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black38)),
                    ),
                    Visibility(
                        visible: product.productVariants
                                .where((element) => element.isSelected)
                                .length >
                            0,
                        child: Divider()),
                    Visibility(
                      visible: product.productVariants
                              .where((element) => element.isSelected)
                              .length >
                          0,
                      child: Container(
                        child: Text('Variants',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black54)),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: product.productVariants
                                .where((element) => element.isSelected)
                                .length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Text(
                                    product.productVariants[index]
                                            .variantValue +
                                        '\n' +
                                        '\t\t' +
                                        '${product.productVariants[index].sizeVariant.map((e) => 'Size: ${e.variantValue} // Qty : ${e.sizeCount} \n')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black38)),
                              );
                            })),
                  ],
                ),
                //color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
