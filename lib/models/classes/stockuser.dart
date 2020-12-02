class StockUser {
  List<StockUser> stockList;
  DateTime buyDate;
  int productID;
  int userID;
  int stock;
  int id;

  StockUser(this.id, this.stock, this.buyDate, this.userID, this.productID);

  factory StockUser.fromJson(Map<String, dynamic> parsedJson) {
    return StockUser(parsedJson['id'], parsedJson['stock'],
        parsedJson['BuyDate'], parsedJson['userId'], parsedJson['productID']);
  }
}
