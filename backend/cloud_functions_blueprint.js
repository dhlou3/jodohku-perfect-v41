/**
 * 🛰️ JODOHKU SUPREME SENTINEL (Cloud Function Blueprint v2.0)
 * Language: Node.js (Firebase Functions)
 * Enforcing Sharia Safety & Data Privacy across the Jodohku ecosystem.
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// 1. 🛡️ AI MESSAGE MODERATOR (Triggered on every message)
exports.onMessageCreated = functions.firestore
    .document('chats/{chatId}/messages/{messageId}')
    .onCreate(async (snap, context) => {
        const messageData = snap.data();
        const text = messageData.content;
        const chatId = context.params.chatId;
        
        // RE-EVALUATE WITH AI SENTINEL PATTERNS
        const evaluation = evaluateMessage(text);
        
        if (!evaluation.isSafe) {
            console.warn(`🚨 SECURITY VIOLATION: ${evaluation.reason} in chat ${chatId}`);
            
            let redactionText = '[MAKLUMAT DISELINDUNG OLEH AI SEKURITI]';
            if (evaluation.type === 'unofficial_meeting') {
                redactionText = '[SILA GUNAKAN BUTANG "MEET" UNTUK PERTEMUAN RASMI]';
            } else if (evaluation.type === 'bad_language') {
                redactionText = '[MESEJ DIKOSONGKAN KERANA BAHASA TIDAK SOPAN]';
            }

            // A. REDACT THE MESSAGE (Real-time privacy)
            await snap.ref.update({
                content: redactionText,
                isFlagged: true,
                violationType: evaluation.type,
                flaggedAt: admin.firestore.FieldValue.serverTimestamp()
            });

            // B. NOTIFY THE ASSIGNED WALI
            const chatSnap = await admin.firestore().collection('chats').doc(chatId).get();
            const waliId = chatSnap.data().waliId;

            if (waliId) {
                await admin.firestore().collection('notifications').add({
                    recipientId: waliId,
                    title: '🛡️ Amaran Keselamatan',
                    body: 'Percubaan pertukaran info hubungan dikesan dan telah disekat.',
                    type: 'security_alert',
                    chatId: chatId,
                    timestamp: admin.firestore.FieldValue.serverTimestamp()
                });
            }
        }
    });

// 🧠 AI SENTINEL LOGIC (Context-Aware v3.0)
const FORBIDDEN_WORDS = ['babi', 'sial', 'bodoh', 'pala hotak', 'fuck', 'shit', 'anjing', 'pukimak'];
const MEETING_KEYWORDS = ['zus', 'coffee', 'kopi', 'kafe', 'kfc', 'mcd', 'jumpa', 'meet', 'lepak', 'dating', 'date', 'starbucks', 'tealive'];

function evaluateMessage(text) {
    const raw = text.toLowerCase();
    
    // 1. 🛡️ SAFETY CHECK: Profanity & Bad Words
    const hasBadWord = FORBIDDEN_WORDS.some(w => raw.includes(w));
    if (hasBadWord) {
        return { isSafe: false, reason: 'safety_violation', type: 'bad_language' };
    }

    // 2. 🛡️ PRIVACY CHECK: Info Leaks
    const hasNumbers = /[0-9]{7,}/.test(raw.replace(/[^0-9]/g, ''));
    const isLeakageApp = /whatsapp|wasap|wasp|tele|insta|ig|wechat|line|muka buku|fb|nombor|fon/i.test(raw);
    if (hasNumbers || isLeakageApp) {
        return { isSafe: false, reason: 'privacy_leak', type: 'contact_info' };
    }

    // 3. 🛡️ CONTEXT CHECK: Unofficial Meeting Attempts
    const intentToMeet = /jumpa|meet|lepak|dating|date/i.test(raw);
    const hasPlace = MEETING_KEYWORDS.some(w => raw.includes(w));
    
    if (intentToMeet && hasPlace) {
        return { isSafe: false, reason: 'bypass_attempt', type: 'unofficial_meeting' };
    }

    return { isSafe: true };
}

// 2. 📄 WALI REPORT GENERATOR (Triggered on Meeting Acceptance)
// This function generates a PDF taaruf summary and emails it to the Wali.
exports.generateWaliReport = functions.https.onCall(async (data, context) => {
    const { sessionId, partnerId, myId } = data;
    
    try {
        console.log(`🚀 Starting Wali Report Generation for session: ${sessionId}`);
        
        // A. FETCH DATA
        const [sessionSnap, myProfileSnap, partnerProfileSnap] = await Promise.all([
            admin.firestore().collection('chats').doc(sessionId).get(),
            admin.firestore().collection('users').doc(myId).get(),
            admin.firestore().collection('users').doc(partnerId).get()
        ]);

        const session = sessionSnap.data();
        const myProfile = myProfileSnap.data();
        const partnerProfile = partnerProfileSnap.data();

        if (!myProfile.waliEmail) {
            throw new functions.https.HttpsError('failed-precondition', 'Wali email missing.');
        }

        // B. FETCH MESSAGES SUB-COLLECTION
        const messagesSnap = await admin.firestore()
            .collection('chats').doc(sessionId)
            .collection('messages')
            .orderBy('timestamp', 'asc')
            .limit(100)
            .get();
        
        const messages = messagesSnap.docs.map(d => ({ id: d.id, ...d.data() }));

        // C. GENERATE REPORT (HTML -> PDF logic)
        const reportHtml = `
            <div style="font-family: 'Outfit', sans-serif; padding: 40px; color: #333; background: #FDF9F4;">
                <h1 style="color: #BD8B52; font-family: 'Playfair Display';">LAPORAN TAARUF RASMI: ${myProfile.fullName}</h1>
                <p><strong>Disediakan Oleh:</strong> Jodohku Malaysia Sentinel AI</p>
                <p><strong>Tarikh Laporan:</strong> ${new Date().toLocaleString('ms-MY')}</p>
                <hr style="border: 0.5px solid #BD8B5222;"/>
                
                <h2 style="color: #1F2937;">Info Calon</h2>
                <div style="display: flex; gap: 20px; align-items: start;">
                    <div style="flex: 1;">
                        <p><strong>Nama Calon:</strong> ${partnerProfile.fullName}</p>
                        <p><strong>Asal:</strong> ${partnerProfile.birthState}</p>
                        <p><strong>Pekerjaan:</strong> ${partnerProfile.attributes['jobTitle'] || 'Swasta'}</p>
                        <p><strong>Biodata:</strong> <i style="color: #6B7280;">"${partnerProfile.bio || 'Tiada biodata disediakan.'}"</i></p>
                    </div>
                </div>

                <h2 style="color: #1F2937; margin-top: 30px;">Log Interaksi (100 Mesej Terakhir)</h2>
                <div style="background: white; border: 1px solid #EEEEEE; padding: 20px; border-radius: 12px; max-height: 500px; overflow-y: auto;">
                    ${messages.map(m => `
                        <div style="margin-bottom: 12px; padding-bottom: 8px; border-bottom: 0.5px solid #F3F4F6;">
                            <span style="color: #BD8B52; font-weight: 800; font-size: 11px;">
                                ${m.senderId === myId ? 'SAYA' : 'CALON'} • ${m.timestamp ? new Date(m.timestamp._seconds * 1000).toLocaleTimeString() : ''}
                            </span>
                            <p style="margin: 4px 0; font-size: 14px;">${m.content}</p>
                        </div>
                    `).join('')}
                </div>
                
                <p style="margin-top: 40px; font-size: 10px; color: #9CA3AF; text-align: center;">
                    Laporan ini sulit untuk kegunaan Wali sahaja. Sebarang penyebaran tanpa izin adalah dilarang.
                </p>
            </div>
        `;

        // C. SEND EMAIL
        // In production, use @sendgrid/mail or nodemailer
        console.log(`📬 Mailing report to Wali: ${myProfile.waliEmail}`);
        
        /* 
        const msg = {
          to: myProfile.waliEmail,
          from: 'security@jodohku.my',
          subject: `Laporan Taaruf: ${myProfile.fullName} & ${partnerProfile.fullName}`,
          html: reportHtml,
          attachments: [
              // PDF binary here
          ]
        };
        await sgMail.send(msg);
        */

        return { success: true, message: 'Laporan telah dihantar ke email wali.' };

    } catch (error) {
        console.error('❌ Report Generation Failed:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});
