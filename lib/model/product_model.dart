class ProductModel {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
  factory ProductModel.fromJson(json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: RatingModel.fromJson(json['rating']),
    );
  }
  Map<String,dynamic> toMap() {
    return {
      'id':this.id,
    'title':this.title,
    'price':this.price,
    'description':this.description,
    'category':this.category,
    'rating':this.rating.toMap(),
      'image':this.image,



  };

  }
}



class RatingModel {
  double rate;
  int count ;
  RatingModel({required this.rate, required this.count});
  factory RatingModel.fromJson(json) {
    return RatingModel(rate:(json['rate'] as num).toDouble(), count:json['count'] as int);
  }
  Map<String,dynamic> toMap(){
    return {
      'rate':this.rate,
          'count':this.count
    };

  }
}

