// ########################
// Imports.
// ########################

// External.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ########################
// User Handler.
// ########################

class UserHandler
{
  // ########################
  // Variables.
  // ########################

  // Singleton.
  static UserHandler instance = UserHandler._();

  // ########################
  // Constructor.
  // ########################

  UserHandler._();

  // ########################
  // Public Methods.
  // ########################

  Future<void> createUser(String userName) async
  {

  }

  Future<List<User>> getUserList() async
  {

    List<User> users = [];

    return users;
  } 
}

// ########################
// User Data Type.
// ########################
class User 
{
  // Data.
  late String userName;

  // Constructor.
  User
  (
    {
      required this.userName,
    }
  );

  User.fromMap(Map<String, dynamic> map)
  {
    // Set the data.
    userName = map["userName"];
  }

  // Convert to map.
  Map<String, dynamic> toMap()
  {
    return {"userName" : userName};
  }
}