import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/assetdetailsscreen.dart';
import 'package:tams/view/screens/manageasset.dart';
import 'package:tams/view/screens/listAssetscreen.dart';
import 'package:tams/view/screens/supplierScreen.dart';

class ManagerScreen extends StatefulWidget {
  final User user;
  const ManagerScreen({super.key, required this.user});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {

  int _currentIndex = 0;
  PageController _pageController = PageController();
  late List<Widget> _screen;
  void _onPageChanged(int index){

  }
  void _onItemTapped(int SelectedIndex){
    _pageController.jumpToPage(SelectedIndex);
  }
   @override
  void initState() {
    super.initState();
    _screen = [
      ListAssetScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 30,
        items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Asset Details',
            backgroundColor: Colors.blue),
            BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: 'Manage Tender',
            backgroundColor: Colors.blue),
      ],
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
      ),
    );
  }
}
