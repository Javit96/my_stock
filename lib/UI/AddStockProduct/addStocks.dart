import 'package:flutter/services.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class AddStocksPage extends StatefulWidget {
  final String apiKey;
  final Products products;
  final String userID;

  const AddStocksPage({Key key, this.apiKey, this.userID, this.products})
      : super(key: key);

  @override
  _AddStocksPageState createState() => _AddStocksPageState();
}

class _AddStocksPageState extends State<AddStocksPage> {
  TextEditingController stock = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  Repository _repository = Repository();
  int userID;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt("UserID"); //key
    print(userID);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Add New Stock"),
            Container(child: Text(widget.products.title)),
            Container(
              child: TextField(
                controller: stock,
                decoration: InputDecoration(
                  hintText: "Quantity",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Container(
                child: Column(
              children: <Widget>[
                Text("${selectedDate.toLocal()}".split(' ')[0]),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Add",
                    ),
                    onPressed: () {
                      if (widget.products.id != null && widget.userID != null) {
                        _repository
                            .addUserStock(
                                widget.apiKey,
                                stock.text,
                                selectedDate,
                                widget.userID.toString(),
                                widget.products.id.toString())
                            .then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        });
                      } else {
                        print("error en el producto id");
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
