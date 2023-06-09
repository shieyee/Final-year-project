import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/pendingtender.dart';
import 'package:tams/view/screens/tenderAdsScreen.dart';
import 'package:tams/view/screens/manageasset.dart';
import 'package:tams/view/screens/openTenderscreen.dart';
import 'package:tams/view/screens/managetender.dart';
import 'package:tams/view/screens/supplierScreen.dart';
import 'package:tams/view/screens/tenderStatus.dart';

class ManagerScreen extends StatefulWidget {
  final User user;
  const ManagerScreen({super.key, required this.user});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  PageController _pageController = PageController();
  late List<Widget> _screen = [
    OpenTenderScreen(user: widget.user),
    ManageTender(user: widget.user),
    PendingTender(user: widget.user)
  ];
  int _currentIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int SelectedIndex) {
    _pageController.jumpToPage(SelectedIndex);
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
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'Open Tender',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high),
              label: 'Manage Tender',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high),
              label: 'Pending Tender',
              backgroundColor: Colors.blue),
        ],
      ),
    );
  }
}
