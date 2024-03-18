part 'single_unit_map.dart';
part 'multi_unit_map.dart';
part 'diacritics_map.dart';

class StringCleanUtils {
  static const _symbolsRegexBase = r'''!"#$%&'()*+,\-.\/:;<=>?@[\]{}\\^_`~|@#$%^&*()-+=\[\]{}:;"'<>,?/`~!_''';

  /// Replaces diacritics & accents with original characters.
  static String normalize(String text) => String.fromCharCodes(replaceCodeUnits(text.runes));

  /// Removes symbols from text, eg. `!@#$%^&*()[]{}~"'?+-`.
  static String removeSymbols(String text) => text.replaceAll(RegExp("[$_symbolsRegexBase]+"), '');

  /// Same as [removeSymbols] but also removes whitespaces.
  static String removeSymbolsAndWhitespaces(String text) => text.replaceAll(RegExp("[$_symbolsRegexBase\\s]+"), '');

  /// Note: use `String.runes` to automatically combine surrogate units.
  static List<int> replaceCodeUnits(Iterable<int> codeUnits) {
    final result = <int>[];
    for (final original in codeUnits) {
      // Combining Diacritical Marks in Unicode
      if (original >= 0x0300 && original <= 0x036F) {
        continue;
      }

      // original diacritics-single
      final diacriticsingle = _diacriticsSingleLookup[original];
      if (diacriticsingle != null) {
        result.add(diacriticsingle);
        continue;
      }

      // original diacritics-multi
      final diacriticmultiple = _diacriticsMultiLookup[original];
      if (diacriticmultiple != null) {
        result.addAll(diacriticmultiple);
        continue;
      }

      // single-unit replacements
      final single = _singleUnitLookup[original];
      if (single != null) {
        result.add(single);
        continue;
      }

      // multi-unit replacements
      final multiple = _multiUnitLookup[original];
      if (multiple != null) {
        result.addAll(multiple);
        continue;
      }

      // no replacement
      result.add(original);
    }
    return result;
  }
}
