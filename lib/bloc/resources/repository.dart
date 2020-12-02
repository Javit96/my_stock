import 'dart:async';
import 'package:my_stock/models/classes/product.dart';

import 'api.dart';
import 'package:my_stock/models/classes/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname,
          String email, String password, String phone) =>
      apiProvider.registerUser(
          username, firstname, lastname, password, email, phone);

  Future singinUser(String username, String password, String apiKey) =>
      apiProvider.signinUser(username, password, apiKey);

  Future getUserInfo(String apiKey, String username) =>
      apiProvider.getUserInfo(apiKey, username);

  Future getUserStock(String apiKey, int userID) =>
      apiProvider.getUserStock(apiKey, userID);

  Future<Null> deleteStock(String apiKey, int stockId) =>
      apiProvider.deleteStock(apiKey, stockId);

  Future<Null> deleteProducts(int productId) =>
      apiProvider.deleteProduct(productId);

  Future<Null> addUserStock(String apiKey, String stock, DateTime buyDate,
      String userID, String productID) async {
    apiProvider.addUserStock(apiKey, int.parse(stock), buyDate,
        int.parse(userID), int.parse(productID));
  }

  Future<Products> addProduct(
      String product, String barcode, String price) async {
    apiProvider.addProduct(product, product, int.parse(price));
  }

  Future getProducts() => apiProvider.getProducts();
}
