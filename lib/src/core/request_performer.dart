import '../../generic_requester.dart';
import '../extensions/iterable_ext.dart';
import '../utils/pretty_dio_logger.dart';
import 'decoder.dart';

/// #### A Generic request performer based on a smart Dio Interceptor
class RequestPerformer with GenericResponseDecoder {
  final Dio dio;

  RequestPerformer(this.dio);

  @visibleForTesting
  RequestPerformer.mockWith(this.dio);

  static final Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
  };

  static final _backgroundTransformer = BackgroundTransformer();

  static void configure(
    BaseOptions baseOptions, {
    QueuedInterceptorsWrapper? interceptor,
    bool debuggingEnabled = false,
    bool mockingEnabled = false,
    final int mockingDurationInMs = 500,
  }) {
    _baseOptions = baseOptions;
    _interceptor = interceptor;
    _debuggingEnabled = debuggingEnabled;
    _mockingEnabled = mockingEnabled;
    _mockingDuration = mockingDurationInMs;
  }

  static late BaseOptions _baseOptions;
  static late QueuedInterceptorsWrapper? _interceptor;
  static bool _debuggingEnabled = false;
  static bool _mockingEnabled = false;
  static int _mockingDuration = 500;

  /// ### A generic method that consumes an API and handles automatic data serialization/mocking
  Future<Either<Exception, R>> performDecodingRequest<R, MP extends ModelingProtocol>({
    required MP decodableModel,
    final bool mockIt = false,
    final bool debugIt = true,
    final bool simulateFailure = false,
    required RestfulMethods method,
    String? baseUrl,
    required String path,
    final dynamic body,
    final Options? options,
    final String? contentType,
    final StringKeyedMap? extraHeaders,
    final StringKeyedMap? queryParameters,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
    final dynamic mockingData,
  }) async {
    if (simulateFailure) {
      return Future.delayed(
        Duration(milliseconds: _mockingDuration),
      ).then((_) => Left(Exception('Simulated failure')));
    }

    //! Dio definition
    dio.options = BaseOptions(
      baseUrl: baseUrl ?? _baseOptions.baseUrl,
      contentType: contentType,
      headers: headers..addAll(extraHeaders ?? {}),
    );

    //! Interceptor setup
    dio.interceptors
      ..clear()
      ..addBasedOnCondition(
        condition: !kReleaseMode,
        _interceptor,
      )
      ..addBasedOnCondition(
        condition: _debuggingEnabled || debugIt,
        PrettyDioLogger.instance,
      );

    //! Background transformer setup
    dio.transformer = _backgroundTransformer;

    //! Mocking setup
    if (_mockingEnabled || mockIt) {
      return Future.delayed(
        Duration(milliseconds: _mockingDuration),
      ).then(
        (_) => (decode<MP>(
          decodableModel,
          mockingData: mockingData,
          mocking: true,
        )).fold((e) => Left(e), (r) => Right(r as R)),
      );
    }

    //! Request execution
    return dio
        .request(
          path,
          data: body,
          queryParameters: queryParameters,
          options: DioMixin.checkOptions(method.name, options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((response) => decode<MP>(decodableModel, response: response).fold(
              (e) => Left(e),
              (r) => Right(r as R),
            ));
  }
}
