import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gmore/shared/theme.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _resetDataHiveTEmp() async {
    // await Hive.deleteBoxFromDisk('konsumen');
    await Hive.deleteFromDisk();
  }

  Future<void> clearAllStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final data = await storage.readAll();
    print('Storage setelah logout: $data');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await clearAllStorage(); // Hapus token
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView(
        padding: EdgeInsets.only(top: 40),
        children: [
          SizedBox(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                  ),
                  child: Icon(Icons.person, color: primaryColor, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  'Salman AF',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  'CMO - Consumer Finance',
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 160 - 40 - 70,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GENERAL",
                    style: greyTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  // Menu Item: GENERAL
                  listButton(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  listButton(
                    icon: Icons.history,
                    label: 'Log',
                    onTap: () {
                      Navigator.pushNamed(context, '/log');
                    },
                  ),
                  listButton(
                    icon: Icons.discount,
                    label: 'Promo',
                    onTap: () {
                      Navigator.pushNamed(context, '/promo');
                    },
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "OTHERS",
                    style: greyTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  // MENU ITEM : OTHER
                  listButton(
                      icon: Icons.sync,
                      label: 'Synchronize',
                      onTap: _resetDataHiveTEmp),
                  listButton(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: errorColor,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: errorColor,
                        fontWeight: semiBold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: errorColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  Divider(height: 1, color: lightBackgorundColor),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listButton({
    required IconData icon,
    required String label,
    void Function()? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          // leading: Icon(Icons.info_outlined),
          leading: Icon(icon),
          title: Text(label),
          trailing: Icon(Icons.chevron_right),
          contentPadding: EdgeInsets.symmetric(vertical: 2),
          onTap: onTap, // Action here
        ),
        Divider(height: 1, color: lightBackgorundColor),
      ],
    );
  }
}
