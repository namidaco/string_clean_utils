# A Dart library to remove/replace diacritics, accents, symbols & confusables from text

## Examples Usage

- Replaces diacritics & accents with original text
```dart
    final normalized = StringCleanUtils.normalize('𝒉𝒂𝒓𝒍𝒆𝒚𝒔 𝒊𝒏 𝒉𝒂𝒘𝒂𝒊𝒊 - 𝒌𝒂𝒕𝒚 𝒑𝒆𝒓𝒓𝒚');
    print(normalized); // 'harleys in hawaii - katy perry';

    final normalized2 = StringCleanUtils.normalize('𝑻𝒉𝒆 ℚ𝕦𝕚𝕔𝕜 Ｂｒｏｗｎ Fox 𝔍𝔲𝔪𝔭𝔢𝔡 ⓞⓥⓔⓡ ʇɥǝ 𝗟𝗮𝘇𝘆 𝙳𝚘𝚐');
    print(normalized2); // 'The Quick Brown Fox Jumped over the Lazy Dog';
```

- Remove symbols from text
```dart
    final normalized = StringCleanUtils.removeSymbols('The [Quick }Brown Fox %Jumped over ^the Lazy @Dog');
    print(normalized); // 'The Quick Brown Fox Jumped over the Lazy Dog';
```
  
- Remove symbols & whitespaces from text
```dart
    final normalized = StringCleanUtils.removeSymbolsAndWhitespaces('The [Quick }Brown Fox %Jumped over ^the Lazy @Dog');
    print(normalized); // 'TheQuickBrownFoxJumpedovertheLazyDog';
```


### Note
- confusable & diacritics rules are generated with [`confusable_to_map.dart`](./confusable_to_map.dart) relying on [`confusables.txt`](./confusables.txt) & [`diacritics.dart`](./diacritics.dart)
  - confusable source: https://www.unicode.org/Public/security/10.0.0/confusables.txt 
  - diacritics source: https://www.npmjs.com/package/diacritics-map