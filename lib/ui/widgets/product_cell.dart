import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products/model/products_model.dart';
import 'package:flutter_products/model/products_response.dart';
import 'package:flutter_products/network/constants.dart';
import 'package:provider/provider.dart';

import 'counter_view.dart';

class ProductCell extends StatelessWidget {
  final Function onTap;
  final Products product;
  final Function(int) counterCallBack;
  ProductCell({Key key, this.onTap, this.product, this.counterCallBack})
      : super(key: key);

  final txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtController.text = product.sp.toString();
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
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
                      child: Text(product?.name ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                    ),
                    Container(
                      child: Text(
                          Constants.currencySymbol + (product?.unitprice ?? ''),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black38)),
                    ),
                    Container(
                      height: 30,
                      width: 70,
                      child: Center(
                        child: TextField(
                          controller: txtController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //border: InputBorder.none,
                            hintText: 'SP Price',
                            hintStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.grey.shade50,
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.all(8),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 12, color: Colors.black26),
                          //controller: controller,
                          onSubmitted: (value) {
                            if (value != null) {
                              product.sp = int.parse(value);
                              Provider.of<ProductModel>(context, listen: false)
                                  .updateSplPrice(product);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //color: Colors.red,
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      product.productVariants.length > 0
                          ? Icon(
                              Icons.star,
                              color: Colors.orange,
                            )
                          : Container(),
                      Center(
                        child: CounterView(
                          initNumber: product.unitCount ?? 0,
                          counterCallback: (count) {
                            counterCallBack(count);
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
