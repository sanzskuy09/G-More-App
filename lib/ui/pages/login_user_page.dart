import 'package:flutter/material.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Username or Password'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: Container(
              height: 150,
              margin: const EdgeInsets.only(top: 150, bottom: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_logo.png'),
                  fit: BoxFit.contain, // mengecilkan agar muat
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // Align(
          //   alignment: Alignment.center,
          //   child: Text(
          //     'G-MORE APP',
          //     style: blackTextStyle.copyWith(
          //       fontSize: 20,
          //       fontWeight: semiBold,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username input
                FractionallySizedBox(
                  // widthFactor: 0.8,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      prefixIcon: Icon(Icons.person, color: primaryColor),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      hintText: 'Input Username',
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password input
                FractionallySizedBox(
                  // widthFactor: 0.8,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      prefixIcon: Icon(Icons.lock, color: primaryColor),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      hintText: 'Input Password',
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                CustomFilledButton(
                  title: 'Sign in',
                  onPressed: login,
                ),

                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: TextButton(
                //     onPressed: () {
                //       login();
                //     },
                //     style: TextButton.styleFrom(
                //       backgroundColor: primaryColor,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //     ),
                //     child: Text(
                //       'Sign In',
                //       style: whiteTextStyle.copyWith(
                //         fontSize: 16,
                //         fontWeight: semiBold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
