import 'package:flutter/material.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/pages/check_order_page.dart';
import 'package:gmore/ui/pages/home_page.dart';
import 'package:gmore/ui/pages/progress_page.dart';
import 'package:gmore/ui/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  final int selectedIndex;

  const MainPage({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProgressPage(),
    CheckOrderPage(),
    SettingsPage()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        // elevation: 20,
        // shadowColor: blackColor,
        // surfaceTintColor: blackColor,
        child: SizedBox(
          height: 70, // Atur tinggi sesuai kebutuhan
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
              _buildNavItem(
                  icon: Icons.access_time_filled, label: 'Progress', index: 1),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: StadiumBorder(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/new-order');
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (_) => const NewOrderPage()),
                  // );
                  showDialog(
                      context: context, builder: (context) => MoreDialog());
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              _buildNavItem(
                  icon: Icons.library_add_check, label: 'Check', index: 2),
              _buildNavItem(icon: Icons.settings, label: 'Settings', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      // onTap: () => setState(() => _selectedIndex = index),
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          // isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,

          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? primaryColor : Colors.grey,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8,
                  color: isSelected ? primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoreDialog extends StatelessWidget {
  const MoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // penting!
          children: [
            Text(
              'Pilih Menu',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: primaryColor),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, '/customer-form');
                  Navigator.pushNamed(context, '/ocr-ktp');
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (_) => const NewOrderPage()),
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buat Order Baru',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
