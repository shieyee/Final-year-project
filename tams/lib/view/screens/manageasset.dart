import 'package:flutter/material.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/loginscreen.dart';
import 'package:tams/view/screens/registerscreen.dart';

class ManageAsset extends StatefulWidget {
  final User user;
  const ManageAsset({super.key, required this.user});

  @override
  State<ManageAsset> createState() => _ManageAssetState();
}

class _ManageAssetState extends State<ManageAsset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: const Text("Manage Asset"),
       actions:  [
              IconButton(
                  onPressed: registrationform,
                  icon: Icon(Icons.app_registration)),
              IconButton(onPressed: loginform, icon: Icon(Icons.login)),
            ]),
      body: const Center(child: Text("Manage Asset")),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: const Text(
                  'email@tams.com'), // keep blank text because email is required
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
                    children: const <Widget>[
                       Text('user'),
                       Text('@User'),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Main Page'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => const MainScreen()));
              },
            ),
            ListTile(
              title: const Text('Manage Asset'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (content) => const ManageAsset()));
              },
            ),
            ListTile(
              title: const Text('Manage Tender'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      
    );
  }

  void registrationform() {
    Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const Registration()));
  }

  void loginform() {
    Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const Login()));
  }
}