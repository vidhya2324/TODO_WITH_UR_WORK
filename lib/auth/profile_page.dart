import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/auth/login_page.dart';

enum ProfileAction { logout }

class ProfilePopupMenu extends StatelessWidget {
  const ProfilePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox();
    }

    final email = user.email ?? "";
    final firstLetter = email.isNotEmpty ? email[0].toUpperCase() : "?";
    return PopupMenuButton<ProfileAction>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        if (value == ProfileAction.logout) {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      itemBuilder: (context) => [
        //profile info(disable)
        PopupMenuItem(
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue,
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),

        //logout optioin
        const PopupMenuItem(
          value: ProfileAction.logout,
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
        ),
      ],

      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blue,
        child: Text(firstLetter, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
