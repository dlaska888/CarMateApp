import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
            backgroundColor: Colors.white,
            foregroundColor: CarMateAppTheme.primary,
            textStyle:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: CarMateAppTheme.primary,
        body: Expanded(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: EdgeInsets.all(48.0),
                decoration: const BoxDecoration(
                    color: CarMateAppTheme.primaryLight,
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Login",
                        style: TextStyle(color: Colors.white, fontSize: 48.0)),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        hintText: 'Email or Username',
                        fillColor:
                            Colors.white, // Set background color to white
                        filled: true, // Apply the filled background
                        contentPadding:
                            EdgeInsets.all(8.0), // Adjust padding if needed
                        constraints:
                            BoxConstraints(maxWidth: 500), // Set max width
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        hintText: 'Password',
                        fillColor:
                            Colors.white, // Set background color to white
                        filled: true, // Apply the filled background
                        contentPadding:
                            EdgeInsets.all(8.0), // Adjust padding if needed
                        constraints:
                            BoxConstraints(maxWidth: 500), // Set max width
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/dashboard");
                      },
                      child: const Text("Login"),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Dont have an account? Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, "/register")),
                    )
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
                        style: TextStyle(color: Colors.white, fontSize: 24.0))
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
