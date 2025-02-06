import 'package:carrier_seeker_app/features/college/college.dart';
import 'package:carrier_seeker_app/features/course/courses.dart';
import 'package:carrier_seeker_app/features/profile/profile_screen.dart';
import 'package:carrier_seeker_app/features/recommended/recommended_universities.dart';
import 'package:carrier_seeker_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login/login_screen.dart';
import 'university/universities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          _tabController.index == 4 ? 'PROFILE' : 'COURSA!',
          style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              RecommendedUniversitie(),
              Universities(),
              Collages(),
              Courses(),
              ProfileScreen(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, bottom: 18),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomNavBarItem(
                      isActive: _tabController.index == 0,
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                      iconData: Icons.home_outlined,
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 1,
                      iconData: Icons.school,
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 2,
                      iconData: Icons.location_city,
                      onTap: () {
                        _tabController.animateTo(2);
                      },
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 3,
                      iconData: Icons.psychology,
                      onTap: () {
                        _tabController.animateTo(3);
                      },
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 4,
                      onTap: () {
                        _tabController.animateTo(4);
                      },
                      iconData: Icons.person_2_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'SEARCH',
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_outlined),
              ),
              // suffixIcon: _searchController.text.isEmpty
              //     ? const SizedBox()
              //     : IconButton(
              //         onPressed: () {},
              //         icon: const Icon(Icons.close),
              //       ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding: const EdgeInsets.all(20),
            ),
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class CustomNavBarItem extends StatelessWidget {
  final Function() onTap;
  final IconData iconData;
  final bool isActive;
  const CustomNavBarItem({
    super.key,
    required this.iconData,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
              if (isActive)
                CircleAvatar(
                  radius: 2,
                  backgroundColor: Colors.white,
                )
            ],
          ),
        ),
      ),
    );
  }
}
