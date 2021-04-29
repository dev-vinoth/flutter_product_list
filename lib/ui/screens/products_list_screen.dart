import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_products/model/products_model.dart';
import 'package:flutter_products/model/products_response.dart';
import 'package:flutter_products/network/constants.dart';
import 'package:flutter_products/ui/screens/checkout_screen.dart';
import 'package:flutter_products/ui/widgets/counter_view.dart';
import 'package:flutter_products/ui/widgets/product_cell.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductModel>(context, listen: false).getProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          padding: const EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
          child:
              Consumer<ProductModel>(builder: (context, productModel, child) {
            if (productModel.showLoader) {
              return Center(
                child: Container(
                    width: 60, height: 60, child: CircularProgressIndicator()),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Unit : ${productModel.totalUnit}'),
                        Text(
                            'Total Price : ${Constants.currencySymbol} ${productModel.totalPrice}')
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount: productModel.products.length,
                      itemBuilder: (context, index) {
                        var product = productModel.products[index];
                        return ProductCell(
                          onTap: () {
                            if (product.productVariants.length > 0) {
                              if (product.unitCount > 0) {
                                _showColorVariantsSheet(context, product);
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Please add product')));
                              }
                            }
                          },
                          counterCallBack: (count) {
                            product.unitCount = count;
                            product.isSelected = count > 0;
                            Provider.of<ProductModel>(context, listen: false)
                                .updateProduct(product);
                          },
                          product: product,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: RaisedButton(
                        child: Text('Checkout'),
                        onPressed: () {
                          var selectedProducts = productModel.products
                              .where((element) => element.isSelected);
                          if (selectedProducts.length > 0) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                      products: selectedProducts.toList(),
                                    )));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Please add product')));
                          }
                        },
                      ),
                    ),
                  )
                ],
              );
            }
          })),
    );
  }

  void _showColorVariantsSheet(BuildContext context, Products product) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          var colorVariants = product.productVariants
              .where((element) => element.variantType == 'color');
          return Consumer<ProductModel>(
              builder: (context, productModel, child) {
            return Container(
              height: (colorVariants.length * 66).toDouble() + 100.0,
              child: Column(
                children: [
                  Container(
                      height: 40,
                      child: Center(
                        child: Text(
                          'Select Color',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      )),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: colorVariants.length,
                        itemBuilder: (context, index) {
                          var variant = colorVariants.toList()[index];
                          return CheckboxListTile(
                            title: Text(variant.variantValue),
                            value: variant.isSelected,
                            onChanged: (value) {
                              colorVariants.forEach((element) {
                                variant.isSelected = value;
                                Provider.of<ProductModel>(context,
                                        listen: false)
                                    .updateProduct(product);
                                // if (element.variantValue ==
                                //     variant.variantValue) {
                                //   variant.isSelected = value;
                                //   Provider.of<ProductModel>(context,
                                //           listen: false)
                                //       .updateProduct(product);
                                // } else {
                                //   element.isSelected = false;
                                // }
                              });
                            },
                            secondary: const Icon(Icons.stream),
                          );
                        }),
                  ),
                  Divider(),
                  Container(
                      height: 44,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text('Next'),
                            onPressed: () {
                              Navigator.of(context).pop();

                              var selectedColors = product.productVariants
                                  .where((element) =>
                                      element.isSelected &&
                                      element.variantType == 'color');

                              // var sizeVariants = product.productVariants.where(
                              //         (element) => element.variantType == 'size');
                              if (selectedColors.length > 0) {
                                if (selectedColors
                                        .map((e) => e.sizeVariant)
                                        .length >
                                    0) {
                                  _showSizeVariantsSheet(context, product,
                                      selectedColors.toList());
                                }
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Please select color')));
                              }
                            },
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }

  void _showSizeVariantsSheet(BuildContext context, Products product,
      List<ProductVariant> colorVariants) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          // var sizeVariants = product.productVariants
          //     .where((element) => element.variantType == 'size');
          return Consumer<ProductModel>(
              builder: (context, productModel, child) {
            return Container(
              height:
                  ((colorVariants.first.sizeVariant.length * 66).toDouble() +
                          100.0) *
                      2.2,
              child: Column(
                children: [
                  Container(
                      height: 44,
                      child: Center(
                        child: Text(
                          'Select Size',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      )),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: colorVariants.length,
                        itemBuilder: (context, i) {
                          return Container(
                            height:
                                ((colorVariants.first.sizeVariant.length * 90)
                                    .toDouble()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 44,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        colorVariants[i].variantValue,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54),
                                      ),
                                    )),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            colorVariants[i].sizeVariant.length,
                                        itemBuilder: (context, index) {
                                          var sizeVariant = colorVariants[i]
                                              .sizeVariant[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.stream),
                                                    SizedBox(width: 16),
                                                    Text(sizeVariant
                                                        .variantValue),
                                                  ],
                                                ),
                                                CounterView(
                                                  initNumber:
                                                      sizeVariant.sizeCount,
                                                  counterCallback: (count) {
                                                    sizeVariant.isSelected =
                                                        count > 0;
                                                    sizeVariant.sizeCount =
                                                        count;
                                                    colorVariants[i]
                                                            .subVariantCount =
                                                        colorVariants[i]
                                                            .sizeVariant
                                                            .map((e) =>
                                                                e.sizeCount)
                                                            .reduce((a, b) =>
                                                                a + b);
                                                    product.productVariants =
                                                        colorVariants;
                                                    product.unitCount =
                                                        colorVariants
                                                            .map((e) => e
                                                                .subVariantCount)
                                                            .reduce((a, b) =>
                                                                a + b);
                                                    Provider.of<ProductModel>(
                                                            context,
                                                            listen: false)
                                                        .updateProduct(product);
                                                    // colorVariants[i]
                                                    //     .sizeVariant
                                                    //     .forEach((element) {
                                                    //   if (element
                                                    //           .variantValue ==
                                                    //       sizeVariant
                                                    //           .variantValue) {
                                                    //     sizeVariant.isSelected =
                                                    //         count > 0;
                                                    //     sizeVariant.sizeCount =
                                                    //         count;
                                                    //     Provider.of<ProductModel>(
                                                    //             context,
                                                    //             listen: false)
                                                    //         .updateProduct(
                                                    //             product);
                                                    //   }
                                                    // });
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        })),
                                Divider()
                              ],
                            ),
                          );
                        }),
                  ),
                  Divider(),
                  Container(
                      height: 44,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text('Apply'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }
}
