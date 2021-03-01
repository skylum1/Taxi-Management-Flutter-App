import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taxi/utils/databseHelper_driv.dart';
import 'package:taxi/models/driver.dart';

const TextStyle titleStyle = TextStyle(fontSize: 12, color: Colors.white);
const Color bgcolor = Color(0xFF00994d);
const Color bgcolor2 = Color(0xFF006633);
const Color card3color = Color(0xFF004d26);
const Color fgcolor = Colors.black38;
const Color textcolor = Colors.white;

class Add_driver extends StatefulWidget {
  @override
  _Add_driverState createState() => _Add_driverState();
}

class _Add_driverState extends State<Add_driver> {
  int d_id, choice = 0;
  Driver driver;
  DatabaseHelperdriv databaseHelper = DatabaseHelperdriv();
  List<Driver> driverList, searchList;
  int count = 0, count2 = 0;
  LinkedScrollControllerGroup _controllers;
  ScrollController tit, bit;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idController = TextEditingController();

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
    if (driverList == null) {
      driverList = List<Driver>();
      updateDriverView();
    }
    if (searchList == null) {
      searchList = List<Driver>();
    }
    if (driver == null) {
      driver = Driver('', '', '');
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgcolor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: bgcolor2,
          title: Center(child: Text('ADD DRIVER')),
        ),
        body: Column(
          children: [
            Row(
              children: [
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
                        controller: idController,
                        onChanged: (String str) {
                          d_id = int.parse(idController.text);
                        },
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Name : ',
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
                        controller: nameController,
                        onChanged: (String str) {
                          driver.name = nameController.text;
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
                    'Phone : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    onChanged: (String str) {
                      driver.phone = phoneController.text;
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
                    'Address : ',
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
                        keyboardType: TextInputType.streetAddress,
                        controller: addressController,
                        onChanged: (String str) {
                          driver.address = addressController.text;
                        },
                      )),
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
                      updateDriverView();
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
                    margin: EdgeInsets.all(10),
                    width: 80,
                    child: Text(
                      'Name',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      'Phone Number',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 150,
                    child: Text(
                      'Address',
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
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                color: bgcolor2,
                child: chosselist(this.choice),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chosselist(int ch) {
    if (ch == 0)
      return getDriverListView();
    else
      return getDriverSearchView();
  }

  void _save() async {
    // Case 2: Insert Operation
    await databaseHelper.insertDriver(driver);
  }

  void _search({int id}) async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Driver>> noteListFuture =
          databaseHelper.searchDriver(driver, id: id);
      noteListFuture.then((noteList) {
        setState(() {
          this.searchList = noteList;
          this.count2 = noteList.length;
        });
      });
    });
  }

  ListView getDriverListView() {
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
                nameController.text = driverList[position].name;
                driver.name = nameController.text;
                phoneController.text = driverList[position].phone;
                driver.phone = phoneController.text;
                addressController.text = driverList[position].address;
                driver.address = addressController.text;
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
                      _update(context, driverList[position]);
                      updateDriverView();
                    },
                  ),
                ),
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    this.driverList[position].id.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  child: Text(
                    this.driverList[position].name,
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.driverList[position].phone,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.driverList[position].address,
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
                      _delete(context, driverList[position]);
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
                nameController.text = searchList[position].name;
                driver.name = nameController.text;
                phoneController.text = searchList[position].phone;
                driver.phone = phoneController.text;
                addressController.text = searchList[position].address;
                driver.address = addressController.text;
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
                      updateDriverView();
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
                  margin: EdgeInsets.all(10),
                  width: 80,
                  child: Text(
                    this.searchList[position].name,
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.searchList[position].phone,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.searchList[position].address,
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

  void _delete(BuildContext context, Driver note) async {
    int result = await databaseHelper.deleteDriver(note.id);
    if (result != 0) _showSnackBar(context, 'Note Deleted Successfully');
    updateDriverView();
    _search();
  }

  void updateDriverView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Driver>> noteListFuture = databaseHelper.getDriverList();
      noteListFuture.then((noteList) {
        setState(() {
          this.driverList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _update(BuildContext context, Driver driver) async {
    driver.name = this.driver.name;
    driver.phone = this.driver.phone;
    driver.address = this.driver.address;
    await databaseHelper.updateDriver(driver);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
