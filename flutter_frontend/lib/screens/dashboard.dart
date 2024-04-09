import 'package:flutter/material.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home/home_responsive.dart';
import 'package:flutter_frontend/screens/dashboard_pages/my_cars.dart';
import 'package:flutter_frontend/screens/dashboard_pages/expenses.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final _pages = const [HomeResponsivePage(), MyCarsPage(), ExpensesPage()];
  var _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Theme(
        data: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              backgroundColor: Colors.white,
              foregroundColor: CarMateAppTheme.primary,
              textStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        child: Drawer(
            backgroundColor: CarMateAppTheme.primary,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () =>
                              scaffoldKey.currentState?.closeDrawer(),
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () =>
                              scaffoldKey.currentState?.closeDrawer(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 150,
                        backgroundImage: AssetImage("images/car1.jpg"),
                      ),
                      const SizedBox(height: 32),
                      Column(children: [
                        Text(
                          "Your name",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.5), // Shadow color
                                blurRadius:
                                    4.0, // Adjusts shadow blur (optional)
                                offset: const Offset(
                                    0.0, 4.0), // Offset of the shadow (X, Y)
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "email@gmail.com",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.5), // Shadow color
                                blurRadius:
                                    4.0, // Adjusts shadow blur (optional)
                                offset: const Offset(
                                    0.0, 4.0), // Offset of the shadow (X, Y)
                              ),
                            ],
                          ),
                        )
                      ]),
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text("Account"),
                            icon: const Icon(Icons.account_circle),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text("Settings"),
                            icon: const Icon(Icons.settings),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/login"),
                            label: const Text("Log out"),
                            icon: const Icon(Icons.logout),
                          )
                        ],
                      ),
                    ],
                  ),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            ),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                hintText: 'Search',
                fillColor: Colors.white, // Set background color to white
                filled: true, // Apply the filled background
                contentPadding: EdgeInsets.all(8.0), // Adjust padding if needed
                constraints: BoxConstraints(maxWidth: 500), // Set max width
              ),
            ),
          ),
        ),
        primary: false,
        backgroundColor: CarMateAppTheme.primary,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _pages[_selectedPage],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CarMateAppTheme.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) => setState(() {
          _selectedPage = index;
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: CarMateAppTheme.primary),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car, color: CarMateAppTheme.primary),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money, color: CarMateAppTheme.primary),
              label: "")
        ],
      ),
    );
  }
}
