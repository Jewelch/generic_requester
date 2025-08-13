import '../../utils/debugging_printer.dart';

class NoDataToDecodeException implements Exception {
  NoDataToDecodeException() {
    Debugger.red('You should provide either some mocking data or a real response to be treated');
  }
}

class UnsupportedDataTypeException implements Exception {
  UnsupportedDataTypeException() {
    Debugger.red('Unsupported data type encountered during decoding.');
  }
}

class JsonParsingException implements Exception {
  JsonParsingException() {
    Debugger.red('An error has Occured during JSON parsing process');
  }
}

class MappingException implements Exception {
  final dynamic type;
  final dynamic error;
  final StackTrace stackTrace;

  MappingException(this.type, this.error, this.stackTrace) {
    Debugger.red('Failed to construct $type from the provided response.\nError: $error');
    Debugger.red(stackTrace.toString());
  }
}
