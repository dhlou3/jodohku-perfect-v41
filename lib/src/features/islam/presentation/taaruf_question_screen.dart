import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class TaarufQuestionScreen extends StatefulWidget {
  const TaarufQuestionScreen({super.key});

  @override
  State<TaarufQuestionScreen> createState() => _TaarufQuestionScreenState();
}

class _TaarufQuestionScreenState extends State<TaarufQuestionScreen> {
  int _currentIdx = 0;
  final List<String> _questions = [
    'Apakah matlamat utama anda dalam hidup berumah tangga?',
    'Bagaimana anda menguruskan kewangan keluarga?',
    'Sejauh mana kepentingan agama dalam kehidupan seharian anda?',
    'Apakah pandangan anda tentang peranan suami dan isteri?',
    'Bagaimana hubungan anda dengan keluarga anda sendiri?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Soalan Taaruf', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)
        ),
      ),
      body: Column(
        children: [
          // PROGRESS STRIP (MAPPED FROM PROTOTYPE)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFFFDF9F4),
            child: Text(
              '30 soalan penting untuk mengenali calon lebih baik.',
              style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFFBD8B52), fontWeight: FontWeight.w600),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SOALAN ${_currentIdx + 1} DARIPADA 30',
                          style: GoogleFonts.outfit(
                            fontSize: 10, 
                            fontWeight: FontWeight.w800, 
                            color: const Color(0xFFBD8B52),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _questions[_currentIdx % _questions.length],
                          style: GoogleFonts.outfit(
                            fontSize: 18, 
                            color: const Color(0xFF333333), 
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          maxLines: 6,
                          style: const TextStyle(color: Color(0xFF333333)),
                          decoration: InputDecoration(
                            hintText: 'Tulis jawapan anda di sini...',
                            filled: true,
                            fillColor: const Color(0xFFF8F5F0),
                            hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16), 
                              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16), 
                              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16), 
                              borderSide: const BorderSide(color: Color(0xFFBD8B52), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  ElevatedButton(
                    onPressed: () => setState(() => _currentIdx++),
                    style: AppTheme.proButtonPrimary,
                    child: const Text('SETERUSNYA \u2192'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

