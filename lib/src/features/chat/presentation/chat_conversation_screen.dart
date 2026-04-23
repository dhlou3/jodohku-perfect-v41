import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/chat/application/chat_notifier.dart';
import 'package:jodohku_malaysia/src/features/chat/data/taaruf_questions.dart';
import 'package:jodohku_malaysia/src/features/chat/domain/chat_models.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ChatConversationScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends ConsumerState<ChatConversationScreen> {
  final TextEditingController _msgBot = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // LOGIC: Selecting the active session
    final sessions = ref.watch(chatProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    final bool hasWali = session.waliId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sesi Taaruf', style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(hasWali ? '💂 Dimantau Wali' : '⚠️ Wali Belum Ditambah', style: TextStyle(color: hasWali ? Colors.green : Colors.orange, fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(onPressed: () => _showWaliSetup(context), icon: const Icon(Icons.person_add_alt, color: Color(0xFFBD8B52))),
          IconButton(onPressed: () {}, icon: const Icon(Icons.flag_outlined, color: Colors.redAccent)),
        ],
      ),
      body: Column(
        children: [
          // 30 QUESTIONS PROGRESS (PHASE 4 CORE)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFBD8B52).withOpacity(0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PROGRES TAARUF', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFBD8B52))),
                    Text('${session.currentQuestionIndex}/30', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: session.currentQuestionIndex / 30, backgroundColor: Colors.white, valueColor: const AlwaysStoppedAnimation(Color(0xFFBD8B52))),
              ],
            ),
          ),

          // MESSAGE LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: session.messages.length,
              itemBuilder: (context, index) {
                final msg = session.messages[index];
                return _MessageBubble(msg: msg);
              },
            ),
          ),

          // THE GUIDED PICKER
          _buildQuestionPicker(session),

          // THE MEETING PANEL
          _buildMeetPanel(session),

          // INPUT BAR
          _buildInputBar(session),
        ],
      ),
    );
  }

  Widget _buildMeetPanel(ChatSession session) {
    if (session.meetStatus == MeetStatus.accepted) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        border: Border.all(color: const Color(0xFFBD8B52).withOpacity(0.1)),
      ),
      child: session.meetStatus == MeetStatus.none
          ? Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.handshake_outlined, color: Color(0xFFBD8B52)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sudah sedia untuk berjumpa?',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.read(chatProvider.notifier).requestMeeting(session.id, 'me'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD8B52),
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Hantar Jemputan Berjumpa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          : Column(
              children: [
                const Text('🤝 Jemputan Berjumpa Menunggu Jawapan...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tolak', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => ref.read(chatProvider.notifier).acceptMeeting(session.id, 'me'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Terima', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }

  Widget _buildQuestionPicker(ChatSession session) {
    if (session.currentQuestionIndex >= TaarufData.questions.length) return const SizedBox();
    
    final nextQ = TaarufData.getQuestion(session.currentQuestionIndex + 1);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBD8B52).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CADANGAN SOALAN SETERUSNYA:', style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFFBD8B52))),
          const SizedBox(height: 8),
          Text(nextQ.question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ref.read(chatProvider.notifier).sendMessage(session.id, 'me', 'SOALAN TAARUF #${nextQ.index}: ${nextQ.question}');
              ref.read(chatProvider.notifier).advanceQuestion(session.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBD8B52),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Tanya Soalan Ini', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ChatSession session) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgBot,
              decoration: InputDecoration(
                hintText: 'Tulis mesej taaruf...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: const Color(0xFFF8F5F0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_msgBot.text.isNotEmpty) {
                ref.read(chatProvider.notifier).sendMessage(session.id, 'me', _msgBot.text);
                _msgBot.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFBD8B52), shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showWaliSetup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, size: 48, color: Color(0xFFBD8B52)),
            const SizedBox(height: 16),
            Text('Tambah Wali', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Wali akan menerima jemputan untuk memantau sesi taaruf ini.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(decoration: AppTheme.glassInput('No. Telefon Wali').copyWith(fillColor: Colors.black12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(chatProvider.notifier).attachWali(widget.sessionId, 'wali_123');
                Navigator.pop(context);
              },
              style: AppTheme.vibrantButton,
              child: const Text('Hantar Jemputan'),
            )
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final bool isMe = msg.senderId == 'me';
    
    // SPECIAL RENDERING FOR SYSTEM/MEET MESSAGES
    if (msg.type == MessageType.meetRequest || msg.type == MessageType.meetAccepted) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: msg.type == MessageType.meetAccepted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: msg.type == MessageType.meetAccepted ? Colors.green : Colors.orange),
          ),
          child: Column(
            children: [
              Icon(
                msg.type == MessageType.meetAccepted ? Icons.verified_user : Icons.notification_important,
                color: msg.type == MessageType.meetAccepted ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 8),
              Text(
                msg.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: msg.type == MessageType.meetAccepted ? Colors.green[800] : Colors.orange[800],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFBD8B52) : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
          ),
          border: isMe ? null : Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Text(
          msg.content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
