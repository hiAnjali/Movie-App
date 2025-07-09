import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/Services/services.dart';

import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class MovieTile extends StatefulWidget {
  final Movie movie;
  const MovieTile({super.key, required this.movie});

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          Container(
            width: 180,
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: NetworkImage(
                  widget.movie.backDropDepth.isNotEmpty
                      ? "https://image.tmdb.org/t/p/original/${widget.movie.backDropDepth}"
                      : "https://via.placeholder.com/300x450.png?text=No+Image",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //  Show full info when hovering
          if (_isHovering)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Release: ${widget.movie.releaseDate}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    "Genres: ${widget.movie.genreNames}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.movie.overview.isNotEmpty
                        ? widget.movie.overview.length > 80
                        ? widget.movie.overview.substring(0, 80) + "..."
                        : widget.movie.overview
                        : "No summary available",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
          //  Show only title at bottom when not hovering
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
                child: Text(
                  widget.movie.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

        ],
      ),
    );
  }
}



class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> nowPlaying;
  late Future<List<Movie>> upComing;
  late Future<List<Movie>> popular;
  late Future<List<Movie>> drama;
  late Future<List<Movie>> allMovies;

  @override
  void initState() {
    super.initState();
    nowPlaying = APIServices().getPlaying();
    upComing = APIServices().getUpComing();
    popular = APIServices().getPopular();
    drama = APIServices().getDrama();
    allMovies = APIServices().getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF39033E),
        title: const Text("Movie App",
        style: TextStyle(color: Colors.white),),
        leading: const Icon(Icons.menu,
        color: Colors.white,),
        centerTitle: true,
        actions: const [
          Icon(Icons.search_rounded,
          color: Colors.white,),
          SizedBox(width: 20),
          Icon(Icons.notifications,
          color: Colors.white,),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Playing Now in Cinema's",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),
            FutureBuilder<List<Movie>>(
              future: nowPlaying,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movies = snapshot.data!;
                return CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, movieIndex) {
                    final movie = movies[index];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/original/${movie.backDropDepth}", // or movie.backdropPath
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              // backgroundColor: Colr
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 1.7,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Upcoming Movies Section
            const Center(
              child:  Text(
                "Coming Movies",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Movie>>(
                future: upComing,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final movies = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieTile(movie: movies[index]);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Popular Movies Section
            const Center(
              child: const Text(
                "Popular Movies",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Movie>>(
                future: popular,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final movies = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieTile(movie: movies[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: const Text("Movie List", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Movie>>(
                future: allMovies,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final movies = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieTile(movie: movies[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: const Text("Drama List", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Movie>>(
                future: drama,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final movies = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieTile(movie: movies[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
