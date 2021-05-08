import 'package:flutter/material.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:my_stock/models/classes/stockuser.dart';
import 'package:intl/intl.dart';

class StockList extends StatefulWidget {
  final String apiKey;
  final String userID;
  StockList({this.apiKey, this.userID});
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  List<StockUser> stocksList = [];
  List<Products> productsList = [];
  StockBlock stockBloc;
  StockUser stocks;
  Products products;
  ProductsBlock productsBlock;
  Repository _repository = Repository();

  @override
  void initState() {
    stockBloc = StockBlock(widget.apiKey, widget.userID);
    productsBlock = ProductsBlock();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: stockBloc.getStocks,
      initialData: stocksList,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1 != null) {
          if (snapshot1.data.length >= 0) {
            return StreamBuilder(
                stream: productsBlock.getProducts,
                initialData: productsList,
                builder: (context, snapshot2) {
                  return _buildListTile(
                      context, snapshot1.data, snapshot2.data);
                });
          }
        } else if (snapshot1.hasError) {
          return Container(
            child: Text("Error talk with the support"),
          );
        }
        return CircularProgressIndicator();
      },
    ));
  }

  _buildListTile(BuildContext context, List<StockUser> stocksList,
      List<Products> productsList) {
    var mapedProdu = Map();
    var mapedProdu2 = Map();
    for (stocks in stocksList) {
      for (products in productsList) {
        if (stocks.productID == products.id) {
          mapedProdu[stocks.id] = products.title;
          mapedProdu2[stocks] = products;
          print(stocks.buyDate);
        }
      }
    }
    print(mapedProdu.entries);
    return _buildListSimple(
        context, mapedProdu, mapedProdu2, stocksList, productsList);
  }

  Widget _buildListSimple(BuildContext context, Map mapedProdu, Map mapedProdu2,
      List<StockUser> stocksList, List<Products> productsList) {
    return Scrollbar(
      child: RefreshIndicator(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 50),
            itemCount: mapedProdu.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 50,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.info),
                                            color: Colors.amber,
                                            iconSize: 35,
                                            onPressed: () {
                                              infoStock(
                                                  mapedProdu2.entries
                                                      .elementAt(index)
                                                      .key,
                                                  mapedProdu2.entries
                                                      .elementAt(index)
                                                      .value);
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  250,
                                              child: Text(
                                                mapedProdu.entries
                                                    .elementAt(index)
                                                    .value,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 20.0),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.amber,
                                            iconSize: 35,
                                            onPressed: () {
                                              deleteStock(
                                                  widget.apiKey,
                                                  mapedProdu2.entries
                                                      .elementAt(index)
                                                      .key,
                                                  mapedProdu2.entries
                                                      .elementAt(index)
                                                      .value);
                                              stocksList.removeAt(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ]),
                          ),
                        ],
                      )));
            }),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<void> infoStock(StockUser stockList, Products product) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(product.title),
          content:
              Text("Quantity: " + stockList.stock.toString() + "\n" + "The "),
        );
      },
    );
  }

  Future<void> deleteStock(
      apiKey, StockUser stockList, Products product) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to delete this task?"),
          content: Text(product.title),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new FlatButton(
                child: new Text("Accept"),
                onPressed: () {
                  stockBloc.deleteStock(apiKey, stockList.id);
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      stockBloc = StockBlock(widget.apiKey, widget.userID);
    });
  }
}
