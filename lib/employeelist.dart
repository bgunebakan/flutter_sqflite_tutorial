import 'package:flutter/material.dart';
import 'package:fluttersqflite/model/employee.dart';
import 'dart:async';
import 'package:fluttersqflite/database/database.dart';

Future<List<Employee>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Employee>> employees = dbHelper.getEmployees();
  return employees;
}

Future<Future<int>> deleteEmployeeFromDatabase(int id) async {
  var dbHelper = DBHelper();
  dbHelper.deleteEmployee(id);
  return null;
}

class MyEmployeeList extends StatefulWidget {
  @override
  MyEmployeeListPageState createState() => new MyEmployeeListPageState();
}

class MyEmployeeListPageState extends State<MyEmployeeList> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Employee List'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Employee>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    String email = "";
                    if(snapshot.data[index].emailId != null){
                      email = snapshot.data[index].emailId;
                    }
                    final item = snapshot.data[index];
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(item.id.toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      confirmDismiss: (direction) async{
                        if (direction == DismissDirection.endToStart) {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to delete ${snapshot.data[index].firstName + " " + snapshot.data[index].lastName}?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        // delete From DB
                                        deleteEmployeeFromDatabase(item.id);

                                        setState(() {
                                          // Remove the item from the data source.
                                          snapshot.data.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        } else {
                          // TODO: Navigate to edit page;
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text(snapshot.data[index].firstName + " " + snapshot.data[index].lastName + "  edit page.")));
                          return false;
                        }
                      },
                      // Show a red background as the item is swiped away.
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      child: InkWell(
                          onTap: () {
                            print(snapshot.data[index].firstName + " " + snapshot.data[index].lastName +  " clicked");
                          },
                          child: ListTile(title: Text(snapshot.data[index].firstName + " " + snapshot.data[index].lastName)),

                    ),
                    );
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
