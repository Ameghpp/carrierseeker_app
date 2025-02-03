import 'package:flutter/material.dart';

import '../home_screen.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomCard(
            image:
                "https://images.news18.com/ibnlive/uploads/2022/10/kannuruniversity-166659267916x9.jpg",
            title: "KANNUR UNIVERSITY",
            locationText: "KANNUR,KERALA",
            bookmarked: true,
          ),
        ),
      ],
    );
  }
}
