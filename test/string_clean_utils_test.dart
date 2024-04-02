import 'package:flutter_test/flutter_test.dart';

import 'package:string_clean_utils/string_clean_utils.dart';

void main() {
  test('Replaces diacritics & accents from text', () {
    final normalized = StringCleanUtils.normalize('𝒉𝒂𝒓𝒍𝒆𝒚𝒔 𝒊𝒏 𝒉𝒂𝒘𝒂𝒊𝒊 - 𝒌𝒂𝒕𝒚 𝒑𝒆𝒓𝒓𝒚');
    const expected = 'harleys in hawaii - katy perry';
    expect(normalized, expected);
  });

  test('Replaces diacritics & accents from text', () {
    final normalized = StringCleanUtils.normalize('𝑻𝒉𝒆 ℚ𝕦𝕚𝕔𝕜 Ｂｒｏｗｎ Fox 𝔍𝔲𝔪𝔭𝔢𝔡 ⓞⓥⓔⓡ ʇɥǝ 𝗟𝗮𝘇𝘆 𝙳𝚘𝚐');
    const expected = 'The Quick Brown Fox Jumped over the Lazy Dog';
    expect(normalized, expected);
  });

  test('Remove symbols from text', () {
    final normalized = StringCleanUtils.removeSymbols('The [Quick }Brown Fox %Jumped over ^the Lazy @Dog');
    const expected = 'The Quick Brown Fox Jumped over the Lazy Dog';
    expect(normalized, expected);
  });
  test('Remove symbols & whitespaces from text', () {
    final normalized = StringCleanUtils.removeSymbolsAndWhitespaces('The [Quick }Brown Fox %Jumped over ^the Lazy @Dog');
    const expected = 'TheQuickBrownFoxJumpedovertheLazyDog';
    expect(normalized, expected);
  });
  test('Ensure main letters are not changed', () {
    const lower = 'qwertyuiopasdfghjklzxcvbnm';
    const upper = 'QWERTYUIOPASDFGHJKLZXCVBNM';
    expect(lower, StringCleanUtils.normalize(lower));
    expect(upper, StringCleanUtils.normalize(upper));
  });
}
