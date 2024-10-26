import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<String> signup(Users user) async {
    try {
      print('Sending signup request: ${user.toJson()}');
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      print('Received response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 201) {
        return 'Signup successful';
      } else {
        throw Exception('Failed to signup: ${response.body}');
      }
    } catch (e) {
      print('Error during signup: $e');
      rethrow;
    }
  }

  static Future<String> login(String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'password': password}),
      );

      if (response.statusCode == 200) {
        // 로그인 성공 시 쿠키(세션 ID)를 저장합니다.
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          String cookie =
              (index == -1) ? rawCookie : rawCookie.substring(0, index);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionCookie', cookie);
          print('Session cookie saved: $cookie');
        } else {
          print('No session cookie found in response headers');
        }
        return 'Login successful';
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  static Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }

  static Future<String> completeMission(int buildingNumber) async {
    final sessionCookie = await getSessionCookie();
    if (sessionCookie == null) {
      throw Exception('Not logged in');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/missions/building/$buildingNumber'),
      headers: {'Cookie': sessionCookie},
    );

    if (response.statusCode == 200) {
      return 'Mission completed';
    } else {
      throw Exception('Failed to complete mission: ${response.body}');
    }
  }

  static Future<String> getMajorInfo() async {
    final sessionCookie = await getSessionCookie();
    if (sessionCookie == null) {
      throw Exception('Not logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/major/info'),
      headers: {'Cookie': sessionCookie},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get major info: ${response.body}');
    }
  }

  static Future<Users> getUserInfo() async {
    final sessionCookie = await getSessionCookie();
    if (sessionCookie == null) {
      throw Exception('Not logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/info'),
      headers: {'Cookie': sessionCookie},
    );

    if (response.statusCode == 200) {
      return Users.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user info: ${response.body}');
    }
  }
}

class Users {
  final String userId;
  final String? password;
  final String userName;
  final int majorId;
  final String studentId;

  Users({
    required this.userId,
    this.password,
    required this.userName,
    required this.majorId,
    required this.studentId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'password': password,
        'userName': userName,
        'majorId': majorId,
        'studentId': studentId,
      };

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json['userId'],
        userName: json['userName'],
        majorId: json['majorId'],
        studentId: json['studentId'],
        password: json['password'],
      );
}

class MissionEntity {
  final int id;
  final String userId;
  final int buildingId;
  final bool completed;

  MissionEntity({
    required this.id,
    required this.userId,
    required this.buildingId,
    required this.completed,
  });

  factory MissionEntity.fromJson(Map<String, dynamic> json) => MissionEntity(
        id: json['id'],
        userId: json['userId'],
        buildingId: json['buildingId'],
        completed: json['completed'],
      );
}