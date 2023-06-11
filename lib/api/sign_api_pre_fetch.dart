
import 'package:memory/api/sign_api.dart';
import 'package:memory/models/sign.dart';

class SignApiPreFetch extends Api {
  Map<int,Future<List<Sign>>> fetches = {};

  /// Start loading random signs of given count
  void preFetch(int count) {
    if (!fetches.containsKey(count)) {
      fetches[count] = super.getRandomSigns(count);
    }
  }

  /// Obtain promise to a query for [count] number
  /// of random words.
  @override
  Future<List<Sign>> getRandomSigns(int count) {
    if (!fetches.containsKey(count)) {
      preFetch(count);
    }
    return fetches.remove(count)!;
  }
}