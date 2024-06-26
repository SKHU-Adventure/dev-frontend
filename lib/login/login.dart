import 'package:flutter/material.dart';
import 'package:project_heck/naver_map/naver_map.dart';
import 'package:project_heck/login/sign_up.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildLogo(),
              const SizedBox(height: 40),
              _buildLoginForm(context),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/main.png',
            width: 190.0,
            height: 190.0,
          ),
          const SizedBox(height: 30),
          const Text(
            '스쿠벤처에 오신걸 환영합니다',
            style: TextStyle(
              color: Color.fromARGB(255, 89, 89, 89),
              fontFamily: 'GmarketSansTTFBold',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            controller: emailController,
            label: '이메일',
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            controller: passwordController,
            label: '비밀번호',
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          const SizedBox(height: 40.0),
          _buildLoginButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 161, 161, 161),
          fontSize: 14,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }

  // Widget _buildLoginButton(BuildContext context) {
  //   return SizedBox(
  //     width: 307,
  //     height: 47,
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         final response = await _authService.login(
  //           emailController.text,
  //           passwordController.text,
  //         );
  //
  //         if (response == "Login successful") {
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.setString('userEmail', emailController.text);
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => const NaverMapApp()),
  //           );
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(response ?? 'An error occurred')),
  //           );
  //         }
  //       },
  //       style: ButtonStyle(
  //         backgroundColor: WidgetStateProperty.all(const Color(0xFFF4FFCC)),
  //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  //         ),
  //       ),
  //       child: const Text(
  //         '시작하기',
  //         style: TextStyle(
  //           color: Color(0xff595959),
  //           fontFamily: 'GmarketSansTTFMedium',
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 307,
      height: 47,
      child: ElevatedButton(
        onPressed: () {
          // 임시로 로그인 버튼을 누르면 바로 다음 화면으로 이동하도록 수정
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NaverMapApp()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFFF4FFCC)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        child: const Text(
          '시작하기',
          style: TextStyle(
            color: Color(0xff595959),
            fontFamily: 'GmarketSansTTFMedium',
          ),
        ),
      ),
    );
  }
  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: const Text(
            '회원가입',
            style: TextStyle(
              color: Color(0xff595959),
              fontFamily: 'GmarketSansTTFMedium',
            ),
          ),
        ),
      ),
    );
  }
}
