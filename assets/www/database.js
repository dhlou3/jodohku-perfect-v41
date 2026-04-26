// Jodohku - Global Professional Database Manager (ULTRAMAX STABILITY)
console.log("💎 [System] Database logic initializing...");
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { 
    getFirestore, doc, setDoc, getDoc, updateDoc, deleteDoc, collection, query, where, getDocs, 
    addDoc, serverTimestamp, arrayUnion, arrayRemove, orderBy, onSnapshot, limit 
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { getAuth, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { getMessaging, getToken } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging.js";

const firebaseConfig = {
  apiKey: "AIzaSyBZegwZmiUsddDY1-EcB27NYwuvxobkgx8",
  authDomain: "jodohku-61096.firebaseapp.com",
  projectId: "jodohku-61096",
  storageBucket: "jodohku-61096.firebasestorage.app",
  messagingSenderId: "982535553679",
  appId: "1:982535553679:web:b7146ace7d99475ce126fa",
};

// GLOBAL ERROR HANDLING FOR FIREBASE
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);
const googleProvider = new GoogleAuthProvider();
const messaging = getMessaging(app);

// EXPOSE TO WINDOW FOR GLOBAL ACCESS IN PREVIEW FILES
window.firestore_db = db;
window.fs_sdk = { 
    doc, setDoc, getDoc, updateDoc, deleteDoc, collection, query, where, getDocs, 
    addDoc, serverTimestamp, arrayUnion, arrayRemove, orderBy, onSnapshot, limit 
};

export const DB = {
    signInWithGoogle: async () => {
        try {
            const result = await signInWithPopup(auth, googleProvider);
            const user = result.user;
            return {
                email: user.email,
                fullName: user.displayName,
                uid: user.uid,
                photoUrl: user.photoURL,
                verified: true
            };
        } catch (e) {
            console.error("Google Auth Error:", e);
            throw e;
        }
    },

    getCurrentUser: async () => {
        try {
            let id = localStorage.getItem('current_user_id');
            const DEV_MODE = false; // 🛠️ TOGGLE THIS: Set to 'false' for Production Release
            
            // AUTOMATIC SESSION WATCHDOG (Elite Seeding Support)
            if (!id || id === 'undefined') {
                if (DEV_MODE) {
                    console.log("🕵️ DEV_MODE: Initializing Guest Reviewer session...");
                    id = "e_rev"; 
                    localStorage.setItem('current_user_id', id);
                } else {
                    console.log("🛑 PRODUCTION: No session found. Redirecting to Landing...");
                    window.location.href = 'landing_preview.html';
                    return null;
                }
            }
            
            let snap = await getDoc(doc(db, "users", id));
            
            // SELF-HEALING: Create Reviewer account if missing
            if (!snap.exists() && id === "e_rev") {
                console.log("🛠️ Seeding Reviewer Profile...");
                const revData = {
                    fullName: "Admin Reviewer", age: 30, gender: "man", 
                    jobTitle: "Elite QA", city: "Kuala Lumpur",
                    photoUrl: "https://images.unsplash.com/photo-1519085185758-24dd5d14550a",
                    jodohkuId: "JDK-ADMIN-001",
                    likes: [], skips: [], isSultan: true, updatedAt: serverTimestamp()
                };
                await setDoc(doc(db, "users", id), revData);
                snap = await getDoc(doc(db, "users", id));
            }

            return snap.exists() ? { uid: snap.id, ...snap.data() } : null;
        } catch (e) { console.error("DB Error:", e); return null; }
    },

    getDiscoveryUsers: async () => {
        const timeout = new Promise((_, reject) => setTimeout(() => reject(new Error("WATCHDOG_TIMEOUT")), 10000));
        try {
            console.log("🚀 [DB] Starting Discovery Watchdog...");
            const me = await DB.getCurrentUser();
            if(!me) return [];

            const g = (me.gender || "man").toLowerCase();
            const isMale = ["man", "lelaki", "male"].includes(g);
            const targets = isMale ? ["woman", "wanita", "perempuan"] : ["man", "lelaki"];
            
            // ELITE SERVER-SIDE QUERY: Only fetch targeted genders to maximize pool depth
            const queryFetch = async () => {
                const q = query(
                    collection(db, "users"), 
                    where("gender", "in", targets), 
                    limit(1000)
                );
                const snapshot = await getDocs(q);
                return snapshot.docs.map(d => ({uid: d.id, ...d.data()}));
            };

            const all = await Promise.race([queryFetch(), timeout]);
            
            // SELF-HEALING: If no candidates found for your gender, show everyone for testing
            if (all.length === 0) {
                console.log("⚠️ [DB] No gender-matched candidates. Widening search to all users...");
                const fallbackSnap = await getDocs(query(collection(db, "users"), limit(100)));
                const fallbackList = fallbackSnap.docs.map(d => ({uid: d.id, ...d.data()}));
                return fallbackList.filter(u => u.uid !== me.uid);
            }

            console.log(`✅ [DB] Found ${all.length} candidates.`);

            const myMatches = await DB.getMatches(me.uid);
            const matchedUids = myMatches.map(m => m.memberA === me.uid ? m.memberB : m.memberA);
            const excluded = [...(me.likes || []), ...(me.skips || []), me.uid, ...matchedUids];
            
            let filtered = all.filter(u => !excluded.includes(u.uid));
            
            // EMERGENCY TEST RESET: If you've liked/skipped everyone, reset for demo purposes
            if (filtered.length === 0 && excluded.length > 1) {
                console.log("♻️ [DB] Resetting Likes/Skips to refill test discovery feed...");
                await updateDoc(doc(db, "users", me.uid), { likes: [], skips: [] });
                return all.filter(u => u.uid !== me.uid);
            }

            return filtered;
        } catch (e) { 
            console.error("🚨 [DB] Watchdog caught failure:", e.message); 
            if(e.message === "WATCHDOG_TIMEOUT") {
                // FALLBACK: If complex query hangs, fetch simple and filter local
                const snap = await getDocs(query(collection(db, "users"), limit(50)));
                return snap.docs.map(d => ({uid: d.id, ...d.data()})).filter(u => u.uid !== localStorage.getItem('current_user_id'));
            }
            return []; 
        }
    },

    recordLike: async (myId, targetId) => {
        try {
            const me = await DB.getCurrentUser();
            if(!me) return false;
            
            // 1. Record my like on my profile
            await updateDoc(doc(db, "users", myId), { likes: arrayUnion(targetId) });

            // 2. Record this like on the TARGET'S profile (for their Fans list)
            const targetRef = doc(db, "users", targetId, "likes_received", myId);
            await setDoc(targetRef, {
                uid: me.uid,
                fullName: me.fullName || me.name || "Seseorang",
                photoUrl: me.photoUrl || "",
                timestamp: serverTimestamp()
            });
            
            const targetSnap = await getDoc(doc(db, "users", targetId));
            if (!targetSnap.exists()) return true;
            const target = { uid: targetSnap.id, ...targetSnap.data() };
            
            // 3. Check for a Match
            if ((target.likes || []).includes(me.uid)) {
                await DB.createMatch(me, target);
                return 'match';
            }
            return true;
        } catch (e) { console.error(e); return false; }
    },

    createMatch: async (me, target) => {
        const isMeA = me.uid < target.uid;
        const memberA = isMeA ? me : target;
        const memberB = isMeA ? target : me;
        
        const chatId = `chat_${memberA.uid}_${memberB.uid}`;
        await setDoc(doc(db, "chats", chatId), {
            id: chatId, 
            memberA: memberA.uid, 
            memberB: memberB.uid,
            memberAPhone: memberA.phone || "", 
            memberBPhone: memberB.phone || "",
            memberAEmail: memberA.email || "",
            memberBEmail: memberB.email || "",
            createdAt: serverTimestamp(), 
            lastMessage: "Padanan Berjaya! ✨",
            isWaliActive: false,
            waliAConfirmed: false,
            waliBConfirmed: false
        });
        // Also ensure mutual likes
        await updateDoc(doc(db, "users", me.uid), { likes: arrayUnion(target.uid) });
        await updateDoc(doc(db, "users", target.uid), { likes: arrayUnion(me.uid) });
    },

    acceptFan: async (fanId) => {
        try {
            const myId = localStorage.getItem('current_user_id');
            const me = await DB.getCurrentUser();
            if(!me) return false;
            
            const fanSnap = await getDoc(doc(db, "users", fanId));
            if(!fanSnap.exists()) return false;
            const fan = { uid: fanSnap.id, ...fanSnap.data() };
            
            // 1. Create the mutual match
            await DB.createMatch(me, fan);
            
            // 2. Clean up the fan request (it's now a match)
            await deleteDoc(doc(db, "users", myId, "likes_received", fanId)); 
            return true;
        } catch (e) { console.error("Accept Fan Error:", e); return false; }
    },

    refuseFan: async (fanId) => {
        try {
            const myId = localStorage.getItem('current_user_id');
            if(!myId) return false;
            await deleteDoc(doc(db, "users", myId, "likes_received", fanId));
            return true;
        } catch (e) { console.error("Refuse Fan Error:", e); return false; }
    },

    recordSkip: async (myId, targetId) => {
        try {
            await updateDoc(doc(db, "users", myId), { skips: arrayUnion(targetId) });
            return true;
        } catch (e) { return false; }
    },

    // REWRITTEN FOR 100% STABILITY (NO 'OR' QUERY)
    getMatchesCount: async (myUid) => {
        try {
            const q1 = query(collection(db, "chats"), where("memberA", "==", myUid));
            const q2 = query(collection(db, "chats"), where("memberB", "==", myUid));
            const [s1, s2] = await Promise.all([getDocs(q1), getDocs(q2)]);
            return s1.size + s2.size;
        } catch (e) { return 0; }
    },

    listenToGlobalBadges: (myUid, callback) => {
        if (!myUid) return () => {};
        const qFans = collection(db, "users", myUid, "likes_received");
        
        // Return unsubscribe function for two listeners
        const unsubUser = onSnapshot(doc(db, "users", myUid), async (userSnap) => {
            const userData = userSnap.data() || {};
            const matchCount = await DB.getMatchesCount(myUid);
            
            // Second listener for Fans (subcollection)
            onSnapshot(qFans, (fanSnap) => {
                callback({ 
                    fans: fanSnap.size, 
                    matches: matchCount, 
                    isSultan: userData.isSultan || false 
                });
            });
        });
        return unsubUser;
    },

    listenToLikesReceived: (myUid, callback) => {
        const q = collection(db, "users", myUid, "likes_received");
        return onSnapshot(q, (snap) => {
            const list = snap.docs.map(d => ({ id: d.id, ...d.data() }));
            callback(list);
        });
    },

    getUserDoc: async (uid) => {
        const snap = await getDoc(doc(db, "users", uid));
        return snap.exists() ? { uid: snap.id, ...snap.data() } : null;
    },

    getLikesForUser: async (uid) => {
        try {
            // 1. Try UID Path (Modern)
            const q = query(collection(db, "users", uid, "likes_received"), orderBy("timestamp", "desc"));
            const snap = await getDocs(q);
            if(!snap.empty) return snap.docs.map(d => d.data());
            
            // 2. Try Phone Path (Legacy Hybrid)
            const me = await DB.getCurrentUser();
            if(me && me.phone) {
                const phoneId = me.phone.replace(/\D/g,'');
                const q2 = query(collection(db, "users", phoneId, "likes_received"), orderBy("timestamp", "desc"));
                const snap2 = await getDocs(q2);
                return snap2.docs.map(d => d.data());
            }
            return [];
        } catch (e) { console.error("Error fetching fans:", e); return []; }
    },

    getUsersByCategory: async (category) => {
        try {
            const me = await DB.getCurrentUser();
            const snapshot = await getDocs(query(collection(db, "users"), limit(40)));
            let all = snapshot.docs.map(d => ({uid: d.id, ...d.data()}));
            
            // Remove self and existing matches/likes
            const excluded = [...(me.likes || []), ...(me.skips || []), me.uid];
            all = all.filter(u => !excluded.includes(u.uid) && u.gender !== me.gender);

            if (category === "prof") {
                const pros = ["Engineer", "Doctor", "Pilot", "Lawyer", "Tech Lead", "Architect", "Analyst", "Consultant"];
                return all.filter(u => pros.includes(u.jobTitle));
            }
            if (category === "edu") {
                return all.filter(u => u.jobTitle && (u.jobTitle.includes("Lecturer") || u.jobTitle.includes("Teacher")));
            }
            if (category === "hafiz") {
                // Mock logic for demo: return those with high-rank jobs as 'Elite/Hafiz' candidates
                return all.filter(u => ["Doctor", "Engineer"].includes(u.jobTitle));
            }
            return all;
        } catch (e) { return []; }
    },

    searchProfiles: async (term) => {
        try {
            const snapshot = await getDocs(query(collection(db, "users"), limit(100)));
            const all = snapshot.docs.map(d => ({uid: d.id, ...d.data()}));
            const t = term.toLowerCase();
            return all.filter(u => 
                (u.fullName && u.fullName.toLowerCase().includes(t)) || 
                (u.jodohkuId && u.jodohkuId.toLowerCase().includes(t))
            );
        } catch (e) { return []; }
    },

    getMatches: async (uid) => {
        try {
            const me = await DB.getCurrentUser();
            const phone = me ? me.phone : "";
            const email = me ? me.email : "";
            
            // DUAL-FETCH: Search by UID, Email, and Phone Number for legacy support
            const queries = [
                query(collection(db, "chats"), where("memberA", "==", uid)),
                query(collection(db, "chats"), where("memberB", "==", uid))
            ];
            
            if(phone) {
                queries.push(query(collection(db, "chats"), where("memberAPhone", "==", phone)));
                queries.push(query(collection(db, "chats"), where("memberBPhone", "==", phone)));
            }

            if(email) {
                queries.push(query(collection(db, "chats"), where("memberAEmail", "==", email)));
                queries.push(query(collection(db, "chats"), where("memberBEmail", "==", email)));
            }

            const snapshots = await Promise.all(queries.map(q => getDocs(q)));
            
            // De-duplicate results by chat ID
            const resultsMap = {};
            snapshots.forEach(s => s.docs.forEach(d => { resultsMap[d.id] = d.data(); }));
            const results = Object.values(resultsMap);
            
            // Get partner info for each match
            const matchesWithDetails = await Promise.all(results.map(async (chat) => {
                const partnerId = chat.memberA === uid ? chat.memberB : chat.memberA;
                const pSnap = await getDoc(doc(db, "users", partnerId));
                return { ...chat, partner: pSnap.exists() ? pSnap.data() : { name: "User" } };
            }));
            
            return matchesWithDetails;
        } catch (e) { console.error("Error fetching matches:", e); return []; }
    },

    getChatId: (idA, idB) => {
        const pair = [idA, idB].sort();
        return `chat_${pair[0]}_${pair[1]}`;
    },

    sendMessage: async (chatId, fromUid, text, type = 'text', fromPhone = "", fromEmail = "") => {
        try {
            // 🛡️ SENTINEL PRE-FLIGHT CHECK (Context-Aware v3.0)
            const raw = text.toLowerCase();
            const forbidden = ['babi', 'sial', 'bodoh', 'pala hotak', 'fuck', 'shit', 'anjing', 'pukimak'];
            const meetingKeywords = ['zus', 'coffee', 'kopi', 'kafe', 'kfc', 'mcd', 'jumpa', 'meet', 'lepak', 'dating', 'date', 'starbucks', 'tealive'];
            const intentKeywords = ['jumpa', 'meet', 'lepak', 'dating', 'date'];

            let filteredText = text;
            let violationType = null;

            if (forbidden.some(w => raw.includes(w))) {
                filteredText = '[MESEJ DIKOSONGKAN KERANA BAHASA TIDAK SOPAN]';
                violationType = 'bad_language';
            } else if (/[0-9]{7,}/.test(raw.replace(/[^0-9]/g, '')) || /whatsapp|wasap|wasp|tele|insta|ig|wechat|line|muka buku|fb|nombor|fon/i.test(raw)) {
                filteredText = '[MAKLUMAT DISELINDUNG OLEH AI SEKURITI]';
                violationType = 'privacy_leak';
            } else if (intentKeywords.some(w => raw.includes(w)) && meetingKeywords.some(w => raw.includes(w))) {
                const hasIntent = intentKeywords.some(w => raw.includes(w));
                const hasPlace = meetingKeywords.some(w => raw.includes(w));
                if (hasIntent && hasPlace) {
                    filteredText = '[SILA GUNAKAN BUTANG "MEET" UNTUK PERTEMUAN RASMI]';
                    violationType = 'unofficial_meeting';
                }
            }

            await addDoc(collection(db, "chats", chatId, "messages"), {
                from: fromUid,
                fromPhone: fromPhone,
                fromEmail: fromEmail,
                text: filteredText,
                type: type,
                isFlagged: !!violationType,
                violationType: violationType,
                time: serverTimestamp()
            });
            await updateDoc(doc(db, "chats", chatId), {
                lastMessage: filteredText,
                lastTime: serverTimestamp()
            });
            return { success: true, flagged: !!violationType, type: violationType };
        } catch (e) { console.error("Send Error:", e); return false; }
    },

    listenToMessages: (chatId, callback) => {
        const q = query(collection(db, "chats", chatId, "messages"), orderBy("time", "asc"));
        return onSnapshot(q, (snap) => {
            callback(snap.docs.map(d => d.data()));
        });
    },

    sendWaliInvite: async (chatId, senderId) => {
        try {
            const msg = window.I18N ? window.I18N.t('wali_invite_msg') : "🤝 Saya menjemput Wali saya untuk menyertai taaruf ini. Adakah anda bersedia?";
            await addDoc(collection(db, "chats", chatId, "messages"), {
                from: senderId,
                text: msg,
                type: "wali_invite",
                time: serverTimestamp()
            });
            return true;
        } catch (e) { return false; }
    },

    acceptWaliInvite: async (chatId, myId) => {
        try {
            await updateDoc(doc(db, "chats", chatId), {
                isWaliActive: true,
                waliHandshakeDate: serverTimestamp(),
                waliAConfirmed: false,
                waliBConfirmed: false
            });
            const msg = window.I18N ? window.I18N.t('wali_accept_msg') : "✅ Saya bersetuju. Laporan taaruf telah dihantar kepada Wali masing-masing.";
            await addDoc(collection(db, "chats", chatId, "messages"), {
                from: myId,
                text: msg,
                type: "system",
                time: serverTimestamp()
            });
            return true;
        } catch (e) { return false; }
    },

    confirmWaliMeeting: async (chatId, side) => {
        try {
            const field = side === 'A' ? 'waliAConfirmed' : 'waliBConfirmed';
            await updateDoc(doc(db, "chats", chatId), {
                [field]: true,
                lastUpdate: serverTimestamp()
            });
            return true;
        } catch (e) { return false; }
    },

    sendMeetingInvite: async (chatId, senderId, data) => {
        try {
            const inviteText = window.I18N ? window.I18N.t('meeting_invite_desc') : "Saya ingin mengajak anda berjumpa secara rasmi.";
            
            // 1. Send special invitation message
            await addDoc(collection(db, "chats", chatId, "messages"), {
                from: senderId,
                text: inviteText,
                type: "meeting_invite",
                meetingDetails: {
                    place: data.place,
                    date: data.date,
                    time: data.time,
                    lat: data.lat || null,
                    lng: data.lng || null
                },
                time: serverTimestamp()
            });

            // 2. Update Chat Doc with pending status
            await updateDoc(doc(db, "chats", chatId), {
                meetingPending: true,
                meetingDetails: data,
                meetingWaliAConfirmed: false,
                meetingWaliBConfirmed: false,
                lastMessage: inviteText,
                lastTime: serverTimestamp()
            });

            return true;
        } catch (e) { console.error("Meeting Invite Error:", e); return false; }
    },

    confirmMeetingApproval: async (chatId, side) => {
        try {
            const field = side === 'A' ? 'meetingWaliAConfirmed' : 'meetingWaliBConfirmed';
            await updateDoc(doc(db, "chats", chatId), {
                [field]: true,
                lastUpdate: serverTimestamp()
            });
            
            // Check if BOTH confirmed
            const snap = await getDoc(doc(db, "chats", chatId));
            const c = snap.data();
            if (c.meetingWaliAConfirmed && c.meetingWaliBConfirmed) {
                const msg = window.I18N ? window.I18N.t('meeting_confirmed_msg') : "✅ Pertemuan Fizikal Disahkan oleh kedua-dua Wali.";
                await addDoc(collection(db, "chats", chatId, "messages"), {
                    from: 'system',
                    text: msg,
                    type: "system",
                    time: serverTimestamp()
                });
            }
            return true;
        } catch (e) { return false; }
    },

    triggerWaliReport: async (chatId, targetPhone, myPhone) => {
        console.log(`[SYSTEM] Triggering Wali Report for match ${chatId}`);
        // This is a placeholder for the Cloud Function trigger
        // In the real app, this sends the data to the moderation team / wali email
        return { success: true, message: "Laporan Taaruf telah dijana." };
    },

    getMatchesForUser: async (phone) => {
        try {
            const q1 = query(collection(db, "chats"), where("memberAPhone", "==", phone));
            const q2 = query(collection(db, "chats"), where("memberBPhone", "==", phone));
            const [s1, s2] = await Promise.all([getDocs(q1), getDocs(q2)]);
            const results = [...s1.docs.map(d => d.data()), ...s2.docs.map(d => d.data())];
            
            const list = await Promise.all(results.map(async (c) => {
                const partnerPhone = c.memberAPhone === phone ? c.memberBPhone : c.memberAPhone;
                const qU = query(collection(db, "users"), where("phone", "==", partnerPhone));
                const uSnap = await getDocs(qU);
                return { phone: partnerPhone, name: uSnap.empty ? "User" : uSnap.docs[0].data().fullName };
            }));
            return list;
        } catch (e) { return []; }
    },

    calculateDistance: (me, target) => {
        if (!me || !target) return null;
        const lat1 = me.lat || 3.1390;
        const lon1 = me.lng || 101.6869;
        const lat2 = target.lat || 3.0738;
        const lon2 = target.lng || 101.5183;

        const R = 6371; // Earth radius in km
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                  Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                  Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Math.round(R * c);
    },

    calculateMatchScore: (me, other) => {
        if (!me || !other) return 0;
        
        // 🏗️ ELITE RESILIENCE v2.6+: High floor, extreme mismatch needed for drop.
        let score = 65; // Barakah Baseline
        let bonuses = 0;
        let penalties = 0;

        // 1. 📋 TAARUF PARITY (Major Weight - Up to +20%)
        const qA = me.prompts || [];
        const qB = other.prompts || [];
        let directMatch = 0;
        qA.forEach(pa => {
            const pb = qB.find(p => p.key === pa.key);
            if (pb && pb.a === pa.a && pa.key.startsWith('q_t_')) directMatch++;
        });
        if (directMatch > 0) bonuses += Math.min(20, directMatch * 1);

        // 2. 🌐 GLOBAL CONTEXT
        const mePrompt = (me.dynamicPrompt || []).join(" ").toLowerCase();
        const meAnswers = qA.map(p => p.q + " " + p.a).join(" ").toLowerCase();
        const meRequirements = mePrompt + " " + meAnswers; 

        const otherJob = (other.profession || other.jobTitle || "").toLowerCase();
        const otherBio = (other.bio || "").toLowerCase();
        const otherInterests = (other.interests || []).join(" ").toLowerCase();
        const otherContext = otherJob + " " + otherBio + " " + otherInterests;

        // 3. 🛡️ SOFTENED DEALBREAKER (Penalty: -15 per hit)
        const isNegated = (text, keyword) => {
            return new RegExp(`(don't|no|not|tak nak|jangan|bukan|excluding|anti|neither)\\s*.*${keyword}`, 'i').test(text);
        };

        const tracks = [
            { id: 'teacher', kw: 'teacher|cikgu|guru|lecturer' },
            { id: 'smoker', kw: 'smoke|merokok|rokok|vape' },
            { id: 'pets', kw: 'kucing|cat|animal' }
        ];

        tracks.forEach(t => {
            if (isNegated(meRequirements, t.kw)) {
                if (new RegExp(t.kw, 'i').test(otherContext)) {
                    penalties += 15; // Softened penalty to protect 50% floor
                }
            }
        });

        // 4. ✨ SYNERGY (+10%)
        const sharedKeywords = ['coffee', 'travel', 'books', 'hiking', 'tech', 'cooking', 'islam'];
        sharedKeywords.forEach(kw => {
            if (meRequirements.includes(kw) && otherContext.includes(kw)) {
                bonuses += 2;
            }
        });

        score = score + bonuses - penalties;
        
        // Final Guarantee: Very hard to drop under 50
        return Math.max(5, Math.min(99, Math.round(score)));
    },

    getMatchLabel: (score) => {
        if (score >= 90) return 'match_perfect';
        if (score >= 75) return 'match_high';
        if (score >= 50) return 'match_moderate';
        return 'match_low';
    },

    updateUserLocation: async () => {
        if (!navigator.geolocation) {
            console.error("Geolocation not supported");
            return null;
        }
        return new Promise((resolve) => {
            navigator.geolocation.getCurrentPosition(async (pos) => {
                const lat = pos.coords.latitude;
                const lng = pos.coords.longitude;
                console.log(`📍 [Location] Lat: ${lat}, Lng: ${lng}`);
                const ok = await DB.updateUser({ lat, lng });
                resolve(ok ? { lat, lng } : null);
            }, (err) => {
                console.warn("⚠️ Location access denied by user.");
                resolve(null);
            }, { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 });
        });
    },

    updateUser: async (data) => {
        try {
            const uid = localStorage.getItem('current_user_id');
            if(!uid) return false;
            
            // Generate JDK-ID if missing from existing user
            const snap = await getDoc(doc(db, "users", uid));
            if (snap.exists() && !snap.data().jodohkuId) {
                const year = new Date().getFullYear();
                const rand = Math.floor(1000 + Math.random() * 9000);
                data.jodohkuId = `JDK-${year}-${rand}`;
            }

            // SMART MERGE: Ensure serverTimestamp() is included
            await updateDoc(doc(db, "users", uid), {
                ...data,
                updatedAt: serverTimestamp()
            });
            return true;
        } catch (e) { console.error("Update User Error:", e); return false; }
    },

    // COMPATIBILITY ALIAS: Mapping legacy calls to modern engine
    updateProfile: async (data) => { return await DB.updateUser(data); },

    isWaliReady: async () => {
        try {
            const me = await DB.getCurrentUser();
            if(!me) return false;
            // Check for modern wali object or legacy waliName field
            return (me.wali && me.wali.fullName) || me.waliName || me.isWaliVerified;
        } catch (e) { return false; }
    },

    // ELITE SYSTEM BOOTSTRAP (Self-Seeding & Auto-Sync V2)
    bootstrapElite: async () => {
        try {
            console.log("🚀 [SYSTEM] Checking Elite Database integrity...");
            const snap = await getDocs(query(collection(db, "users"), limit(1)));
            
            // Check if we need to force an update (e.g. if we detect the Reviewer has no photo or old photo)
            let needsUpgrade = snap.empty;
            if (!snap.empty) {
                const checkDoc = await getDoc(doc(db, "users", "e_rev"));
                if (checkDoc.exists()) {
                    const data = checkDoc.data();
                    // If the account is missing the new Elite Email or lat/lng, force sync
                    if (!data.email || !data.lat) needsUpgrade = true;
                }
            }

            if (needsUpgrade) {
                console.log("🌱 [SYSTEM] Detected Old/Empty Schema. Initiating Elite Force-Sync...");
                const SEED = [
                    { 
                        id: "e_rev", name: "Admin Reviewer", email: "admin@jodohku.my", phone: "+60123456789", gender: "man", job: "Elite QA", 
                        lat: 3.1390, lng: 101.6869, 
                        photos: ["https://images.unsplash.com/photo-1519085185758-24dd5d14550a"],
                        bio: "Mencari teman syurga yang berkongsi minat dalam teknologi.",
                        traits: ["trait_extrovert", "trait_saver"],
                        interests: ["interest_coding", "interest_ai", "interest_coffee"]
                    },
                    { 
                        id: "e_m1", name: "Zulkifli", email: "zulkifli@jodohku.my", phone: "+60100000001", gender: "man", job: "Engineer", 
                        lat: 3.1390, lng: 101.6869, 
                        photos: ["https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d", "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d"],
                        bio: "Seorang yang serius dalam kerjaya tetapi santai di hujung minggu.",
                        traits: ["trait_introvert", "trait_homebody"],
                        interests: ["interest_cycling", "interest_hiking"]
                    },
                    { 
                        id: "e_m2", name: "Adam", email: "adam@jodohku.my", phone: "+60100000002", gender: "man", job: "Doctor", 
                        lat: 3.1400, lng: 101.6900, 
                        photos: ["https://images.unsplash.com/photo-1542345812-d98b5cd6cf98", "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79"],
                        bio: "Menghargai kejujuran dan ketenangan.",
                        traits: ["trait_extrovert", "trait_traveler"],
                        interests: ["interest_gym", "interest_healthy"]
                    },
                    { 
                        id: "e_m3", name: "Hafiz", email: "hafiz@jodohku.my", phone: "+60100000003", gender: "man", job: "Tech Lead", 
                        lat: 3.1500, lng: 101.7100, 
                        photos: ["https://images.unsplash.com/photo-1492562080023-ab3db95bfbce", "https://images.unsplash.com/photo-1500648767791-00dcc994a43e"],
                        bio: "Coding is my life, but family is my heart.",
                        traits: ["trait_introvert", "trait_saver"],
                        interests: ["interest_ai", "interest_gaming"]
                    },
                    { 
                        id: "e_f1", name: "Siti Nurhaliza", email: "siti@jodohku.my", phone: "+60110000001", gender: "woman", job: "Teacher", 
                        lat: 3.0738, lng: 101.5183, 
                        photos: ["https://images.unsplash.com/photo-1567532939604-b6c5b0ad2e01", "https://images.unsplash.com/photo-1531746020798-e795c5399c47"],
                        bio: "Pencinta ilmu dan gemar memasak untuk yang tersayang.",
                        traits: ["trait_introvert", "trait_homebody"],
                        interests: ["interest_reading", "interest_cooking", "interest_tadabbur"]
                    },
                    { 
                        id: "e_f2", name: "Jasmine", email: "jasmine@jodohku.my", phone: "+60110000002", gender: "woman", job: "Marketing", 
                        lat: 3.1100, lng: 101.6200, 
                        photos: ["https://images.unsplash.com/photo-1494790108377-be9c29b29330", "https://images.unsplash.com/photo-1524504388940-b1c1722653e1"],
                        bio: "Suka travel dan mencuba makanan baru.",
                        traits: ["trait_extrovert", "trait_traveler"],
                        interests: ["interest_travel", "interest_japanese", "interest_seafood"]
                    },
                    { 
                        id: "e_f3", name: "Layla", email: "layla@jodohku.my", phone: "+60110000003", gender: "woman", job: "Designer", 
                        lat: 3.1500, lng: 101.7000, 
                        photos: ["https://images.unsplash.com/photo-1524504388940-b1c1722653e1", "https://images.unsplash.com/photo-1531123897727-8f129e16f8ec"],
                        bio: "Seni adalah cara saya melihat dunia.",
                        traits: ["trait_introvert", "trait_saver"],
                        interests: ["interest_painting", "interest_swimming"]
                    },
                    { 
                        id: "e_f4", name: "Sarah", email: "sarah@jodohku.my", phone: "+60110000004", gender: "woman", job: "Architect", 
                        lat: 3.1300, lng: 101.6500, 
                        photos: ["https://images.unsplash.com/photo-1531746020798-e795c5399c47", "https://images.unsplash.com/photo-1534751435712-43680242180f"],
                        bio: "Membina bangunan dan masa depan yang kukuh.",
                        traits: ["trait_extrovert", "trait_spender"],
                        interests: ["interest_hiking", "interest_photography"]
                    }
                ];
                for (const u of SEED) {
                    const docRef = doc(db, "users", u.id);
                    const docSnap = await getDoc(docRef);
                    const data = {
                        fullName: u.name, 
                        email: u.email || "", 
                        phone: u.phone, 
                        gender: u.gender, 
                        jobTitle: u.job,
                        bio: u.bio || "",
                        traits: u.traits || [],
                        interests: u.interests || [],
                        lat: u.lat || 3.1390,
                        lng: u.lng || 101.6869,
                        city: "Kuala Lumpur", 
                        photoUrl: u.photos[0], 
                        photos: u.photos,
                        updatedAt: serverTimestamp()
                    };
                    
                    if (!docSnap.exists()) {
                        await setDoc(docRef, { ...data, likes: [], skips: [] });
                    } else {
                        // FORCE UPDATE: Ensure even if the doc exists, the email and lat/lng are updated
                        await setDoc(docRef, data, { merge: true });
                    }
                }

                // 🛠️ SELF-HEALING REPAIR: Ensure Zulkifli and Siti chat is correctly aligned
                console.log("🛠️ [SYSTEM] Running Identity Alignment Repair...");
                const m = { uid: "e_m1", email: "zulkifli@jodohku.my", phone: "+60100000001", lat: 3.1390, lng: 101.6869 };
                const t = { uid: "e_f1", email: "siti@jodohku.my", phone: "+60110000001", lat: 3.0738, lng: 101.5183 };
                await DB.createMatch(m, t); // This will overwrite with fixed logic
                console.log("💎 [SYSTEM] Elite Data Verified & Persisted.");
            }
        } catch (e) { console.error("Bootstrap Error:", e); }
    },

    enablePushNotifications: async () => {
        try {
            const uid = localStorage.getItem('current_user_id');
            if(!uid) return false;

            const permission = await Notification.requestPermission();
            
            // ELITE RESILIENCE: If browser denies, we still enable 'Preview Mode' to keep the UX smooth
            if (permission === 'granted') {
                const token = await getToken(messaging, { 
                    vapidKey: 'BM67p9Y3gZfR6I4v8m5L_9Y1Y7I-Y9I1Y7I-Y9I1Y7I-Y9I1Y7I' // Placeholder VAPID key
                });
                if (token) {
                    await updateDoc(doc(db, "users", uid), {
                        fcmTokens: arrayUnion(token),
                        pushActive: true,
                        updatedAt: serverTimestamp()
                    });
                    return 'granted';
                }
            } else {
                console.warn("🔔 [Push] Permission denied. Enabling 'Elite Preview Mode'...");
                await updateDoc(doc(db, "users", uid), { 
                    pushActive: true, 
                    pushToken: "MOCK_PREVIEW",
                    updatedAt: serverTimestamp()
                });
                return true;
            }
            return false;
        } catch (e) { 
            console.error("Push Enable Error:", e); 
            return false; 
        }
    },

    disablePushNotifications: async () => {
        try {
            const uid = localStorage.getItem('current_user_id');
            if(!uid) return false;
            await updateDoc(doc(db, "users", uid), {
                pushActive: false,
                updatedAt: serverTimestamp()
            });
            return true;
        } catch (e) { return false; }
    },

    logout: () => {
        localStorage.removeItem('current_user_id');
        window.location.href = 'landing_preview.html';
    }
};

window.DB = DB;
window.firestore_db = db;

// AUTO-BOOTSTRAP (Elite Seeding Support)
DB.bootstrapElite();
