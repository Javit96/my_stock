class Products {
  List<Products> products;
  String title;
  int credits;
  String barCode;
  int id;

  Products(this.id, this.title, this.credits, this.barCode);

  factory Products.fromJson(Map<String, dynamic> parsedJson) {
    return Products(
      parsedJson['id'],
      parsedJson['title'],
      parsedJson['credits'],
      parsedJson['barCode'],
    );
  }
}
