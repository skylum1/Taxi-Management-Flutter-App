import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taxi/utils/database_helpertaxi.dart';
import 'package:taxi/models/taxi.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

const TextStyle titleStyle = TextStyle(fontSize: 12, color: textcolor);
const Color bgcolor = Color(0xFF842e4b);
const Color bgcolor2 = Color(0xFF5c2041);
const Color card3color = Color(0xFF391428);
const Color fgcolor = Colors.black38;
const Color textcolor = Colors.white;

class TaxiClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Add_taxi(),
    );
  }
}

class Add_taxi extends StatefulWidget {
  @override
  _Add_taxiState createState() => _Add_taxiState();
}

class _Add_taxiState extends State<Add_taxi> {
  int d_id, choice = 0;
  Taxi taxi;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Taxi> taxiList, searchList;
  int count = 0, count2 = 0;
  TextEditingController licenseController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController didController = TextEditingController();
  LinkedScrollControllerGroup _controllers;
  ScrollController tit, bit;
  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    tit = _controllers.addAndGet();
    bit = _controllers.addAndGet();
  }

  @override
  void dispose() {
    tit.dispose();
    bit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (taxiList == null) {
      taxiList = List<Taxi>();
      updateExpenseView();
    }
    if (searchList == null) {
      searchList = List<Taxi>();
    }
    if (taxi == null) {
      taxi = Taxi(0, '', 5, '', 0);
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgcolor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: bgcolor2,
          title: Center(child: Text('ADD TAXI')),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Taxi id : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: idController,
                        onChanged: (String str) {
                          d_id = int.parse(idController.text);
                        },
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Driver id : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: didController,
                        onChanged: (String str) {
                          taxi.driverId = int.parse(didController.text);
                        },
                      )),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'License : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      child: TextField(
                        controller: licenseController,
                        onChanged: (String str) {
                          taxi.license = licenseController.text;
                        },
                      )),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Model : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      child: TextField(
                    controller: phoneController,
                    onChanged: (String str) {
                      taxi.model = phoneController.text;
                    },
                  )),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Available : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          taxi.available = (taxi.available == 1) ? 0 : 1;
                        });
                      },
                      child: Availabilitybutton(taxi.available)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Condition : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.8,
                    child: SleekCircularSlider(
                        min: 0,
                        max: 10,
                        initialValue: 5,
                        appearance: CircularSliderAppearance(
                            size: 100,
                            startAngle: 180,
                            angleRange: 180,
                            customColors: CustomSliderColors(
                                trackColor: fgcolor,
                                progressBarColors: [
                                  Colors.green,
                                  Colors.yellowAccent,
                                  Colors.redAccent
                                ],
                                dynamicGradient: false)),
                        innerWidget: (value) {
                          return Center(
                            child: Text(
                              '${value.round()}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
                            ),
                          );
                        },
                        onChange: (double value) {
                          taxi.carCondition = value.round();
                        }),
                  ),
                )
              ],
            ),
            Row(
              children: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        choice = 0;
                        _save();
                      });
                      updateExpenseView();
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        color: fgcolor,
                        child: Text(
                          'Insert',
                          style: TextStyle(color: Colors.white),
                        ))),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        choice = 1;
                        _search(id: d_id);
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        color: fgcolor,
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
            Card(
              color: card3color,
              elevation: 2.0,
              child: SingleChildScrollView(
                controller: tit,
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Container(
                    padding: EdgeInsets.all(1),
                    child: GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    padding: EdgeInsets.all(2),
                    child: Text(
                      'Id',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    width: 40,
                    margin: EdgeInsets.all(4),
                    child: Text(
                      'Driver Id',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 80,
                    child: Text(
                      'License',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      'Model',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 30,
                    child: Text(
                      'Condition',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 30,
                    child: Text(
                      'Available',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(color: bgcolor2, child: chosselist(choice)),
            ),
          ],
        ),
      ),
    );
  }

  Widget chosselist(int ch) {
    if (ch == 0)
      return getExpenseListView();
    else
      return getDriverSearchView();
  }

  void _save() async {
    // Case 2: Insert Operation
    await databaseHelper.insertTaxi(taxi);
  }

  void _search({int id}) async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Taxi>> noteListFuture =
          databaseHelper.searchTaxi(taxi, id: id);
      noteListFuture.then((noteList) {
        setState(() {
          this.searchList = noteList;
          this.count2 = noteList.length;
        });
      });
    });
  }

  ListView getExpenseListView() {
    TextStyle titleStyle = TextStyle(color: Colors.white);

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: card3color,
          elevation: 2.0,
          child: SingleChildScrollView(
            controller: bit,
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
              onDoubleTap: () {
                licenseController.text = taxiList[position].license;
                taxi.license = licenseController.text;
                phoneController.text = taxiList[position].model;
                taxi.model = phoneController.text;
                taxi.available = taxiList[position].available;
              },
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(1),
                  child: GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _update(context, taxiList[position]);
                      updateExpenseView();
                    },
                  ),
                ),
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    this.taxiList[position].id.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.taxiList[position].driverId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  child: Text(
                    this.taxiList[position].license,
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.taxiList[position].model,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 30,
                  child: Text(
                    this.taxiList[position].carCondition.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 30,
                  child: Text(
                    (this.taxiList[position].available == 1) ? 'Yes' : 'No',
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _delete(context, taxiList[position]);
                    },
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  ListView getDriverSearchView() {
    TextStyle titleStyle = TextStyle(color: Colors.white);

    return ListView.builder(
      itemCount: count2,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: card3color,
          elevation: 2.0,
          child: SingleChildScrollView(
            controller: bit,
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
              onDoubleTap: () {
                licenseController.text = searchList[position].license;
                taxi.license = licenseController.text;
                phoneController.text = searchList[position].model;
                taxi.model = phoneController.text;
                taxi.available = searchList[position].available;
              },
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(1),
                  child: GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _update(context, searchList[position]);
                      updateExpenseView();
                    },
                  ),
                ),
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    this.searchList[position].id.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.searchList[position].driverId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  child: Text(
                    this.searchList[position].license,
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.searchList[position].model,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 30,
                  child: Text(
                    this.searchList[position].carCondition.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 30,
                  child: Text(
                    (this.searchList[position].available == 1) ? 'Yes' : 'No',
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _delete(context, searchList[position]);
                    },
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Taxi note) async {
    int result = await databaseHelper.deleteTaxi(note.id);
    if (result != 0) _showSnackBar(context, 'Note Deleted Successfully');
    updateExpenseView();
    _search();
  }

  void updateExpenseView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Taxi>> noteListFuture = databaseHelper.getTaxiList();
      noteListFuture.then((noteList) {
        setState(() {
          this.taxiList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _update(BuildContext context, Taxi driver) async {
    driver.driverId = this.taxi.driverId;
    driver.license = this.taxi.license;
    driver.model = this.taxi.model;
    driver.available = this.taxi.available;
    driver.carCondition = this.taxi.carCondition;
    await databaseHelper.updateTaxi(driver);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class Availabilitybutton extends StatelessWidget {
  final int value;
  Availabilitybutton(this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: (value == 1) ? Color(0xAC41EC37) : Colors.redAccent,
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          (value == 1) ? 'Yes' : 'No',
          style: TextStyle(color: textcolor),
        ),
      ),
    );
  }
}
