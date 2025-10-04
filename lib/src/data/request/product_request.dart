class ProductRequest {
  int? categoryId;
  String? sku;
  String? name;
  String? description;
  int? weight;
  String? image;
  int? price;

  ProductRequest(
      {this.categoryId,
      this.sku,
      this.name,
      this.description,
      this.weight,
      this.image,
      this.price});

  ProductRequest.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    weight = json['weight'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['description'] = this.description;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}
