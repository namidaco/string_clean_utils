import 'dart:io';

part 'diacritics.dart';

void main() {
  final lines = File('confusables.txt').readAsLinesSync();

  final singleUnitLookup = <int, int>{};
  final multiUnitLookup = <int, List<int>>{};
  for (int i = 0; i < lines.length; i++) {
    final parts = lines[i].split(' ;	');
    if (parts.length < 2) continue;

    try {
      final accent = int.parse(parts[0].trim(), radix: 16);
      final baseUnits = parts[1].trim().split(' ');

      if (baseUnits.length == 1) {
        final base = int.parse(baseUnits.first, radix: 16);
        singleUnitLookup[accent] = base;
      } else {
        final bases = baseUnits.map((e) => int.parse(e, radix: 16)).toList();
        multiUnitLookup[accent] = bases;
      }
    } catch (_) {}
  }

  // -- fixing
  final mLetterAccents = <String>["118E3", "006D", "217F", "1D426", "1D45A", "1D48E", "1D4C2", "1D4F6", "1D52A", "1D55E", "1D592", "1D5C6", "1D5FA", "1D62E", "1D662", "1D696", "11700"];
  final mLetterCodeUnit = 'm'.codeUnits.first;
  for (int i = 0; i < mLetterAccents.length; i++) {
    final accent = int.parse(mLetterAccents[i], radix: 16);
    singleUnitLookup[accent] = mLetterCodeUnit;
  }

  const autogen = '/// AUTO GENERATED USING confusable_to_map.dart, DO NOT EDIT MANUALLY.';
  const partOf = "part of 'string_clean_utils.dart';";

  /// -- single units
  final singleUnitFile = File('lib/src/single_unit_map.dart');
  singleUnitFile.createSync(recursive: true);
  singleUnitFile.writeAsStringSync('''
$autogen

$partOf

final _singleUnitLookup = $singleUnitLookup;
''');

  /// -- multi units
  final multiUnitFile = File('lib/src/multi_unit_map.dart');
  multiUnitFile.createSync(recursive: true);
  multiUnitFile.writeAsStringSync('''
$autogen

$partOf

final _multiUnitLookup = $multiUnitLookup;
''');

  /// -- diacritics
  final newDiacriticsSingleMap = <int, int>{};
  final newDiacriticsMultipleMap = <int, List<int>>{};
  for (final e in _diacriticsMap.entries) {
    final accentUnit = e.key.codeUnits.first;
    final baseUnits = e.value.codeUnits;
    if (baseUnits.length == 1) {
      newDiacriticsSingleMap[accentUnit] = baseUnits.first;
    } else {
      newDiacriticsMultipleMap[accentUnit] = baseUnits;
    }
  }
  final diacriticsFile = File('lib/src/diacritics_map.dart');
  diacriticsFile.createSync(recursive: true);
  diacriticsFile.writeAsStringSync('''
$autogen

$partOf

final _diacriticsSingleLookup = $newDiacriticsSingleMap;

final _diacriticsMultiLookup = $newDiacriticsMultipleMap;
''');
}
