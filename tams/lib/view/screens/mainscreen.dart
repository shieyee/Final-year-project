import 'package:flutter/material.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/managerScreen.dart';
import 'package:tams/view/screens/staffscreen.dart';
import 'package:tams/view/screens/supplierScreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double screenHeight, screenWidth, resWidth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Tender and Asset Management System",
              style: TextStyle(fontSize: 17))),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Welcome, ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      widget.user.username.toString(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 220,
                // ),
                // Image.asset('assets/images/Panda.png',scale:1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: Size(150, 150), // button width and height
                      child: ClipRRect(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Color.fromARGB(
                                255, 109, 21, 50), // splash color
                            onTap: staffpage, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.anchor, size: 50), // icon
                                Text("Staff",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox.fromSize(
                      size: Size(150, 150), // button width and height
                      child: ClipRRect(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Color.fromARGB(
                                255, 109, 21, 50), // splash color
                            onTap: managerpage, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.yard, size: 50), // icon
                                Text("Manager",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // MaterialButton(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(5.0)),
                    //   minWidth: 150,
                    //   height: 150,
                    //   elevation: 10,
                    //   onPressed: staffpage,
                    //   color: Theme.of(context).colorScheme.primary,
                    //   child: const Text('Staff'),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),

                SizedBox.fromSize(
                  size: Size(150, 150), // button width and height
                  child: ClipRRect(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor:
                            Color.fromARGB(255, 109, 21, 50), // splash color
                        onTap: supplierpage, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.wind_power_outlined, size: 50), // icon
                            Text("Supplier",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(widget.user.email
                  .toString()), // keep blank text because email is required
              accountName: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.check,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.user.username.toString()),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => const MainScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void manageasset() {
    Navigator.pop(context);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (content) => const ManageAsset()));
  }

  void staffpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const StaffScreen()));
  }

  void managerpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const ManagerScreen()));
  }

  void supplierpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const SupplierScreen()));
  }
}
