import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import 'package:my_stock/models/classes/product.dart';
import 'package:my_stock/models/classes/user.dart';
import 'package:my_stock/bloc/resources/repository.dart';
import 'package:my_stock/models/widgets/Products_list.dart';
import 'package:my_stock/models/widgets/Stocks_list.dart';
import 'UI/LoginPage/Login_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/widgets/drawer.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping List',
        theme: ThemeData(
          primarySwatch: Colors.lightBlueAccent[50],
          dialogBackgroundColor: Colors.white,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  StockBlock stockBlock;
  UserBloc userBloc;
  String apiKey = "";
  int userID;
  String username = "";
  User user;
  Products products;

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = new MyHttpOverrides();
    return FutureBuilder(
      future: signinUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          apiKey = snapshot.data;
          //stockBlock = StockBlock(apiKey, userID);

        } else {
          print("No Data");
        }
        return apiKey.length > 0
            ? getHomePage()
            : LoginPage(
                login: login,
                newUser: false,
              );
      },
    );
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  Future signinUser() async {
    userID = await getUserID();
    apiKey = await getApiKey();
    username = await getUsername();
    if (apiKey != null) {
      if (apiKey.length > 0) {
        userBloc.singinUser(username, "", apiKey);
      } else {
        print("No apiKey");
      }
    } else {
      apiKey = "";
    }
    return apiKey;
  }

  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt("UserID"); //key

    return userID;
  }

  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("Username"); //key

    return username;
  }

  Future getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apitoken = prefs.getString("API_Token"); //key

    return apitoken;
  }

  Widget getHomePage() {
    return MaterialApp(
      home: SafeArea(
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                  child: StockList(
                apiKey: apiKey,
                userID: userID,
              )),
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
                          builder: (context) => ProductsList(
                                apiKey: apiKey,
                                userID: userID,
                              )),
                    );
                  },
                ),
              )
            ],
          ),
          drawer: DrawerMenu(
            apiKey: apiKey,
            logout: logout,
          ),
        ),
      ),
    );
  }

  /*_userTexts() async {
    User user = await _repository.getUserInfo(this.apiKey);
    var username = user.username;
    return username;
  }*/

  /*void _getBarcode() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    final image = FirebaseVisionImage.fromFile(imageFile);
    final barCodeDetector = FirebaseVision.instance.barcodeDetector(
        BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.all));
    await barCodeDetector.detectInImage(image);
  }*/

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("API_Token", ""); //key and value
    setState(() {
      build(context);
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
