import 'package:flutter/material.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:my_stock/models/classes/stockuser.dart';

class StockList extends StatefulWidget {
  final String apiKey;
  final int userID;
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
    for (stocks in stocksList) {
      for (products in productsList) {
        if (stocks.productID == products.id)
          mapedProdu[stocks.id] = products.title;
      }
    }
    print(mapedProdu.entries);
    return _buildListSimple(context, mapedProdu, stocksList, productsList);
  }

  Widget _buildListSimple(BuildContext context, Map mapedProdu,
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
                  padding: EdgeInsets.all(7),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {},
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.info,
                                              color: Colors.amber,
                                              size: 50,
                                            )),
                                      ),
                                      Text(mapedProdu.entries
                                          .elementAt(index)
                                          .value),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          stockBloc.deleteStock(widget.apiKey,
                                              stocksList[index].id);
                                          stocksList.removeAt(index);
                                        },
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.amber,
                                              size: 20,
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  ]),
                ),
              );
            }),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      stockBloc = StockBlock(widget.apiKey, widget.userID);
    });
  }
}
