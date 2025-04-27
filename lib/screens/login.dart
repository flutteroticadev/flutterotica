import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lit_reader/env/consts.dart';
import 'package:lit_reader/env/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(50.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                if (loginController.loginState == LoginState.loading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (loginController.loginState != LoginState.loading)
                  TextFormField(
                    initialValue: loginController.username,
                    onChanged: (value) {
                      loginController.username = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                TextFormField(
                  initialValue: loginController.password,
                  onChanged: (value) {
                    loginController.password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginController.obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        loginController.obscurePassword = !loginController.obscurePassword;
                      },
                    ),
                  ),
                  obscureText: loginController.obscurePassword,
                  onFieldSubmitted: (newValue) => loginController.login(),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginController.loginState == LoginState.loggedIn ? loginController.logout() : loginController.login();
                  },
                  child: Text(
                      (loginController.loginState == LoginState.loggedOut || loginController.loginState == LoginState.failure)
                          ? 'Login'
                          : 'Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
