import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home/boolmark_screen.dart';
import 'login/login_screen.dart';
import 'profile/profile_screen.dart';
import 'university/universities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _searchController.addListener(() {
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
        title: const Text(
          'COURSA!',
          style: TextStyle(
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
            controller: _tabController,
            children: [
              Universities(),
              SearchScreen(searchController: _searchController),
              BookMarkScreen(),
              ProfileScreen(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, bottom: 18),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              color: Color.fromARGB(255, 42, 146, 230),
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
                      iconData: Icons.search_outlined,
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 2,
                      iconData: Icons.bookmark_border_outlined,
                      onTap: () {
                        _tabController.animateTo(2);
                      },
                    ),
                    CustomNavBarItem(
                      isActive: _tabController.index == 3,
                      iconData: Icons.person_2_outlined,
                      onTap: () {
                        _tabController.animateTo(3);
                      },
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
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'SEARCH',
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_outlined),
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? SizedBox()
                  : IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.close),
                    ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              contentPadding: const EdgeInsets.all(20),
            ),
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 50,
            ),
            if (isActive)
              CircleAvatar(
                radius: 2,
                backgroundColor: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image, title, locationText;
  final bool bookmarked;
  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.locationText,
    this.bookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: 170,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            Text(
                              locationText,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      bookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
