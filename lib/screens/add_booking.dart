import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taxi/utils/databaseHelper.dart';
import 'package:taxi/models/booking.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

const TextStyle headstyle = TextStyle(fontSize: 12, color: Colors.white);
const Color bgcolor = Color(0xFF007b7f);
const Color bgcolor2 = Color(0xFF005659);
const Color card1color = Color(0xFF004a4d);
const Color fgcolor = Colors.black38;
const Color textcolor = Colors.white;

class AddBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      home: Add_booking(),
    );
  }
}

class Add_booking extends StatefulWidget {
  @override
  _Add_bookingState createState() => _Add_bookingState();
}

class _Add_bookingState extends State<Add_booking> {
  int d_id, choice = 0;
  Note expense;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> bookingList, searchList;
  int _selectedTaxiId = 0;
  int count = 0, count2 = 0;
  List<int> availtaxilist;
  LinkedScrollControllerGroup _controllers;
  ScrollController tit, bit, sit;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController didController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    tit = _controllers.addAndGet();
    bit = _controllers.addAndGet();
    sit = _controllers.addAndGet();
  }

  @override
  void dispose() {
    tit.dispose();
    bit.dispose();
    sit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bookingList == null) {
      bookingList = List<Note>();
      updateExpenseView();
    }
    if (expense == null) {
      expense = Note(0, '', 0, '', 0, '');
    }

    if (searchList == null) {
      searchList = List<Note>();
    }
    if (availtaxilist == null) {
      availtaxilist = List<int>();
      gettaxi();
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgcolor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: bgcolor2,
          title: Center(child: Text('ADD BOOKING')),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Booking id : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
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
                    'Taxi id : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                DropdownButton<int>(
                    value: _selectedTaxiId,
                    hint: Text(' '),
                    items:
                        availtaxilist.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      );
                    }).toList(),
                    onChanged: (int newValue) {
                      setState(() {
                        _selectedTaxiId = newValue;
                        expense.taxiId = _selectedTaxiId;
                      });
                    })
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Amount : ',
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
                        controller: nameController,
                        onChanged: (String str) {
                          expense.amount = int.parse(nameController.text);
                        },
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Date : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      child: TextField(
                    readOnly: true,
                    controller: phoneController,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2200))
                          .then((date) {
                        setState(() {
                          phoneController.text = date.year.toString() +
                              '-' +
                              date.month.toString() +
                              '-' +
                              date.day.toString();
                          expense.date = phoneController.text;
                          gettaxi();
                        });
                      });
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
                    'Client Id : ',
                    style: TextStyle(color: textcolor),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: didController,
                    onChanged: (String str) {
                      expense.clientId = int.parse(didController.text);
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
                    'Source : ',
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
                        controller: sourceController,
                        onChanged: (String str) {
                          expense.source = sourceController.text;
                        },
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Destination : ',
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
                          expense.destination = addressController.text;
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
              color: card1color,
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
                    )),
                  ),
                  Container(
                    width: 20,
                    padding: EdgeInsets.all(2),
                    child: Text('Id', style: headstyle),
                  ),
                  Container(
                    width: 40,
                    margin: EdgeInsets.all(4),
                    child: Text('Taxi Id', style: headstyle),
                  ),
                  Container(
                    width: 40,
                    margin: EdgeInsets.all(4),
                    child: Text('Client Id', style: headstyle),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 50,
                    child: Text('Amount', style: headstyle),
                  ),
                  Container(
                    width: 80,
                    child: Text('Date', style: headstyle),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 150,
                    child: Text('Source', style: headstyle),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 150,
                    child: Text('Destination', style: headstyle),
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
                child: chosselist(choice),
              ),
            )
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
    await databaseHelper.insertNote(expense);
  }

  void _search({int id}) async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture =
          databaseHelper.searchExpense(expense, id: id);
      noteListFuture.then((noteList) {
        setState(() {
          this.searchList = noteList;
          this.count2 = noteList.length;
        });
      });
    });
  }

  void gettaxi() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<int>> noteListFuture =
          databaseHelper.getavailabletaxi(date: expense.date);
      noteListFuture.then((noteList) {
        setState(() {
          this.availtaxilist = noteList;
          if (availtaxilist.isEmpty) availtaxilist.add(0);
          _selectedTaxiId = availtaxilist[0];
          expense.taxiId = _selectedTaxiId;
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
          color: card1color,
          elevation: 2.0,
          child: SingleChildScrollView(
            controller: bit,
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
              onDoubleTap: () {
                nameController.text = bookingList[position].amount.toString();
                expense.amount = bookingList[position].amount;
                sourceController.text = bookingList[position].source;
                expense.source = sourceController.text;
                addressController.text = bookingList[position].destination;
                expense.destination = addressController.text;
                expense.clientId = bookingList[position].clientId;
                didController.text = expense.clientId.toString();
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
                      _update(context, bookingList[position]);
                      updateExpenseView();
                    },
                  ),
                ),
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    this.bookingList[position].id.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.bookingList[position].taxiId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.bookingList[position].clientId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  child: Text(
                    this.bookingList[position].amount.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.bookingList[position].date,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.bookingList[position].source,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.bookingList[position].destination,
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
                      _delete(context, bookingList[position]);
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
          color: card1color,
          elevation: 2.0,
          child: SingleChildScrollView(
            controller: sit,
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
              onDoubleTap: () {
                nameController.text = searchList[position].amount.toString();
                expense.amount = searchList[position].amount;
                sourceController.text = searchList[position].source;
                expense.source = sourceController.text;
                addressController.text = searchList[position].destination;
                expense.destination = addressController.text;
                expense.clientId = searchList[position].clientId;
                didController.text = expense.clientId.toString();
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
                    this.searchList[position].taxiId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.searchList[position].clientId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  child: Text(
                    this.searchList[position].amount.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.searchList[position].date,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.searchList[position].source,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.searchList[position].destination,
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

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) _showSnackBar(context, 'Note Deleted Successfully');
    updateExpenseView();
    _search();
  }

  void updateExpenseView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.bookingList = noteList;
          this.count = noteList.length;
        });
        gettaxi();
      });
    });
  }

  void _update(BuildContext context, Note driver) async {
    driver.taxiId = this.expense.taxiId;
    driver.date = this.expense.date;
    driver.destination = this.expense.destination;
    driver.amount = this.expense.amount;
    driver.source = this.expense.source;
    driver.clientId = this.expense.clientId;
    await databaseHelper.updateNote(driver);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
