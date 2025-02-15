import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class UserProvider with ChangeNotifier {
  final List<dynamic> _users = []; // List to store fetched users
  final List<dynamic> _filteredUsers = [];
  bool _isLoading = false; // Loading state
  String _error = ''; // Error message

  // Getters for users, loading state, and error
  List<dynamic> get users => _users;
  List<dynamic> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      _users
      ..clear()
      ..addAll(json.decode(response.body));
  
      _users.sort((a, b) => a["name"].toString().compareTo(b["name"].toString()));

      _filteredUsers
      ..clear()
      ..addAll(_users);

      log("users:${_users}");

      _error = ''; // Clear any previous errors
    } else if (response.statusCode == 400) {
      _error = 'Bad request. Please try again later.';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (response.statusCode == 401) {
      _error = 'Unauthorized access. Please check your credentials.';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (response.statusCode == 403) {
      _error = 'Forbidden. You do not have permission to access this resource.';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (response.statusCode == 404) {
      _error = 'Users not found. Please check the URL.';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else if (response.statusCode == 500) {
      _error = 'Server error. Please try again later.';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      _error = 'Failed to load users. Status code: ${response.statusCode}';
      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  } on SocketException {
    _error = 'No internet connection. Please check your network and try again.';
    Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  } on TimeoutException {
    _error = 'Request timeout. Please try again later.';
    Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  } on FormatException {
    _error = 'Invalid response format. Please contact support.';
    Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  } catch (e) {
    _error = 'An unexpected error occurred: $e';
    Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // Filter users by name (for search functionality)
  //working well
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _filteredUsers
      ..clear()
      ..addAll(_users);
  
      debugPrint("when query is empty: ${_filteredUsers}");
    } 
    else {

      _filteredUsers
      ..clear()
      ..addAll(
        _users
        .where((user) => user["name"].toLowerCase().contains(query.toLowerCase()))
        .toList()
      );

      debugPrint("when query is not empty: ${_filteredUsers}");
    }
  }
}