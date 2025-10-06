import 'package:fazr/screens/tabs/create.dart';
import 'package:fazr/screens/tabs/history.dart';
import 'package:fazr/screens/tabs/home.dart';
import 'package:fazr/screens/tabs/profile.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;

  static final List<Widget> _screens = <Widget>[
    History(),
    Home(),
    Create(),
    Profile(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.history, 'label': 'History'},
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.add_circle_outline, 'label': 'Create'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                bool isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['icon'],
                          color: isSelected ? Colors.white : colors.primary,
                          size: 28,
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : colors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
