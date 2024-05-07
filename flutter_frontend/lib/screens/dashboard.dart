import 'package:flutter/material.dart';
import 'package:flutter_frontend/local_preferences_manager.dart';
import 'package:flutter_frontend/screens/dashboard_pages/add_first_car.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home.dart';
import 'package:flutter_frontend/screens/dashboard_pages/logout.dart';
import 'package:flutter_frontend/screens/dashboard_pages/my_cars.dart';
import 'package:flutter_frontend/screens/dashboard_pages/expenses.dart';
import 'package:flutter_frontend/screens/dashboard_pages/settings.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  var _selectedPage = 0;

  late Future<String?> _futureSelectedCarId;

  List<Widget> getPages(String? selectedCarId) {
    return [
      selectedCarId != null
          ? HomePage(selectedCarId)
          : AddFirstCarPage(refreshSelectedCarId),
      selectedCarId != null
          ? MyCarsPage(selectedCarId)
          : AddFirstCarPage(refreshSelectedCarId),
      selectedCarId != null
          ? ExpensesPage(selectedCarId)
          : AddFirstCarPage(refreshSelectedCarId),
      const SettingsPage(),
      const LogoutPage()
    ];
  }

  void refreshSelectedCarId() {
    setState(() {
      _futureSelectedCarId = LocalPreferencesManager.getSelectedCarId();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureSelectedCarId = LocalPreferencesManager.getSelectedCarId();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = Theme.of(context).primaryColor;
    final primaryLight = Theme.of(context).primaryColorLight;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
          backgroundColor: primary,
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
                      Text("Your name",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 16.0)),
                      Text("email@gmail.com",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 16 - .0)),
                    ]),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => {
                            setState(() {
                              _selectedPage = 3;
                            }),
                            scaffoldKey.currentState?.closeDrawer()
                          },
                          label: const Text("Settings"),
                          icon: const Icon(Icons.settings),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/login'),
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
                          style: TextStyle(color: Colors.white, fontSize: 24.0))
                    ],
                  ),
                )
              ],
            ),
          )),
      appBar: screenWidth <= 900
          ? AppBar(
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
                      hintText: 'Search',
                    ),
                  ),
                ),
              ),
              primary: false,
              backgroundColor: primary,
            )
          : null,
      body: Row(children: [
        if (screenWidth > 900)
          NavigationRail(
            selectedIndex: _selectedPage,
            onDestinationSelected: (int index) {
              refreshSelectedCarId();
              setState(() {
                _selectedPage = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home, color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  label: Text("")),
              NavigationRailDestination(
                  icon: Icon(Icons.directions_car, color: Colors.white),
                  label: Text("")),
              NavigationRailDestination(
                  icon: Icon(Icons.attach_money, color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  label: Text("")),
              NavigationRailDestination(
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: Text("")),
              NavigationRailDestination(
                  icon: Icon(Icons.logout, color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  label: Text(""))
            ],
            labelType: NavigationRailLabelType.none,
            backgroundColor: primary,
            indicatorColor: primaryLight,
          ),
        Expanded(
          child: FutureBuilder(
              future: _futureSelectedCarId,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading data"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return getPages(snapshot.data)[_selectedPage];
              }),
        ),
      ]),
      bottomNavigationBar: screenWidth <= 900
          ? BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedPage > 2 ? 0 : _selectedPage,
              onTap: (index) {
                refreshSelectedCarId();
                setState(() {
                  _selectedPage = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.directions_car), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.attach_money), label: "")
              ],
            )
          : null,
    );
  }
}
