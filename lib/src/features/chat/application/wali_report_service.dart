import 'package:cloud_functions/cloud_functions.dart';
import 'package:jodohku_malaysia/src/features/chat/domain/chat_models.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/auth/application/firestore_service.dart';

class WaliReportService {
  static Future<void> generateAndSendReport(ChatSession session, MemberProfile partnerProfile) async {
    final myProfile = await FirestoreService.getProfile();
    if (myProfile == null || myProfile.waliEmail == null) return;

    print('--- INITIATING WALI REPORT CLOUD CALL ---');
    
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateWaliReport');
      
      final result = await callable.call({
        'sessionId': session.id,
        'partnerId': partnerProfile.id ?? 'JDK_PARTNER_99',
        'myId': myProfile.id ?? 'JDK_USER_123',
      });

      if (result.data['success'] == true) {
        print('✅ Cloud Report Success: ${result.data['message']}');
      }
    } catch (e) {
      print('❌ Cloud Report Error: $e');
    }
    
    print('--- OPERATION COMPLETED ---');
  }
}
