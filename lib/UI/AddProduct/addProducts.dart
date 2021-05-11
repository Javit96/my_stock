import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:my_stock/bloc/resources/userImagePicker.dart';
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
  File _userImageFile;
  List<Barcode> _barCode = [];

  var result = "";
  Products _products;
  Repository _repository = Repository();

  bool completed;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  //barCode_Scanner
  barCodeScanner() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_userImageFile);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    _barCode = await barcodeDetector.detectInImage(myImage);
    result = "";
    for (Barcode barcode in _barCode) {
      setState(() {
        result = barcode.displayValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Agregue el producto que no encuentre en la lista."),
      ),
      body: Form(
        //key: _formKey,
        //autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex.value],
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              sizedBoxSpace,
              Text("Add The Product Details"),
              TextFormField(
                controller: productName,
                decoration: InputDecoration(
                  hintText: "Name of Product",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              sizedBoxSpace,
              TextFormField(
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
              sizedBoxSpace,
              TextFormField(
                controller: barcode,
                decoration: InputDecoration(
                  hintText: "Product´barcode",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              sizedBoxSpace,
              Column(
                children: [
                  UserImagePicker(_pickedImage),
                  Padding(
                      padding: const EdgeInsets.all(16.0), child: Text(result)),
                ],
              ),
              sizedBoxSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(
                      "Cancel",
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
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
            ]),
          ),
        ),
      ),
    );
  }
}
