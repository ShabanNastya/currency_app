import 'package:currency_app/services/api_client.dart';
import 'package:currency_app/widgets/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();
  List<String> currencies;
  String from;
  String to;

  double rate;
  String result = "";

  Future<List<String>> getCurrencyList() async {
    return await client.getCurrencies();
  }

  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Currency App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold)),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onSubmitted: (value) async {
                          rate = await client.getRate(from, to);
                          setState(() {
                            result =
                                (rate * double.parse(value)).toStringAsFixed(3);
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Input a value to convert',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customDropDown(currencies, from, (val) {
                              setState(() {
                                from = val;
                              });
                            }),
                            FloatingActionButton(
                              onPressed: () {
                                String temp = from;
                                setState(() {
                                  from = to;
                                  to = temp;
                                });
                              },
                              child: const Icon(Icons.swap_horiz),
                              elevation: 0.0,
                              backgroundColor: Colors.pinkAccent,
                            ),
                            customDropDown(currencies, to, (val) {
                              setState(() {
                                to = val;
                              });
                            })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Result",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              result,
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
