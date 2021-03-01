import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taxi/utils/database_helper.dart';
import 'package:taxi/models/note.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

const TextStyle titleStyle = TextStyle(fontSize: 12);
const Color bgcolor = Color(0xFF685369);
const Color bgcolor2 = Color(0xFF554356);
const Color card1color = Color(0xFF392d39);
const Color fgcolor = Colors.black38;
// const Color textcolor = Colors.black;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      home: Add_exp(),
    );
  }
}

class Add_exp extends StatefulWidget {
  @override
  _Add_expState createState() => _Add_expState();
}

class _Add_expState extends State<Add_exp> {
  int d_id, choice = 0;
  Note expense;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> expenseList, searchList;
  int count = 0, count2 = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
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
    if (expenseList == null) {
      expenseList = List<Note>();
      updateExpenseView();
    }
    if (searchList == null) {
      searchList = List<Note>();
    }
    if (expense == null) {
      expense = Note(0, '', 0, '');
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgcolor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: bgcolor2,
          title: Center(child: Text('ADD EXPENSES')),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Expense id : '),
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
                  child: Text('Driver id : '),
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
                          expense.driverId = int.parse(didController.text);
                        },
                      )),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Amount : '),
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
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Date : '),
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
                  child: Text('Description : '),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: fgcolor, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      child: TextField(
                        controller: addressController,
                        onChanged: (String str) {
                          expense.description = addressController.text;
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
                    width: 50,
                    child: Text(
                      'Amount',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      'Date',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 150,
                    child: Text(
                      'Description',
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
                child: chosselist(choice),
              ),
            )
          ],
        ),
      ),
      theme: ThemeData.dark(),
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
                expense.amount = expenseList[position].amount;
                nameController.text = expense.amount.toString();
                expense.driverId = expenseList[position].driverId;
                didController.text = expense.driverId.toString();
                addressController.text = expenseList[position].description;
                expense.description = addressController.text;
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
                      _update(context, expenseList[position]);
                      updateExpenseView();
                    },
                  ),
                ),
                Container(
                  width: 20,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    this.expenseList[position].id.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 40,
                  margin: EdgeInsets.all(4),
                  child: Text(
                    this.expenseList[position].driverId.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  child: Text(
                    this.expenseList[position].amount.toString(),
                    style: titleStyle,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                    this.expenseList[position].date,
                    style: titleStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: Text(
                    this.expenseList[position].description,
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
                      _delete(context, expenseList[position]);
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
            controller: bit,
            scrollDirection: Axis.horizontal,
            child: GestureDetector(
              onDoubleTap: () {
                expense.amount = searchList[position].amount;
                nameController.text = expense.amount.toString();
                expense.driverId = searchList[position].driverId;
                didController.text = expense.driverId.toString();
                addressController.text = searchList[position].description;
                expense.description = addressController.text;
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
                  child: Text(
                    this.searchList[position].driverId.toString(),
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
                    this.searchList[position].description,
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
          this.expenseList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _update(BuildContext context, Note driver) async {
    driver.driverId = this.expense.driverId;
    driver.date = this.expense.date;
    driver.description = this.expense.description;
    driver.amount = this.expense.amount;
    await databaseHelper.updateNote(driver);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
