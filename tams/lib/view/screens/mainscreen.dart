import 'package:flutter/material.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/loginscreen.dart';
import 'package:tams/view/screens/manageasset.dart';
import 'package:tams/view/screens/managerScreen.dart';
import 'package:tams/view/screens/profilescreen.dart';
import 'package:tams/view/screens/registerscreen.dart';
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
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(actions: [
        IconButton(
            onPressed: registrationform, icon: Icon(Icons.app_registration)),
        IconButton(onPressed: loginform, icon: Icon(Icons.login)),
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          InkWell(
            onTap: manageasset,
            child: Ink.image(
              image: AssetImage('assets/images/Staff.png'),
              height: 190,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: managerpage,
            child: Ink.image(
              image: AssetImage('assets/images/Manager.png'),
              height: 190,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: supplierpage,
            child: Ink.image(
              image: AssetImage('assets/images/Supplier.png'),
              height: 190,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      //     SizedBox.fromSize(
            //       size: Size(350, 130), // button width and height
            //       child: ClipRRect(
            //         child: Material(
            //           color: Color.fromARGB(255, 82, 165, 232), // button color
            //           child: InkWell(
            //             splashColor: Colors.grey, // splash color
            //             onTap: staffpage, // button pressed
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 Icon(Icons.assignment_ind, size: 50), // icon
            //                 Text("Staff",
            //                     style: TextStyle(
            //                         fontSize: 25
            //                         )), // text
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 8,
            //     ),
            //     SizedBox.fromSize(
            //       size: Size(350, 130), // button width and height
            //       child: ClipRRect(
            //         child: Material(
            //           color: Color.fromARGB(255, 82, 165, 232), // button color
            //           child: InkWell(
            //             splashColor: Colors.grey, // splash color
            //             onTap: managerpage, // button pressed
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 Icon(Icons.assignment_ind, size: 50), // icon
            //                 Text("Manager",
            //                     style: TextStyle(
            //                         fontSize: 25)), // text
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     // MaterialButton(
            //     //   shape: RoundedRectangleBorder(
            //     //       borderRadius: BorderRadius.circular(5.0)),
            //     //   minWidth: 150,
            //     //   height: 150,
            //     //   elevation: 10,
            //     //   onPressed: staffpage,
            //     //   color: Theme.of(context).colorScheme.primary,
            //     //   child: const Text('Staff'),
            //     // ),

            //  SizedBox(
            //   height: 8,
            // ),

            // SizedBox.fromSize(
            //   size: Size(350, 130), // button width and height
            //   child: ClipRRect(
            //     child: Material(
            //       color: Color.fromARGB(255, 82, 165, 232), // button color
            //       child: InkWell(
            //         splashColor:
            //             Colors.grey, // splash color
            //         onTap: supplierpage, // button pressed
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Icon(Icons.assignment_ind, size: 50), // icon
            //             Text("Supplier",
            //                 style: TextStyle(
            //                     fontSize: 25)), // text
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       UserAccountsDrawerHeader(
      //         accountEmail: Text(widget.user.email
      //             .toString()), // keep blank text because email is required
      //         accountName: Row(
      //           children: <Widget>[
      //             Container(
      //               width: 50,
      //               height: 50,
      //               decoration: const BoxDecoration(shape: BoxShape.circle),
      //               child: const CircleAvatar(
      //                 radius: 64,
      //                 backgroundColor: Colors.redAccent,
      //                 child: Icon(
      //                   Icons.check,
      //                 ),
      //               ),
      //             ),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 Text(widget.user.username.toString()),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         title: const Text('Main Screen'),
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (content) =>  MainScreen(user: widget.user)));
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Profile'),
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (content) =>  ProfileScreen(user: widget.user)));
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void manageasset() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) =>  ManageAsset(user: widget.user)));
  }

  void staffpage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) =>  ManageAsset(user: widget.user)));
  }

  void managerpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) =>  ManagerScreen(user: widget.user)));
  }

  void supplierpage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const SupplierScreen()));
  }

  void registrationform() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const Registration()));
  }

  void loginform() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const Login()));
  }
}
