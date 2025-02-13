import 'package:uuid/uuid.dart';

import '../exports.dart';

//* Constants
const String applicationJsonContentType = 'application/json';
const String multipartFormDataContentType = 'multipart/form-data';

//* Enums
enum RestfullMethods { get, post, put, delete, patch }

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
