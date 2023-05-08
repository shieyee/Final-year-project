import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  PageController _pageController = PageController();
  late List<Widget> _screen = [
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
      appBar:
          AppBar(title: const Text("Supplier", style: TextStyle(fontSize: 17))),
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
              label: 'Tender Ads',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high),
              label: 'Your Tender Status',
              backgroundColor: Colors.blue),
        ]
      )
    );
  }
}
