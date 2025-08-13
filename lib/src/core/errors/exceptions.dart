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
  final dynamic e;
  final StackTrace stackTrace;

  JsonParsingException(this.e, this.stackTrace) {
    Debugger.red('An error has Occured during JSON parsing process');
    Debugger.red(e.toString());
    Debugger.red(stackTrace.toString());
  }
}
