import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/helpers/google_auth_manager.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/forms/common_validators.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_button/sign_in_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _googleAuthManager = GoogleAuthManager();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(ApiEndpoints.registerEndpoint,
              methodFun: http.post,
              body: {
            'username': _username.text,
            'email': _email.text,
            'password': _password.text,
            'passwordConfirm': _cpassword.text,
          })
          .then((data) async {
            // login to obtain token and refresh token
            var data = await ApiClient.sendRequest(ApiEndpoints.loginEndpoint,
                methodFun: http.post,
                body: {
                  'username': _email.text,
                  'password': _password.text,
                });
            await ApiClient.login(data['token'], data['refresh_token']);
          })
          .then((_) => context.go('/dashboard'))
          .catchError((error) {
            NotificationService.showNotification("Error: $error",
                type: MessageType.error);
          })
          .whenComplete(() {
            setState(() {
              _isLoading = false;
            });
          });
    }
  }

  void _googleLogin(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    _googleAuthManager.loginWithGoogle().then((success) {
      if (success) {
        context.go('/dashboard');
      } else {
        NotificationService.showNotification("Error logging in with google",
            type: MessageType.error);
      }
    }).catchError((error) {
      NotificationService.showNotification("Error logging in with google",
          type: MessageType.error);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color primaryLight = Theme.of(context).primaryColorLight;

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _submit();
        }
      },
      child: Scaffold(
        backgroundColor: primary,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(48.0),
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                constraints: const BoxConstraints(minHeight: 575),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Register",
                        style: Theme.of(context).textTheme.displayLarge),
                    TextFormField(
                      controller: _username,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                      ),
                      validator: CommonValidators.getUsernameValidator(),
                    ),
                    TextFormField(
                      autofillHints: const [AutofillHints.newUsername],
                      controller: _email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: ValidationBuilder().email().build(),
                    ),
                    TextFormField(
                      autofillHints: const [AutofillHints.newPassword],
                      controller: _password,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: CommonValidators.getPasswordValidator(),
                    ),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: _cpassword,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Password confirm',
                      ),
                      validator: (value) {
                        return value!.isEmpty || value != _password.text
                            ? 'Passwords do not match'
                            : null;
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 0),
                      ),
                      onPressed: _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Register"),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go('/login'),
                          ),
                        ],
                      ),
                    ),
                    SignInButton(Buttons.google, onPressed: () async {
                      _googleLogin(context);
                    }),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 48.0,
                    ),
                    Text("CarMate",
                        style: TextStyle(color: Colors.white, fontSize: 24.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
