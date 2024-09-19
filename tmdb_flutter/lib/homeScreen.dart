import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tmdb_flutter/Model/model.dart';
import 'package:tmdb_flutter/Services/services.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<List<Movie>> nowShowing;

  @override
  void initState() {
    super.initState();
    nowShowing = APIsevices().getNowShowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie App"),
        leading: const Icon(Icons.menu),
        actions: const [
          Icon(Icons.search_rounded),
          SizedBox(width: 20),
          Icon(Icons.notifications),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Now Showing",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Movie>>(
              future: nowShowing,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No movies available'),
                  );
                }
                
                final movies = snapshot.data!;
                
                return CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, realIndex) {
                    final movie = movies[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(movie.backDropPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}