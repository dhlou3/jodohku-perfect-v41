import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/chat/application/chat_notifier.dart';
import 'package:jodohku_malaysia/src/features/chat/domain/chat_models.dart';
import 'package:jodohku_malaysia/src/features/chat/presentation/chat_conversation_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF7), // Web --bg-cream
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'SEMBANG ELITE',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGold,
            letterSpacing: 1,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              labelColor: AppColors.primaryGold,
              unselectedLabelColor: const Color(0xFF9CA3AF),
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 13),
              tabs: const [
                Tab(text: 'PADANAN'),
                Tab(text: 'SEMBANG'),
                Tab(text: 'WALI'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPadananTab(),
          _buildSembangTab(sessions),
          _buildWaliTab(),
        ],
      ),
    );
  }

  Widget _buildPadananTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            'MULA PADAN SEKARANG',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSembangTab(List<ChatSession> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              'TIADA SEMBANG AKTIF',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildChatItem(session);
      },
    );
  }

  Widget _buildWaliTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛡️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 24),
            Text(
              'ZON PENJAGA (WALI)',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sesi taaruf yang dipantau oleh Wali akan dipaparkan di sini untuk keselamatan mutlak.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: AppTheme.vibrantButton,
              child: const Text('DAFTAR WALI'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatSession session) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatConversationScreen(sessionId: session.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF9F4),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
              ),
              child: const Center(child: Icon(Icons.person, color: AppColors.primaryGold, size: 30)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calon Jodoh Elite',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      Text(
                        '12:45 PM',
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mulakan taaruf dengan Bismillah...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'WALI AKTIF 🛡️',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
