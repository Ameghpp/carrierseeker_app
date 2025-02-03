import 'package:flutter/material.dart';

import '../home_screen.dart';

class Universities extends StatefulWidget {
  const Universities({
    super.key,
  });

  @override
  State<Universities> createState() => _UniversitiesState();
}

class _UniversitiesState extends State<Universities> {
  List data = [];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemBuilder: (context, index) => CustomCard(
        image: data[index]['image'],
        title: data[index]['title'],
        locationText: data[index]['locationText'],
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 30,
      ),
      itemCount: data.length,
    );
  }
}
