import 'dart:developer' show log;

abstract final class Debugger {
  static const String _prefix = '\x1B[';
  static const String _suffix = '${_prefix}0m';

  static void black(text) => log('${_prefix}30m$text$_suffix');

  static void yellow(text) => log('${_prefix}33;1m\x1B[5m$text$_suffix');

  static void orange(text) => log('${_prefix}33m$text$_suffix');

  static void red(text) => log('${_prefix}31m$text$_suffix');

  static void green(text) => log('${_prefix}32m$text$_suffix');

  static void blue(text) => log('${_prefix}34m$text$_suffix');

  static void magenta(text) => log('${_prefix}35;1m\x1B[5m$text$_suffix');

  static void cyan(text) => log('${_prefix}36m$text$_suffix');

  static void white(text) => log('${_prefix}37m$text$_suffix');
}
