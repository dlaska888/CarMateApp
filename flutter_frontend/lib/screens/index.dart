import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color primaryLight = Theme.of(context).primaryColorLight;

    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (MediaQuery.of(context).size.width > 1200)
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Container(
                decoration: BoxDecoration(color: primaryLight),
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
                decoration: BoxDecoration(color: primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: const Text("Sign In"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/register');
                          },
                          child: const Text("Sign Up"),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
