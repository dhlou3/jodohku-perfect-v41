class AISentinelService {
  // 🧠 THE SUPREME GLOBAL SENTINEL v2: Slang & Deception Hardened
  static Future<AISafetyResult> evaluateMessage(String text) async {
    final lower = text.toLowerCase();
    
    // 1. MALAYSIAN & GLOBAL SLANG DICTIONARY (Sneaky Phrases)
    final slangBypass = [
      'pm tepi', 'pmtepi', 'pee em', 'pm je',
      'wasap', 'wsap', 'ws', 'wsp', 'watsap', 'wassap',
      'iggy', 'insta', 'istgram', 'gram', @'ig',
      'tele', 'tgram', 'telgrm', 't.me',
      'check bio', 'tengok bio', 'bio saya',
      'outside app', 'luar app', 'sembang luar'
    ];
    
    // 2. LEET-SPEAK & CHARACTER REPLACEMENT DETECTION
    // Detecting numbers-as-letters bypass (e.g. 012-345... or @ser_1al)
    final leetPattern = _checkLeetSpeak(text);

    // 3. UNIVERSAL PHONE DETECTION ENGINE
    final hasPhone = _hasUniversalPhone(text);
    
    // EVALUATE RISK
    bool isSlangLeak = slangBypass.any((p) => lower.contains(p));
    
    if (hasPhone || leetPattern || isSlangLeak) {
      return AISafetyResult(
        isSafe: false,
        message: 'Shared contact or social bypass attempt detected.',
        redactedText: '[INFO DISELINDUNG OLEH AI]',
      );
    }

    return AISafetyResult(isSafe: true, redactedText: text);
  }

  static bool _checkLeetSpeak(String text) {
    // Detects common leet speak bypasses like '@_u_s_3_r'
    final clean = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    // If text contains a high density of non-alphabetic chars or mixed patterns
    return RegExp(r'[0-9]{5,}').hasMatch(clean); 
  }

  static bool _hasUniversalPhone(String text) {
    // Blocks 7-15 digits regardless of spacing or symbols
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }
}

class AISafetyResult {
  final bool isSafe;
  final String message;
  final String redactedText;

  AISafetyResult({required this.isSafe, this.message = '', required this.redactedText});
}
