import 'package:dio/dio.dart';
import 'package:loadmore/results_model.dart';

Future getData(int page) async {
  print('httpClient loading page $page');
  try {
    dynamic response = await Dio().get(
        'https://api.themoviedb.org/3/discover/movie?api_key=26763d7bf2e94098192e629eb975dab0&page=$page&_limit=10');
    final data = Data.fromJson(response.data).results;
    return data;
  } catch (ex, st) {
    print(ex);
    print(st);
    return [];
  }
}
