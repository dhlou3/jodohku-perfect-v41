const fetch = require('node-fetch');

async function audit() {
    console.log("🔍 STARTING GENDER AUDIT...");
    try {
        const res = await fetch("https://firestore.googleapis.com/v1/projects/jodohku-61096/databases/(default)/documents/users?pageSize=100");
        const data = await res.json();
        
        if (!data.documents) {
            console.log("❌ No users found in DB.");
            return;
        }

        const stats = { man: 0, woman: 0, other: 0 };
        data.documents.forEach(doc => {
            const f = doc.fields || {};
            const gender = (f.gender?.stringValue || 'missing').toLowerCase();
            const name = f.fullName?.stringValue || 'Anonymous';
            
            if (gender === 'wanita' || gender === 'woman' || gender === 'perempuan') stats.woman++;
            else if (gender === 'lelaki' || gender === 'man') stats.man++;
            else stats.other++;

            console.log(`👤 ${name.padEnd(20)} | Gender: ${gender.padEnd(10)} | ID: ${doc.name.split('/').pop()}`);
        });

        console.log("\n📈 GENDER STATISTICS:");
        console.log(`👨 Men:   ${stats.man}`);
        console.log(`👩 Women: ${stats.woman}`);
        console.log(`❓ Other: ${stats.other}`);

    } catch (e) { console.log("🚨 AUDIT ERROR: " + e.message); }
}

audit();
