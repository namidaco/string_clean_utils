// ignore_for_file: non_constant_identifier_names

import 'dart:io';

part 'diacritics.dart';

extension _ListUtils<E> on List<E> {
  void loop(void Function(E e) fn) {
    final length = this.length;
    for (int i = 0; i < length; i++) {
      fn(this[i]);
    }
  }
}

void main() {
  final lines = File('confusables.txt').readAsLinesSync();

  final singleUnitLookup = <int, int>{};
  final multiUnitLookup = <int, List<int>>{}; // holds an accent converted to multiple characters.
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
  // -- fixing: replace M
  final mLetterAccents = <String>["118E3", "006D", "217F", "1D426", "1D45A", "1D48E", "1D4C2", "1D4F6", "1D52A", "1D55E", "1D592", "1D5C6", "1D5FA", "1D62E", "1D662", "1D696", "11700"];
  final mLetterCodeUnit = 'm'.codeUnits.first;
  mLetterAccents.loop((e) {
    final accent = int.parse(e, radix: 16);
    singleUnitLookup[accent] = mLetterCodeUnit;
  });

  // numbers/others looks like l, we remove completely
  final lAccentsToRemove = [
    "05C0", "007C", "2223", "23FD", "FFE8", "0031", "0661", "06F1", "10320", //
    "1E8C7", "1D7CF", "1D7D9", "1D7E3", "1D7ED", "1D7F7", "217C", "05D5", //
    "05DF", "0627", "1EE00", "1EE80", "FE8E", "FE8D", "07CA", "1028A",
  ];
  lAccentsToRemove.loop((e) {
    final accent = int.parse(e, radix: 16);
    singleUnitLookup.remove(accent);
  });

  // letts converted to L instead of I
  final lAccentsToI = [
    "0049", "FF29", "2160", "1D408", "1D43C", "1D470", "1D4D8", "1D540", "1D574", "1D5A8", //
    "1D5DC", "1D610", "1D644", "1D678", "0196", "01C0", "0399", "1D6B0", "1D6EA", "1D724", //
    "1D75E", "1D798", "2C92", "0406", "04C0", "2D4F", "16C1", "A4F2", "16F28", "10309"
  ];
  final ILetterCodeUnit = 'I'.codeUnits.first;
  lAccentsToI.loop((e) {
    final accent = int.parse(e, radix: 16);
    singleUnitLookup[accent] = ILetterCodeUnit;
  });

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
