class IcParserResult {
  final int age;
  final String gender;
  final String birthState;

  IcParserResult({
    required this.age,
    required this.gender,
    required this.birthState,
  });
}

class IcService {
  static const Map<String, String> _stateCodes = {
    '01': 'Johor', '02': 'Kedah', '03': 'Kelantan', '04': 'Melaka', 
    '05': 'Negeri Sembilan', '06': 'Pahang', '07': 'Pulau Pinang', 
    '08': 'Perak', '09': 'Perlis', '10': 'Selangor', '11': 'Terengganu', 
    '12': 'Sabah', '13': 'Sarawak', '14': 'Kuala Lumpur', '15': 'Labuan', 
    '16': 'Putrajaya'
  };

  // CORE LOGIC: Parsing the 12-digit MyKad
  static IcParserResult? parse(String ic) {
    String cleanIc = ic.replaceAll(RegExp(r'[-\s]'), '');
    if (cleanIc.length != 12) return null;

    try {
      // 1. Birth Date Extraction
      int yy = int.parse(cleanIc.substring(0, 2));
      int mm = int.parse(cleanIc.substring(2, 4));
      int dd = int.parse(cleanIc.substring(4, 6));
      
      // Calculate Full Year
      DateTime now = DateTime.now();
      int currentYShort = now.year % 100;
      int fullY = (yy <= currentYShort) ? 2000 + yy : 1900 + yy;

      // Calculate Age
      int age = now.year - fullY;
      if (now.month < mm || (now.month == mm && now.day < dd)) age--;

      // 2. Birth State Detection
      String stateCode = cleanIc.substring(6, 8);
      String state = _stateCodes[stateCode] ?? 'Luar Negara / Unknown';

      // 3. Gender Detection
      int lastDigit = int.parse(cleanIc[11]);
      String gender = (lastDigit % 2 != 0) ? 'Lelaki' : 'Perempuan';

      return IcParserResult(age: age, gender: gender, birthState: state);
    } catch (e) {
      return null;
    }
  }
}
