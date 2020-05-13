import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttersqflite/model/employee.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Employee(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, mobileno TEXT,email TEXT )");
    print("Created tables");
  }


  // Retrieving employees from Employee Tables
  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["id"], list[i]["firstname"], list[i]["lastname"], list[i]["mobileno"], list[i]["email"]));
    }
    //print(employees.length);
    return employees;
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEmployee(int id) async {
    var dbClient = await db;
    await dbClient.rawQuery('DELETE FROM Employee WHERE id=$id');
    return id;
  }

  void saveEmployee(Employee employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(firstname, lastname, mobileno, email ) VALUES(' +
              '\'' +
              employee.firstName +
              '\'' +
              ',' +
              '\'' +
              employee.lastName +
              '\'' +
              ',' +
              '\'' +
              employee.mobileNo +
              '\'' +
              ',' +
              '\'' +
              employee.email +
              '\'' +
              ')');
    });
  }

  void updateEmployee(Employee employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'UPDATE Employee SET firstname = "'+ employee.firstName +
              '" , lastname = "' + employee.lastName +
              '" , mobileno = "' + employee.mobileNo +
              '" , email = "' + employee.email +
              '" WHERE id = ' + employee.id.toString() + ';');

    });
  }

}