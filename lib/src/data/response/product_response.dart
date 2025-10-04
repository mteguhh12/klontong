import 'package:klontong/src/data/response/category_response.dart';

class ProductResponse {
  String? id;
  String? categoryId;
  String? sku;
  String? name;
  String? description;
  int? weight;
  String? image;
  int? price;
  CategoryResponse? category;

  ProductResponse(
      {this.id,
      this.categoryId,
      this.sku,
      this.name,
      this.description,
      this.weight,
      this.image,
      this.price,
      this.category});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    weight = json['weight'];
    image = json['image'];
    price = json['price'];
    category = json['category'] != null
        ? new CategoryResponse.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['description'] = this.description;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['price'] = this.price;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}
