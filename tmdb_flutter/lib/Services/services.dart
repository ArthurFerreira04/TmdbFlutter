import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tmdb_flutter/Model/model.dart';

const apiKey = "8f9e12707813ac21626ea699edc4b71e";

class APIsevices {
  final nowShowApi = "https://api.themoviedb.org/3/movie/now_playing";

  Future<List<Movie>> getNowShowing() async {
    Uri url = Uri.parse(nowShowApi);
    final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
        return movies;
      } else {
        throw Exception("Faile to load data");
      }
  }
}
