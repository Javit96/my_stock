import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:my_stock/bloc/resources/repository.dart';
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
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Agregue el stock que acaba de adquirir."),
      ),
      body: Form(
        //key: _formKey,
        //autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex.value],
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                sizedBoxSpace,
                Text(widget.products.title),
                TextFormField(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text("${selectedDate.toLocal()}".split(' ')[0]),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
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
                          if (widget.products.id != null &&
                              widget.userID != null) {
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
        ),
      ),
    );
  }
}
