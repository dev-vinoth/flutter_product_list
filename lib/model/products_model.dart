import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_products/model/products_response.dart';
import 'package:flutter_products/network/api_manager.dart';
import 'package:flutter_products/network/constants.dart';

class ProductModel with ChangeNotifier, DiagnosticableTreeMixin {
  List<Products> products = [];
  var totalUnit = 0;
  var totalPrice = 0;

  var showLoader = true;
  Future getProducts() async {
    var response = await ApiManager().get(Endpoints.getProducts);
    var prodRes = ProductResponse.fromJson(response);
    products = prodRes.products;
    products.forEach((element) {
      var sizeVariant = element.productVariants
          .where((element) => element.variantType == 'size');

      element.productVariants
          .where((element) => element.variantType == 'color')
          .forEach((element) {
        element.sizeVariant = sizeVariant
            .map((e) => SizeVariant(
                isSelected: false,
                sizeCount: 0,
                variantType: e.variantType,
                variantValue: e.variantValue))
            .toList();
      });
    });
    //print(products);
    showLoader = false;
    notifyListeners();
  }

  updateSplPrice(Products product) {
    var finalProd = products.firstWhere((element) => element.id == product.id);
    finalProd.sp = product.sp;
    updateProduct(product);
  }

  updateProduct(Products product) {
    product.itemPrice = product.unitCount * product.sp;

    var selectedProducts = products.where((element) => element.isSelected);

    if (selectedProducts.length > 0) {
      totalUnit =
          selectedProducts.map((e) => e.unitCount).reduce((a, b) => a + b);
      totalPrice =
          selectedProducts.map((e) => e.itemPrice).reduce((a, b) => a + b);
    } else {
      totalUnit = 0;
      totalPrice = 0;
    }

    notifyListeners();
  }
}
