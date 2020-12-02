import 'package:flutter/services.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:my_stock/models/classes/product.dart';

import '../../main.dart';

class AddProductsPage extends StatefulWidget {
  final String apiKey;

  const AddProductsPage({
    Key key,
    this.apiKey,
  }) : super(key: key);

  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  TextEditingController productName = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController barcode = new TextEditingController();

  Products _products;
  Repository _repository = Repository();

  bool completed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Add The Product Details"),
            Container(
              child: TextField(
                controller: productName,
                decoration: InputDecoration(
                  hintText: "Name of Product",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: price,
                decoration: InputDecoration(
                  hintText: "Product´price",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Container(
              child: TextField(
                controller: barcode,
                decoration: InputDecoration(
                  hintText: "Product´barcode",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
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
                      if (productName.text != null &&
                          price != null &&
                          barcode != null) {
                        _repository
                            .addProduct(
                                productName.text, barcode.text, price.text)
                            .then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        });
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
