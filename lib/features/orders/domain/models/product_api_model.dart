import 'dart:convert';
import 'package:big_like/local_storage/shared_preferences.dart';

import 'name_api_model.dart';

/*
class ProductApiModel {
  ProductApiModel(
      {required this.id,
      // required this.price,
      // required this.sale,
      required this.name,
      required this.barcode,
      // required this.sections,
      required this.brand,
      required this.status,
      required this.group,
      required this.attributes,
      required this.contents,
      required this.weight,
      required this.weightDescriotion,
      required this.height,
      required this.width,
      required this.length,
      required this.tags,
      required this.description,
      required this.imgs,
      required this.storage,
      required this.quantity});

  late final int id;

  // late final num? price;
  // late final int? sale;
  late final Name name;
  late final String barcode;

  // late final List<Sections> sections;
  late final Brand? brand;
  late final bool status;
  late final List<dynamic> group;
  late final List<Attributes> attributes;
  late final List<Content> contents;
  late final Weight weight;
  late final WeightDescriotion weightDescriotion;
  late final num height;
  late final num width;
  late final num length;
  late final List<Tags> tags;
  late final List<Description> description;
  late final List<ImageApiModel> imgs;
  late final Storage storage;
  late final ProductDisplayApiModel? friendProduct;
  late final bool hasCondition;
  late final int? maximumSell;
  late int quantity;

  ProductApiModel.fromJson(Map<String, dynamic> json) {
    // print('json');
    id = json['id'];
    // price = json['price'];
    // sale = json['sale'];

    var thirdMap = <String, dynamic>{};

    for (var element in List.from(json['name'])) {
      thirdMap.addAll(element);
    }
    name = thirdMap.isEmpty ? Name(ar: '', he: '') : Name.fromJson(thirdMap);
    barcode = json['barcode'];
    // sections =
    //     List.from(json['sections']).map((e) => Sections.fromJson(e)).toList();
    brand = jsonEncode(json['brand']) == jsonEncode([])
        ? null
        : Brand.fromJson(json['brand']);
    status = json['status'];
    group = [];
    // group = Groups.fromJson(json['group']);

    // group = List.castFrom<dynamic, dynamic>(json['group']);
    attributes = List.from(json['attributes'])
        .map((e) => Attributes.fromJson(e))
        .toList();
    contents =
        List.from(json['contents']).map((e) => Content.fromJson(e)).toList();
    weight = Weight.fromJson(json['weight']);
    weightDescriotion = WeightDescriotion.fromJson(json['weight_descriotion']);
    height = json['height'];
    width = json['width'];
    length = json['length'];

    tags = List.from(json['tags']).map((e) => Tags.fromJson(e)).toList();
    description = List.from(json['description']).isEmpty
        ? []
        : [Description.fromJson(List.from(json['description']).first)];
    imgs =
        List.from(json['imgs']).map((e) => ImageApiModel.fromJson(e)).toList();

    friendProduct = json['friend_product'] != null
        ? ProductDisplayApiModel.fromJson(json['friend_product'])
        : null;
    hasCondition = json['has_condition'] ?? false;
    maximumSell = json['maximum_sell'];
    storage = json['storage'] != null
        ? Storage.fromJson(json['storage'], maximumSell)
        : Storage(
            id: -1,
            sale: null,
            sku: '',
            price: 0,
            quantityAlert: 0,
            status: 0,
            quantity: 0);
    quantity = json['quantity'] ?? (storage.quantity);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    // _data['price'] = price;
    // _data['sale'] = sale;
    data['name'] = name;
    data['barcode'] = barcode;
    // _data['sections'] = sections.map((e) => e.toJson()).toList();
    data['brand'] = brand!.toJson();
    data['status'] = status;
    data['group'] = group;
    data['attributes'] = attributes.map((e) => e.toJson()).toList();
    data['contents'] = contents;
    data['weight'] = weight.toJson();
    data['weight_descriotion'] = weightDescriotion.toJson();
    data['height'] = height;
    data['width'] = width;
    data['length'] = length;
    data['tags'] = tags.map((e) => e.toJson()).toList();
    data['description'] = description.map((e) => e.toJson()).toList();
    data['imgs'] = imgs.map((e) => e.toJson()).toList();
    // _data['storages'] = storages.map((e) => e.toJson()).toList();
    return data;
  }
}
*/

class Sections {
  Sections({
    required this.id,
    required this.name,
  });

  late final int id;
  late final List<Name> name;

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Groups {
  Groups({
    required this.id,
    required this.name,
  });

  late final int id;
  late final List<Name> name;

  Groups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Brand {
  Brand({
    required this.id,
    required this.image,
    required this.name,
  });

  late final int id;
  late final String? image;
  late final List<Name> name;

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Tax {
  Tax({
    required this.id,
    required this.name,
  });

  late final int id;
  late final List<Name> name;

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Attributes {
  Attributes({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  late final int id;
  late final List<Name> name;
  late final String? image;
  late final List<Description> description;

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];

    description = List.from(json['details']).isEmpty
        ? [Description(ar: ' ')]
        : [Description.fromJson(List.from(json['details']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Weight {
  Weight({
    required this.weight,
    required this.unit,
  });

  late final num weight;
  late final String unit;

  Weight.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['weight'] = weight;
    data['unit'] = unit;
    return data;
  }
}

class WeightDescriotion {
  WeightDescriotion({
    required this.weightDesc,
    required this.weightDescUnit,
  });

  late final num weightDesc;
  late final String weightDescUnit;

  WeightDescriotion.fromJson(Map<String, dynamic> json) {
    weightDesc = json['weight_desc'] ?? 0;
    weightDescUnit = json['weight_desc_unit'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['weight_desc'] = weightDesc;
    data['weight_desc_unit'] = weightDescUnit;
    return data;
  }
}

class Tags {
  Tags({
    required this.id,
    required this.tag,
  });

  late final int id;
  late final String tag;

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    return data;
  }
}

class Description {
  Description({
    required this.ar,
  });

  late final String ar;

  Description.fromJson(Map<String, dynamic> json) {
    ar = (json[AppSharedPref().languageLocale?.toUpperCase()] ?? json['AR']) ??
        "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['AR'] = ar;
    return data;
  }
}

class ImageApiModel {
  ImageApiModel({
    required this.id,
    required this.img,
    required this.originalImg,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String img;
  late final String originalImg;
  late final int productId;
  late final String createdAt;
  late final String updatedAt;

  ImageApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    originalImg = json['original_img'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    data['original_img'] = originalImg;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Storage {
  Storage({
    required this.id,
    this.sale,
    this.sku,
    required this.price,
    this.quantityAlert,
    required this.status,
    required this.quantity,
  });

  late final int id;
  late final Sale? sale;
  late final String? sku;
  late final num price;
  late final num? quantityAlert;
  late final num status;
  late final int quantity;

  Storage.fromJson(Map<String, dynamic> json, int? maximumSell) {
    id = json['id'] ?? -1;
    sale = json['sale'] != null ? Sale.fromJson(json['sale']) : null;

    sku = json['sku'];
    price = json['price'] ?? 0;
    quantityAlert = json['quantity_alert'];
    status = json['status'] ?? 0;
    quantity = maximumSell == null
        ? json['quantity'] ?? 0
        : (json['quantity'] ?? 0) >= maximumSell
            ? maximumSell
            : (json['quantity'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['sale'] = sale;
    data['sku'] = sku;
    data['price'] = price;
    data['quantity_alert'] = quantityAlert;
    data['status'] = status;
    // _data['quantity'] = quantity;
    return data;
  }
}

class Content {
  Content({
    required this.id,
    required this.name,
  });

  late final int id;
  late final List<Name> name;

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = List.from(json['name']).isEmpty
        ? [Name(ar: 'no name', he: '')]
        : [Name.fromJson(List.from(json['name']).first)];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.map((e) => e.toJson()).toList();
    return data;
  }
}

class Sale {
  Sale({
    required this.campaignId,
    // required this.productX,
    required this.type,
    required this.percentage,
    required this.salePrice,
    required this.storageId,
    required this.startDate,
    required this.endDate,
  });

  late final int campaignId;

  // late final ProductX? productX;
  late final String type;
  late final String startDate;
  late final String endDate;
  late final num percentage;
  late final num salePrice;
  late final num minCart;
  late final int? storageId;
  late final num count;

  Sale.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaign_id'];
    // productX =
    //     json['product_x'] != null ? ProductX.fromJson(json['product_x']) : null;
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    minCart = json['min_cart'] ?? 0;
    percentage = json['percentage'] ?? 0;
    salePrice = json['sale_price'] ?? 10;
    storageId = json['storage_id'];
    count = json['count'] ?? 3;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['campaign_id'] = campaignId;
    // _data['product_x'] = null;
    // _data['product_x'] = productX.toJson();
    data['type'] = type;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['percentage'] = percentage;
    data['sale_price'] = salePrice;
    data['storage_id'] = storageId;
    data['min_cart'] = minCart;
    return data;
  }
}

class ProductX {
  ProductX({
    this.product,
    this.xQuantity,
  });

  late final String? product;
  late final String? xQuantity;

  ProductX.fromJson(Map<String, dynamic> json) {
    product = null;
    xQuantity = null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product'] = product;
    data['x_quantity'] = xQuantity;
    return data;
  }
}

// class ProductDisplayApiModel {
//   ProductDisplayApiModel({
//     required this.id,
//     required this.name,
//     required this.status,
//     required this.weight,
//     required this.img,
//     required this.storage,
//     this.sectionsIds = const [],
//     required this.weightDescriotion,
//     // required this.quantity
//   });
//
//   late final int id;
//   late final Name name;
//   late final bool status;
//   late final Weight weight;
//   late final String img;
//   late final Storage storage;
//   late List<int> sectionsIds;
//   late final WeightDescriotion weightDescriotion;
//   late final ProductDisplayApiModel? friendProduct;
//   late final bool hasCondition;
//   late final int? maximumSell;
//
//   // late int quantity;
//
//   ProductDisplayApiModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     var thirdMap = <String, dynamic>{};
//
//     for (var element in List.from(json['name'])) {
//       thirdMap.addAll(element);
//     }
//     name = thirdMap.isEmpty ? Name(ar: '', he: '') : Name.fromJson(thirdMap);
//     status = json['status'];
//     sectionsIds = json['sections_ids'] != null
//         ? List<int>.from(json['sections_ids'])
//         : [];
//     weight = Weight.fromJson(json['weight']);
//     img = json['img'] ?? '';
//
//     weightDescriotion = WeightDescriotion.fromJson(json['weight_descriotion']);
//     friendProduct = json['friend_product'] != null
//         ? ProductDisplayApiModel.fromJson(json['friend_product'])
//         : null;
//     hasCondition = json['has_condition'] ?? false;
//     maximumSell = json['maximum_sell'];
//     storage = Storage.fromJson(json['storage'], maximumSell);
//     // quantity = json['quantity'] ?? 5;
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['status'] = status;
//     data['weight'] = weight.toJson();
//     data['img'] = img;
//     data['storage'] = storage.toJson();
//     return data;
//   }
// }

/*
class RecipeProductDisplayApiModel {
  RecipeProductDisplayApiModel({
    required this.quantityNeeded,
    required this.product,
  });

  late final int quantityNeeded;
  late final ProductDisplayApiModel product;

  // late int quantity;

  RecipeProductDisplayApiModel.fromJson(Map<String, dynamic> json) {
    quantityNeeded = json['quantity_needed'];
    product = ProductDisplayApiModel.fromJson(json['product']);
  }
}
*/

class ProductOrderApiModel {
  ProductOrderApiModel(
      {required this.id,
      required this.name,
      required this.barcode,
      required this.brand,
      required this.status,
      required this.group,
      required this.attributes,
      required this.contents,
      required this.weight,
      required this.weightDescriotion,
      required this.height,
      required this.width,
      required this.length,
      required this.tags,
      required this.description,
      required this.imgs,
      required this.quantity});

  late final int id;
  late final Name name;
  late final String barcode;
  late final Brand? brand;
  late final bool status;
  late final List<dynamic> group;
  late final List<Attributes> attributes;
  late final List<Content> contents;
  late final Weight weight;
  late final WeightDescriotion weightDescriotion;
  late final num height;
  late final num width;
  late final num length;
  late final num currentOrderPrice;
  late final num originalProductPrice;
  late final bool hasCampaign;
  late final String? campaignType;
  late final num? campaignPercentage;
  late final List<Tags> tags;
  late final List<Description> description;
  late final List<ImageApiModel> imgs;

  late int quantity;
  late final num price;
  late final num? sale;
  late final num? campaignCount;
  late final num? campainPercentage;
  late final String? campainType;

  ProductOrderApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    var thirdMap = <String, dynamic>{};
    for (var element in List.from(json['name'])) {
      thirdMap.addAll(element);
    }
    name = thirdMap.isEmpty ? Name(ar: '', he: '') : Name.fromJson(thirdMap);
    barcode = json['barcode'];
    brand = jsonEncode(json['brand']) == jsonEncode([])
        ? null
        : Brand.fromJson(json['brand']);
    status = json['status'];
    group = [];
    attributes = List.from(json['attributes'])
        .map((e) => Attributes.fromJson(e))
        .toList();
    contents =
        List.from(json['contents']).map((e) => Content.fromJson(e)).toList();
    weight = Weight.fromJson(json['weight']);
    weightDescriotion = WeightDescriotion.fromJson(json['weight_descriotion']);
    height = json['height'];
    width = json['width'];
    length = json['length'];
    currentOrderPrice = json['order_price'];
    originalProductPrice = json['product_price'];
    hasCampaign = json['has_campaign'] == 1;
    campaignType = json['campaign_type'];
    campaignPercentage = json['campaign_percentage'];
    campaignCount = json['count'] ?? 0;
    tags = List.from(json['tags']).map((e) => Tags.fromJson(e)).toList();
    description = List.from(json['description']).isEmpty
        ? []
        : [Description.fromJson(List.from(json['description']).first)];
    imgs =
        List.from(json['imgs']).map((e) => ImageApiModel.fromJson(e)).toList();
    quantity = json['quantity'] ?? 0;
    price = json['price'] ?? 0;
    sale = json['sale'] == 0 ? null : json['sale'];
    campainType = json['campain_type'] == 0 ? null : json['campain_type'];
    campainPercentage = json['campain_percentage'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    // _data['price'] = price;
    // _data['sale'] = sale;
    data['name'] = name;
    data['barcode'] = barcode;
    // _data['sections'] = sections.map((e) => e.toJson()).toList();
    data['brand'] = brand!.toJson();
    data['status'] = status;
    data['group'] = group;
    data['attributes'] = attributes.map((e) => e.toJson()).toList();
    data['contents'] = contents;
    data['weight'] = weight.toJson();
    data['weight_descriotion'] = weightDescriotion.toJson();
    data['height'] = height;
    data['width'] = width;
    data['length'] = length;
    data['tags'] = tags.map((e) => e.toJson()).toList();
    data['description'] = description.map((e) => e.toJson()).toList();
    data['imgs'] = imgs.map((e) => e.toJson()).toList();
    // _data['storages'] = storages.map((e) => e.toJson()).toList();
    return data;
  }
}

class ProductQuantityErrorModel {
  ProductQuantityErrorModel({
    required this.productId,
    required this.cartQuantity,
    required this.currentProductQuantity,
  });

  late final int productId;
  late final int cartQuantity;
  late final int currentProductQuantity;

  ProductQuantityErrorModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    cartQuantity = json['cart_quantity'];
    //todo:: change maximon quantity to
    currentProductQuantity = json['current_product_quantity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['cart_quantity'] = cartQuantity;
    data['current_product_quantity'] = currentProductQuantity;
    return data;
  }
}
