import 'package:uuid/uuid.dart' show Uuid;

import '../../generic_requester.dart' show Either, DioException, HttpHeaders;

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
typedef FutureRequestResult<T> = Future<Either<DioException, T?>>;
typedef StringKeyedMap = Map<String, dynamic>;

//* Utilities
const _uuid = Uuid();
String uniqueIdentifier() => _uuid.v4();

//* Extensions
extension HeadersInjections on StringKeyedMap {
  StringKeyedMap setupContentType(String contentType) => this
    ..addAll(
      {HttpHeaders.contentTypeHeader: contentType},
    );

  StringKeyedMap setupAcceptedResponseTypeTo(String acceptedFormat) => this
    ..addAll(
      {HttpHeaders.acceptHeader: 'application/$acceptedFormat'},
    );

  StringKeyedMap addExtraHeaders(StringKeyedMap? extraHeaders) => this..addAll(extraHeaders ?? {});
}
