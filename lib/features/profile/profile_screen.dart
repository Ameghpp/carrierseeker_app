import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        ClipOval(
          child: Image.network(
            "https://img.freepik.com/premium-vector/female-user-profile-avatar-is-woman-character-screen-saver-with-emotions_505620-617.jpg",
            alignment: Alignment.center,
            width: 200,
            height: 200,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'USERNAME',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'EMAIL',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white),
          ),
        ),
      ],
    );
  }
}
