import 'package:flutter/material.dart';
import 'package:my_stock/UI/AddProduct/addProducts.dart';
import 'package:my_stock/UI/AddStockProduct/addStocks.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:my_stock/models/widgets/drawer.dart';

class ProductsList extends StatefulWidget {
  final String apiKey;
  final int userID;
  ProductsList({this.apiKey, this.userID});
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Products> productList = [];
  Repository _repository = Repository();

  ProductsBlock productsBlock;

  @override
  void initState() {
    productsBlock = ProductsBlock();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: productsBlock.getProducts,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              if (snapshot.data.length > 0) {
                return _buildListTile(context, snapshot.data);
              } else if (snapshot.data.length == 0) {
                return Center(child: Text('No Data'));
              }
            } else if (snapshot.hasError) {
              return Container(
                child: Text("Error talk with the support"),
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Widget _buildListTile(BuildContext context, List<Products> productList) {
    return MaterialApp(
      home: SafeArea(
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: _buildListSimple(context, productList),
              ),
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.8,
                    left: MediaQuery.of(context).size.width * 0.7),
                child: FloatingActionButton(
                  tooltip: 'Pick an image',
                  child: Icon(
                    Icons.add,
                    size: 35,
                  ),
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductsPage(
                                apiKey: widget.apiKey,
                              )),
                    );
                  },
                ),
              )
            ],
          ),
          drawer: DrawerMenu(
            apiKey: widget.apiKey,
          ),
        ),
      ),
    );
  }

  Widget _buildListSimple(BuildContext context, List<Products> productList) {
    return Scrollbar(
      child: RefreshIndicator(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 50),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 100,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.adjust,
                                              color: Colors.amber,
                                              size: 50,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                                Text(productList[index].title)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          deleteTask(productList[index].title,
                                              productList[index].id);
                                        },
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.amber,
                                              size: 50,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          _showMyDialog(productList[index]);
                                        },
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.amber,
                                              size: 50,
                                            )),
                                      ),
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
      productsBlock = ProductsBlock();
    });
  }

  Future<void> _showMyDialog(Products products) async {
    print(products.title);
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('This is the product you will add.'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(products.title),
                  Text('Would you like to add this product?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add Product to stock'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStocksPage(
                        apiKey: widget.apiKey,
                        userID: widget.userID,
                        products: products,
                      ),
                    ),
                  );
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> deleteTask(title, productId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to delete this task?"),
          content: Text(title),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new FlatButton(
                child: new Text("Accept"),
                onPressed: () {
                  productsBlock.deleteProduct(productId);
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
