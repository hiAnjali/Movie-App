import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/model.dart';

const API_KEY = '694f62b775c4f88341cd4a6a0c27dffa';

class APIServices{
  final nowPlayingApi = 'https://api.themoviedb.org/3/movie/now_playing?api_key=$API_KEY';
  final upComingApi = "https://api.themoviedb.org/3/movie/popular?api_key=$API_KEY";
  final popularApi = "https://api.themoviedb.org/3/movie/upcoming?api_key=$API_KEY";
  final dramaApi = "https://api.themoviedb.org/3/discover/movie?api_key=$API_KEY&with_genres=18";
  final movieListApi = "https://api.themoviedb.org/3/discover/movie?api_key=$API_KEY";

  Future<List<Movie>> getPlaying() async{
    Uri url = Uri.parse(nowPlayingApi);
    final response = await http.get(url);
      if(response.statusCode == 200){
        final List<dynamic> data = json.decode(response.body)['results'];
        List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
        return movies;

      }else{
        throw Exception("failed to load data");
      }
    }
    //upcoming
  Future<List<Movie>> getUpComing() async{
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;

    }else{
      throw Exception("failed to load data");
    }
  }


// polpular
  Future<List<Movie>> getPopular() async{
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;

    }else{
      throw Exception("failed to load data");
    }
  }
  Future<List<Movie>> getDrama() async {
    Uri url = Uri.parse(dramaApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception("Failed to load drama movies");
    }
  }

  Future<List<Movie>> getAllMovies() async {
    Uri url = Uri.parse(movieListApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
}


