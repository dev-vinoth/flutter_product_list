import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
    this.error,
    this.products,
  });

  bool error;
  List<Products> products;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        error: json["error"],
        products: List<Products>.from(
            json["product_list"].map((x) => Products.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "product_list": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Products {
  Products(
      {this.tenantId,
      this.name,
      this.customCode,
      this.unitprice,
      this.msp,
      this.id,
      this.isActive,
      this.productOption1,
      this.meta,
      this.discount,
      this.gst,
      this.sp,
      this.productVariants,
      this.productAccessories,
      this.unitCount,
      this.itemPrice,
      this.isSelected});

  int tenantId;
  String name;
  String customCode;
  String unitprice;
  String msp;
  int id;
  bool isActive;
  List<int> productOption1;
  Meta meta;
  Discount discount;
  String gst;
  int sp;
  List<ProductVariant> productVariants;
  List<ProductAccessory> productAccessories;
  int unitCount;
  int itemPrice;
  bool isSelected;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        tenantId: json["tenant_id"],
        name: json["name"],
        customCode: json["custom_code"],
        unitprice: json["unitprice"],
        msp: json["msp"],
        id: json["id"],
        isActive: json["is_active"],
        productOption1: json["product_option1"] == null
            ? null
            : List<int>.from(json["product_option1"].map((x) => x)),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        discount: Discount.fromJson(json["discount"]),
        gst: json["gst"],
        sp: json["sp"],
        unitCount: 0,
        itemPrice: 0,
        isSelected: false,
        productVariants: List<ProductVariant>.from(
            json["product_variants"].map((x) => ProductVariant.fromJson(x))),
        productAccessories: List<ProductAccessory>.from(
            json["product_accessories"]
                .map((x) => ProductAccessory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tenant_id": tenantId,
        "name": name,
        "custom_code": customCode,
        "unitprice": unitprice,
        "msp": msp,
        "id": id,
        "is_active": isActive,
        "product_option1": productOption1 == null
            ? null
            : List<dynamic>.from(productOption1.map((x) => x)),
        "meta": meta == null ? null : meta.toJson(),
        "discount": discount.toJson(),
        "gst": gst,
        "sp": sp,
        "itemPrice": itemPrice,
        "unitCount": unitCount,
        "isSelected": isSelected,
        "product_variants":
            List<dynamic>.from(productVariants.map((x) => x.toJson())),
        "product_accessories":
            List<dynamic>.from(productAccessories.map((x) => x.toJson())),
      };
}

class Discount {
  Discount({
    this.isDiscountPercent,
    this.discountValue,
  });

  bool isDiscountPercent;
  dynamic discountValue;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        isDiscountPercent: json["is_discount_percent"],
        discountValue: json["discount_value"],
      );

  Map<String, dynamic> toJson() => {
        "is_discount_percent": isDiscountPercent,
        "discount_value": discountValue,
      };
}

class Meta {
  Meta({
    this.description,
    this.specifications,
    this.features,
    this.imageId,
    this.variant,
  });

  String description;
  String specifications;
  String features;
  String imageId;
  String variant;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        description: json["description"],
        specifications: json["specifications"],
        features: json["features"],
        imageId: json["imageId"] == null ? null : json["imageId"],
        variant: json["variant"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "specifications": specifications,
        "features": features,
        "imageId": imageId == null ? null : imageId,
        "variant": variant,
      };
}

class ProductAccessory {
  ProductAccessory({
    this.accessoriesId,
    this.productId,
    this.name,
    this.sellingPrice,
    this.gst,
    this.createdAt,
  });

  int accessoriesId;
  int productId;
  String name;
  int sellingPrice;
  int gst;
  DateTime createdAt;

  factory ProductAccessory.fromJson(Map<String, dynamic> json) =>
      ProductAccessory(
        accessoriesId: json["accessories_id"],
        productId: json["product_id"],
        name: json["name"],
        sellingPrice: json["selling_price"],
        gst: json["gst"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "accessories_id": accessoriesId,
        "product_id": productId,
        "name": name,
        "selling_price": sellingPrice,
        "gst": gst,
        "created_at": createdAt.toIso8601String(),
      };
}

class ProductVariant {
  ProductVariant({
    this.productId,
    this.variantType,
    this.variantValue,
    this.tenantId,
    this.createdAt,
    this.isSelected,
    this.sizeVariant,
    this.subVariantCount,
  });

  int productId;
  String variantType;
  String variantValue;
  int tenantId;
  DateTime createdAt;
  bool isSelected;
  int subVariantCount;
  List<SizeVariant> sizeVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
      productId: json["product_id"],
      variantType: json["variant_type"],
      variantValue: json["variant_value"],
      tenantId: json["tenant_id"],
      createdAt: DateTime.parse(json["created_at"]),
      isSelected: false,
      subVariantCount: 0,
      sizeVariant: []);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "variant_type": variantType,
        "variant_value": variantValue,
        "tenant_id": tenantId,
        "created_at": createdAt.toIso8601String(),
        "isSelected": isSelected,
        "sizeVariant": sizeVariant
      };
}

class SizeVariant {
  SizeVariant(
      {this.variantType, this.variantValue, this.isSelected, this.sizeCount});

  String variantType;
  String variantValue;
  bool isSelected;
  int sizeCount;

  factory SizeVariant.fromJson(Map<String, dynamic> json) => SizeVariant(
      variantType: json["variant_type"],
      variantValue: json["variant_value"],
      isSelected: false,
      sizeCount: 0);

  Map<String, dynamic> toJson() => {
        "variant_type": variantType,
        "variant_value": variantValue,
        "isSelected": isSelected,
        "sizeCount": sizeCount
      };
}
