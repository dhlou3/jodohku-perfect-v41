class TaarufQuestion {
  final int index;
  final String category;
  final String question;

  TaarufQuestion({
    required this.index,
    required this.category,
    required this.question,
  });
}

class TaarufData {
  // LOGIC: The 30 Progressive Taaruf Questions
  static final List<TaarufQuestion> questions = [
    TaarufQuestion(index: 1, category: 'Basics', question: 'Apakah matlamat utama anda dalam mencari pasangan di Jodohku?'),
    TaarufQuestion(index: 2, category: 'Basics', question: 'Bagaimanakah rutin harian anda (pekerjaan & masa lapang)?'),
    TaarufQuestion(index: 3, category: 'Personality', question: 'Apakah 3 sifat murni yang anda paling hargai dalam diri seseorang?'),
    // ... Simplified for Phase 4 core integration
    TaarufQuestion(index: 4, category: 'Faith', question: 'Bagaimanakah pandangan anda tentang solat berjemaah di rumah?'),
    TaarufQuestion(index: 5, category: 'Faith', question: 'Apakah impian anda untuk mendidik anak-anak dalam persekitaran Islam?'),
    TaarufQuestion(index: 6, category: 'Finance', question: 'Bagaimanakah anda menguruskan kewangan keluarga (perkongsian atau tunggal)?'),
    // ... 30 questions logic will be fully populated in Phase 5 hardening
  ];

  static TaarufQuestion getQuestion(int index) {
    return questions.firstWhere((q) => q.index == index, orElse: () => questions[0]);
  }
}
