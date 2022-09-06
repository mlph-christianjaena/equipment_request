import 'package:equipment_request/screens/add_equipment.dart';
import 'package:equipment_request/screens/equipments.dart';
import 'package:equipment_request/screens/screening.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppBottomNavigationBar(),
    );
  }
}

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _currentIndex = 0;
  bool isAdmin = true;

  final List<Widget> _children = [
    Equipments(
      isAssigned: false,
    ),
    Equipments(
      isAssigned: true,
    )
  ];

  final List<String> _routes = <String>[
    "Available Equipments",
    "Assigned Equipments"
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_routes[_currentIndex].toString()),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.request_page), label: 'Request'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Assigned')
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  isAdmin ? const Text("admin") : const Text("employee"),
              accountEmail: isAdmin
                  ? const Text("admin@email.com")
                  : const Text("employee@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.yellow,
                child: isAdmin
                    ? const Text(
                        "A",
                        style: TextStyle(fontSize: 40.0),
                      )
                    : const Text(
                        "E",
                        style: TextStyle(fontSize: 40.0),
                      ),
              ),
            ),
            if (isAdmin) ...[
              ListTile(
                title: const Text('Screening'),
                leading: const Icon(Icons.approval),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Screening()));
                },
              ),
              ListTile(
                title: const Text('Add Equipment'),
                leading: const Icon(Icons.add_box),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddEquipment()));
                  // Logout
                },
              ),
            ],
            ListTile(
              title: isAdmin
                  ? const Text('Logout (Switch to Employee)')
                  : const Text('Logout (Switch to Admin)'),
              leading: const Icon(Icons.logout),
              onTap: () {
                setState(() {
                  isAdmin = !isAdmin;
                });
                // Logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
