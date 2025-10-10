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
    const History(),
    const Home(),
    Create(),
    const Profile(),
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
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                bool isSelected = index == _selectedIndex;

                final double unselectedWidth = 50;
                final double selectedWidth = 115;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      end: isSelected ? selectedWidth : unselectedWidth,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, widthValue, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: widthValue,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              color: isSelected ? Colors.white : colors.primary,
                              size: 28,
                            ),
                            if (isSelected)
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: AnimatedOpacity(
                                    opacity: isSelected ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child: Text(
                                      item['label'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
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
