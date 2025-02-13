import '../../generic_requester.dart';
import '../extensions/iterable_ext.dart';
import '../utils/pretty_dio_logger.dart';
import 'decoder.dart';

/// #### A Generic request performer based on a smart Dio Interceptor
class RequestPerformer {
  static final _backgroundTransformer = BackgroundTransformer();

  static void configure(
    BaseOptions baseOptions, {
    QueuedInterceptorsWrapper? interceptor,
    bool debugginActivated = false,
    bool mockingEnabled = false,
  }) {
    _baseOptions = baseOptions;
    _interceptor = interceptor;
    _debugginActivated = debugginActivated;
    _mockingEnabled = mockingEnabled;
  }

  static final Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
  };

  static late BaseOptions _baseOptions;
  static late QueuedInterceptorsWrapper? _interceptor;
  static bool _debugginActivated = false;
  static bool _mockingEnabled = false;

  final _decoder = GenericResponseDecoder();

  /// ### A generic method that consumes an API and handles automatic data serialization/mocking
  Future<R?> performDecodingRequest<R, MP extends ModelingProtocol>({
    required MP decodableModel,
    final bool mockIt = false,
    final bool debugIt = true,
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
  }) async {
    //! Dio definition
    final dio = Dio(
      _baseOptions
        ..baseUrl = baseUrl ?? _baseOptions.baseUrl
        ..contentType = contentType
        ..headers.addAll(headers)
        ..headers.addAll(extraHeaders ?? {}),
    );

    //! Interceptor setup
    dio.interceptors
      ..clear()
      ..addBasedOnCondition(
        condition: !kReleaseMode,
        _interceptor,
      )
      ..addBasedOnCondition(
        condition: _debugginActivated || debugIt,
        PrettyDioLogger.instance,
      );

    //! Background transformer setup
    dio.transformer = _backgroundTransformer;

    //! Mocking setup
    if (_mockingEnabled || mockIt) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _decoder.decode<MP>(
        decodableModel,
        mockingData: decodableModel.mockingData,
        mocking: true,
      ) as R;
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
        .then((response) => _decoder.decode<MP>(decodableModel, response: response));
  }
}
