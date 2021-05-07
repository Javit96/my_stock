import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:my_stock/models/classes/stockuser.dart';
import 'package:my_stock/models/classes/user.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();

  Observable<User> get getUser => _userGetter.stream;

  registerUser(String username, String firstname, String lastname, String email,
      String password, String phone) async {
    User user = await _repository.registerUser(
        username, firstname, lastname, email, password, phone);
    _userGetter.sink.add(user);
  }

  singinUser(String username, String password, String apiKey) async {
    User user = await _repository.singinUser(username, password, apiKey);
    _userGetter.sink.add(user);
  }

  dispose() {
    _userGetter.close();
  }
}

class StockBlock {
  final _repository = Repository();
  final _stockSubject = BehaviorSubject<List<StockUser>>();
  String apiKey;
  String userID;

  var _stocks = <StockUser>[];

  StockBlock(String apiKey, String userID) {
    this.apiKey = apiKey;
    this.userID = userID;
    _updateStocks(apiKey, userID).then((_) {
      _stockSubject.add(_stocks);
    });
  }

  Stream<List<StockUser>> get getStocks => _stockSubject.stream;

  Future<Null> _updateStocks(String apiKey, String userID) async {
    _stocks = await _repository.getUserStock(apiKey, userID);
  }

  deleteStock(String apiKey, int stockId) async {
    _stocks = await _repository.deleteStock(apiKey, stockId);
  }
}

class ProductsBlock {
  final _repository = Repository();
  final _productsSubject = BehaviorSubject<List<Products>>();

  var _products = <Products>[];

  ProductsBlock() {
    _updateProducts().then((_) {
      _productsSubject.add(_products);
    });
  }

  Stream<List<Products>> get getProducts => _productsSubject.stream;

  Future<Null> _updateProducts() async {
    _products = await _repository.getProducts();
  }

  deleteProduct(int productId) async {
    _products = await _repository.deleteProducts(productId);
  }
}

final userBloc = UserBloc();
