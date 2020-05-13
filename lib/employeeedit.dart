import 'package:flutter/material.dart';
import 'package:fluttersqflite/model/employee.dart';
import 'package:fluttersqflite/database/database.dart';

class EmployeeEdit extends StatelessWidget {

  final Employee employee;

  EmployeeEdit({Key key, @required this.employee}) : super(key: key);

  int id;
  String firstname;
  String lastname;
  String email;
  String mobileno;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    this.id = employee.id;
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
          title: new Text('Edit'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'First Name'),
                initialValue: employee.firstName,
                validator: (val) =>
                val.length == 0 ?"Enter First Name" : null,
                onSaved: (val) => this.firstname = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Last Name'),
                initialValue: employee.lastName,
                validator: (val) =>
                val.length ==0 ? 'Enter Last Name' : null,
                onSaved: (val) => this.lastname = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(labelText: 'Phone'),
                initialValue: employee.mobileNo,
                validator: (val) =>
                val.length ==0 ? 'Enter Phone' : null,
                onSaved: (val) => this.mobileno = val,
              ),
              new TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(labelText: 'Email'),
                initialValue: employee.email,
                validator: (val) =>
                val.length ==0 ? 'Enter Email' : null,
                onSaved: (val) => this.email = val,
              ),
              new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(onPressed: _submit,
                child: new Text('Save'),),)
            ],
          ),
        ),
      ),
    );
  }
  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var employee = Employee(id, firstname,lastname,mobileno,email);
    var dbHelper = DBHelper();
    dbHelper.updateEmployee(employee);
    //formKey.currentState.reset();
    _showSnackBar("Employee updated successfully.");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}