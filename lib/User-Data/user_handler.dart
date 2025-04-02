// ########################
// Imports.
// ########################

// External.
import 'dart:async';

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

  // User.
  User? currentUser = null;

  // Database.
  late Database _sqlDB;

  final String dbTableUsers = "users";

  // ########################
  // Constructor.
  // ########################

  UserHandler._();

  // ########################
  // Public Methods.
  // ########################

  /// Initialises the user database.
  Future<void> initialise() async
  {
    _sqlDB = await openDatabase
    (
      join(await getDatabasesPath(), "data.db"),
      onCreate:(db, version) async
      {
        return await db.execute
        (
          "CREATE TABLE $dbTableUsers("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "userName VARCHAR(64) NOT NULL,"
            "userLearningLevel VARCHAR(512)"
            ");"
        );
      },
      version: 1
    );
  }

  /// Create user, checks if a new user exists.
  Future<User> createUser(String userName) async
  {
    // Check if a user exists.
    List<Map<String, dynamic>> userList = await _sqlDB.query(dbTableUsers, where: "userName = ?", whereArgs: ["userName"]);

    for (int i = 0; i < userList.length; i++)
    {
      if (userList[i]["userName"] == userName)
      {
        return User.fromMap(userList[i]);
      }
    }

    // Insert user into database.
    int id = await _sqlDB.insert(dbTableUsers, {"userName" : userName});

    return (await getUser(userName))!;
  }

  /// Returns a specific user from the database based on ID.
  Future<User?> getUser(String userName) async
  {
    // Get the user.
    List<Map<String, dynamic>> user = await _sqlDB.query(dbTableUsers, where: "userName == ?", whereArgs: [userName]);

    // No user with that ID found.
    if (user.isEmpty)
    {
      return null;
    }

    // User found and returned.
    return User.fromMap(user[0]);
  }

  /// Returns a list of users.
  Future<List<User>> getUserList() async
  {
    List<User> users = [];

    return users;
  }

  Future<bool> userLogin(int userId) async
  {
    // Get a list of all users.
    List<User> users = await getUserList();

    // Returns if any users with this userID exist.
    return users.any((user) => user.userId == userId);
  }
}

// ########################
// User Data Type.
// ########################
class User 
{
  // Data.
  late int    userId;
  late String userName;
  late String userLearningLevel;

  // Constructor.
  User
  (
    {
      this.userId = -1,
      required this.userName,
      this.userLearningLevel = "",
    }
  );

  User.fromMap(Map<String, dynamic> map)
  {
    // Set the data.
    userId            = map["id"];
    userName          = map["userName"];
    userLearningLevel = map["userLearningLevel"] ?? "";
  }

  // Convert to map.
  Map<String, dynamic> toMap()
  {
    return {"userId" : userId, "userName" : userName, "userLearningLevel" : userLearningLevel};
  }
}