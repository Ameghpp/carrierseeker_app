import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [
    {
      'image':
          "https://th.bing.com/th/id/OIP.1RKEZDnbMdqoJrxLOlnoFwHaD4?rs=1&pid=ImgDetMain",
      'title': 'CALICUT UNIVERSITY ',
      'locationText': 'CALICUT,KERALA ',
    },
    {
      'image':
          "https://images.news18.com/ibnlive/uploads/2022/10/kannuruniversity-166659267916x9.jpg",
      'title': 'KANNUR UNIVERSITY ',
      'locationText': 'KANNUR,KERALA ',
    },
    {
      'image':
          "https://images.news18.com/ibnlive/uploads/2022/10/kannuruniversity-166659267916x9.jpg",
      'title': 'Cochin University of Science and Technology',
      'locationText': 'KOCHI,KERALA ',
    },
  ];
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
          ListView.separated(
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, bottom: 18),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 42, 146, 230),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CustomNavBarItem(
                      iconData: Icons.home_outlined,
                    ),
                    CustomNavBarItem(iconData: Icons.mail_outline),
                    CustomNavBarItem(iconData: Icons.bookmark_border_outlined),
                    CustomNavBarItem(iconData: Icons.more_rounded),
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

class CustomNavBarItem extends StatelessWidget {
  final IconData iconData;
  const CustomNavBarItem({
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: 50,
        ),
        CircleAvatar(
          radius: 5,
          backgroundColor: Colors.white,
        )
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image, title, locationText;
  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.locationText,
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
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
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
