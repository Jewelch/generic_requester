import '../../generic_requester.dart' show Either;

//* Enums
enum RestfulMethods {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE"),
  patch("PATCH");

  final String name;

  const RestfulMethods(this.name);
}

//* TypeDefs
typedef FutureRequestResult<T> = Future<Either<Exception, T>>;
typedef StringKeyedMap = Map<String, dynamic>;
