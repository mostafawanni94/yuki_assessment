/// All SWAPI endpoint paths.
/// Const-correct: compile-time constants only.
abstract final class ApiUrl {
  static const String planets = 'planets/';
  static String planet(int id) => 'planets/$id/';
  static const String films = 'films/';
  static String film(int id) => 'films/$id/';
}
