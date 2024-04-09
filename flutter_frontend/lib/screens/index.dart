import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';

class Index extends StatelessWidget {
  const Index({super.key});

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
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if(MediaQuery.of(context).size.width > 1200) Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Container(
                decoration:
                    const BoxDecoration(color: CarMateAppTheme.primaryLight),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 150.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("CarMate",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 96.0)),
                          Text(
                            "Your best maintenance friend",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
                fit: FlexFit.tight,
                flex: 4,
                child: Container(
                  decoration:
                      const BoxDecoration(color: CarMateAppTheme.primary),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.25), // Shadow color
                                blurRadius:
                                    4.0, // Adjusts shadow blur (optional)
                                offset: const Offset(
                                    0.0, 4.0), // Offset of the shadow (X, Y)
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {Navigator.pushNamed(context, "/login");},
                            child: const Text("Sign In"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {Navigator.pushNamed(context, "/register");},
                            child: const Text("Sign Up"),
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
