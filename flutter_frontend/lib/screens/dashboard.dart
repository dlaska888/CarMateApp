import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/local_preferences_manager.dart';
import 'package:flutter_frontend/screens/dashboard_components/drawer.dart';
import 'package:flutter_frontend/screens/dashboard_pages/add_first_car.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home.dart';
import 'package:flutter_frontend/screens/dashboard_pages/logout.dart';
import 'package:flutter_frontend/screens/dashboard_pages/my_cars.dart';
import 'package:flutter_frontend/screens/dashboard_pages/expenses.dart';
import 'package:flutter_frontend/screens/dashboard_pages/settings.dart';

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
      drawer: DashboardDrawer((selectedPage) => setState(
            () => _selectedPage = selectedPage,
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
