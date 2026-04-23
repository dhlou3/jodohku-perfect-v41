class ToxicFilter {
  // 🛡️ THE LEAKAGE SHIELD: Advanced Patterns
  static final RegExp _phoneRegex = RegExp(r'(\+?6?01)[0-9-\s]{7,10}|([0-9\s]{9,12})');
  static final RegExp _socialHandleRegex = RegExp(r'(@[a-zA-Z0-9._]+)|(instagram|facebook|tiktok|snapchat|tele|whatsapp|wasap|wsap|ws|fb|ig|tele)\b', caseSensitive: false);
  static final RegExp _urlRegex = RegExp(r'(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

  // "SNEAKY" PATTERNS (Words for numbers)
  static const List<String> _sneakyNumbers = [
    'kosong', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'lapan', 'sembilan',
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'
  ];

  static const List<String> _intentBlacklist = [
    'vulgar1', 'vulgar2',
    'dating-casually', 'looking-to-date',
    'one-night', 'no-marriage', 'just-fun', 'no-wali',
    'hookup', 'casual', 'not-into-marriage', 'pm tepi', 'pm ja'
  ];

  static bool isSafe(String text) {
    if (text.isEmpty) return true;
    final lower = text.toLowerCase();
    
    // 1. HARDENED PHONE DETECTION
    if (_phoneRegex.hasMatch(text.replaceAll(RegExp(r'\s+'), ''))) {
      return false; 
    }

    // 2. SNEAKY WORD-NUMBER DETECTION (If more than 5 number-words appear)
    int count = 0;
    for (var word in _sneakyNumbers) {
      if (lower.contains(word)) count++;
    }
    if (count >= 5) return false;

    // 3. SOCIAL/LINK DETECTION
    if (_socialHandleRegex.hasMatch(lower) || _urlRegex.hasMatch(lower)) {
      return false;
    }

    // 4. INTENT / PM TEPI DETECTION
    for (var word in _intentBlacklist) {
      if (lower.contains(word)) return false;
    }

    return true;
  }

  static String getErrorMessage(String text) {
    if (isSafe(text)) return '';
    return 'Amaran: Perkongsian info hubungan peribadi @ terma tidak sopan adalah dilarang demi keselamatan anda.';
  }
}
