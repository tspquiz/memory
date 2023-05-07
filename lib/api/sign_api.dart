import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:memory/models/sign.dart';

/// Get a given number of random signs from lexicon.
Future<List<Sign>> getRandomSigns(int count) async {
  final url =
      'https://tspquiz.se/api/?action=random&count=$count&excludeUncommon=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw HttpException('Error ${response.statusCode}');
  }

  List<Sign> result = [];
  final list = json.decode(response.body);
  for (var item in list) {
    result.add(Sign(
      id: item['id'],
      word: item['word'],
      videoUrl: _getLexiconFullUrl(item['movie']),
    ));
  }

  return result;
}

String _getLexiconFullUrl(String partialUrl) {
  return 'https://teckensprakslexikon.su.se${partialUrl.startsWith('/') ? '' : '/'}$partialUrl';
}
