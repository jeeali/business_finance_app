import 'dart:math';

import 'package:business_finance_app/pages/discounting_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();
  double _min = 0;

  var tList = [
    'Future Value (fv)',
    'Rate (percentage)',
    'Number of Years (n)'
  ];

  TextEditingController _fv = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _n = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mScaffoldState,
      appBar: AppBar(
        title: Text('Discounting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _fv,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: tList[0],
                  hintStyle: TextStyle(
                    fontSize: 20
                  ),
                suffixIcon: Icon(Icons.attach_money)
              ),
            ),
            TextField(
              controller: _rate,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: tList[1],
                  hintStyle: TextStyle(
                      fontSize: 20
                  ),
                  suffixIcon: Icon(Icons.local_parking)
              ),
            ),
            TextField(
              controller: _n,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: tList[2],
                hintStyle: TextStyle(
                  fontSize: 20
                ),
                  suffixIcon: Icon(Icons.format_list_numbered_rtl)
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Calculate'),
        icon: Icon(Icons.arrow_forward),
        onPressed: (){
          if(_fv.text.isNotEmpty && _rate.text.isNotEmpty && _n.text.isNotEmpty){
            calculateDiscounting().then((aList){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DiscountingPage(n: int.parse(_n.text), aList: aList, max: double.parse(_fv.text.toString()), min: _min)));
            });
          }
          else
            showSnackBar('Enter All Fields');
        },
      ),
    );
  }

  Future<List<FlSpot>> calculateDiscounting() async {
    List<FlSpot> answersList = [];
    int currentYear = DateTime.now().year;
    answersList.add(FlSpot(0, double.parse(_fv.text)));
    for(int i = 1; i <= int.parse(_n.text); i++){
      double formula = double.parse(_fv.text)*(1/pow((1+(double.parse(_rate.text)/100)), i));
      debugPrint("F$i: ${formula.toString()}");
      debugPrint("$i , $formula");
      if(i==int.parse(_n.text))
        setState(() => _min = double.parse(formula.toStringAsFixed(4)));
      answersList.add(FlSpot(double.parse(i.toString()), double.parse(formula.toStringAsFixed(2))));
    }
    return answersList;
  }

  void showSnackBar(String text) {
    final snackBar = new SnackBar(
      content: new Text('$text'),
      duration: const Duration(seconds: 2),
    );
    mScaffoldState.currentState.showSnackBar(snackBar);
  }

}