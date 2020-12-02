import 'package:flutter/material.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
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

  @override
  void initState() {
    stockBloc = StockBlock(widget.apiKey, widget.userID);
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
          stream: stockBloc.getStocks,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              if (snapshot.data.length >= 0) {
                return _buildListSimple(context, snapshot.data);
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

  /* Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskId.toString()),
      title: EventsList(
        title: item.title,
      ),
    );
  } */

  Widget _buildListSimple(BuildContext context, List<StockUser> stocksList) {
    return Scrollbar(
      child: RefreshIndicator(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 50),
            itemCount: stocksList.length,
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
                                      Text(stocksList[index].id.toString()),
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
