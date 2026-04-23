import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/chat/application/chat_notifier.dart';
import 'package:jodohku_malaysia/src/features/chat/domain/chat_models.dart';
import 'package:jodohku_malaysia/src/features/chat/presentation/chat_conversation_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Sembang Taaruf', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: Color(0xFFBD8B52)), 
            onPressed: () {}
          ),
        ],
      ),
      body: sessions.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => ChatConversationScreen(sessionId: session.id))
                ),
                child: _ChatItem(session: session),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 64, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Tiada sembang aktif.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final ChatSession session;

  const _ChatItem({required this.session});

  @override
  Widget build(BuildContext context) {
    final bool hasWali = session.waliId != null;
    final String lastMessage = session.messages.isNotEmpty 
        ? session.messages.last.content 
        : 'Mulakan taaruf dengan Bismillah...';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          // AVATAR
          Container(
            width: 55, height: 55,
            decoration: const BoxDecoration(color: Color(0xFFFDF9F4), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Color(0xFFBD8B52)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taaruf Session #${session.id.substring(session.id.length - 4)}', 
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
                ),
                const SizedBox(height: 4),
                // LOGIC: STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasWali ? AppColors.shariaGreen.withOpacity(0.1) : const Color(0xFFBD8B52).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hasWali ? 'WALI DIPANTAU' : 'WALI DIPERLUKAN', 
                    style: GoogleFonts.outfit(
                      fontSize: 8, 
                      color: hasWali ? AppColors.shariaGreen : const Color(0xFFBD8B52), 
                      fontWeight: FontWeight.w900,
                    )
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lastMessage, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF666666))
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


