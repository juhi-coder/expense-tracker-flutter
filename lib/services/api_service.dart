import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

class ApiService {
  final _dialogService = DialogService();
  final url = 'http://192.168.1.17:8080';

  Future<dynamic> signup(String username, String email, String password) async {
    final response = await http.post(Uri.parse('$url/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'email': email,
          'password': password
        }));
    if (response.statusCode == 201) {
      await _dialogService.showDialog(
        title: 'Success',
        description: 'User created successfully',
        buttonTitle: 'OK',
      );
      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      await _dialogService.showDialog(
        title: 'Error',
        description: responseBody['message'] ?? 'Failed to add the data',
        buttonTitle: 'OK',
      );
      return false;
    }
  }

  Future<dynamic> login(String email, String password) async {
    final response = await http.post(Uri.parse('$url/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset-UTF=8'
        },
        body: jsonEncode(
            <String, dynamic>{'email': email, 'password': password}));
    if (response.statusCode == 200) {
      await _dialogService.showDialog(
          title: 'Success',
          description: 'Login Sucessfully',
          buttonTitle: 'ok');
      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      await _dialogService.showDialog(
        title: 'Error',
        description: responseBody['message'] ?? 'Failed to login',
        buttonTitle: 'OK',
      );
      return false;
    }
  }

  Future<dynamic> postExpenses(
      String name, String category, dynamic amount) async {
    final response = await http.post(Uri.parse('$url/expenses/create'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'category': category,
          'amount': amount
        }));
    if (response.statusCode == 201) {
      await _dialogService.showDialog(
          title: 'Success',
          description: 'Expenses added successfully',
          buttonTitle: 'ok');
      return true;
    } else {
      final responseBody = jsonDecode(response.body);
      await _dialogService.showDialog(
        title: 'Error',
        description: responseBody['message'] ?? 'Failed to add expenses',
        buttonTitle: 'OK',
      );
      return false;
    }
  }

  Future<List<dynamic>> getExpenses() async {
    final response = await http.get(Uri.parse('$url/expenses/get'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('failed to load data');
    }
  }
}
