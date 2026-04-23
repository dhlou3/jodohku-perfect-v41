// LIVE FIREBASE CONFIGURATION
const firebaseConfig = {
    apiKey: "AIzaSyBZegwZmiUsddDY1-EcB27NYwuvxobkgx8",
    authDomain: "jodohku-61096.firebaseapp.com",
    projectId: "jodohku-61096",
    storageBucket: "jodohku-61096.firebasestorage.app",
    messagingSenderId: "982535553679",
    appId: "1:982535553679:web:b7146ace7d99475ce126fa",
    measurementId: "G-H9L7YLG1SW"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();

let curLng = 'en';

function showV(id) {
    document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    
    // Set active tab
    if(id === 'vUtama') document.getElementById('nHomeTab').classList.add('active');
    if(id === 'vExplore') document.getElementById('nExpTab').classList.add('active');
    if(id === 'vChat') document.getElementById('nChatTab').classList.add('active');
    if(id === 'vIslam') document.getElementById('nIslamTab').classList.add('active');
    if(id === 'vProfile') document.getElementById('nMeTab').classList.add('active');
}

function toggleLng() {
    curLng = curLng === 'ms' ? 'en' : 'ms';
    updateUI();
}

function updateUI() {
    const data = translations[curLng];
    const langTog = document.getElementById('langTog');
    if (langTog) langTog.innerText = curLng === 'ms' ? 'MS | EN' : 'EN | MS';
    
    for (let key in data) {
        const el = document.getElementById(key);
        if (el) {
            if (el.tagName === 'INPUT') el.placeholder = data[key];
            else el.innerText = data[key];
        }
    }
}

// PERSISTENCE LOGIC (CLOUD POWERED)
async function handleLogin() {
    const name = document.getElementById('rNameInp').value || "Guest User";
    const email = document.getElementById('rEmailInp').value || "guest@jodohku.com";
    const uid = 'JDK-2024-' + Math.floor(1000 + Math.random() * 9000);
    
    const userData = {
        id: uid,
        name: name,
        email: email,
        lastSeen: firebase.firestore.FieldValue.serverTimestamp()
    };
    
    try {
        // Save to Cloud Firestore
        await db.collection("users").doc(uid).set(userData);
        localStorage.setItem('jodohku_session_id', uid);
        loadSession();
    } catch (e) {
        console.error("Error saving to Cloud:", e);
        // Fallback to demo mode if Firestore rules are not set
        localStorage.setItem('jodohku_user_manual', JSON.stringify(userData));
        loadSession();
    }
}

async function loadSession() {
    const sessionId = localStorage.getItem('jodohku_session_id');
    const manualUser = JSON.parse(localStorage.getItem('jodohku_user_manual'));
    
    if (sessionId) {
        try {
            const doc = await db.collection("users").doc(sessionId).get();
            if (doc.exists) {
                const data = doc.data();
                updateDashboard(data.id, data.name);
                return;
            }
        } catch (e) { console.log("Cloud sync pending..."); }
    }
    
    if (manualUser) {
        updateDashboard(manualUser.id, manualUser.name);
    } else {
        showV('vLanding');
    }
}

function updateDashboard(id, name) {
    const metaId = document.querySelector('.card-meta h2');
    const metaDesc = document.querySelector('.card-meta p');
    if (metaId) metaId.innerText = id;
    if (metaDesc) metaDesc.innerText = name + ' • Active Now';
    showV('vUtama');
}

function logout() {
    localStorage.removeItem('jodohku_session_id');
    localStorage.removeItem('jodohku_user_manual');
    location.reload();
}

// Initial sync
window.addEventListener('DOMContentLoaded', () => {
    updateUI();
    loadSession();
});
