import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmore/blocs/auth/auth_bloc.dart';
import 'package:gmore/models/login_model.dart';
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

  // void login() {
  //   String username = _usernameController.text;
  //   String password = _passwordController.text;

  //   if (validate()) {
  //     Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Invalid Username or Password'),
  //         duration: Duration(seconds: 2),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  bool validate() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state);
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid Username or Password'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.only(top: 150, bottom: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // image: AssetImage('assets/bg_logo.png'),
                      image: AssetImage('assets/ic_logo.png'),
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
                      onPressed: () {
                        if (validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
                                  LoginModel(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                ),
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Semua field harus diisi'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
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
          );
        },
      ),
    );
  }
}
