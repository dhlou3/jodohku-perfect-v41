export const Guard = {
    // 1. Strict Keyword Blacklist (illegal, bad words, outside app terms)
    forbidden: [
        'babi', 'anjing', 'pukimak', 'sial', 'pantat', 'bodoh', 'fuck', 'shit', 'sex', 'porn', 'scam', 'duit', 'money',
        'jual', 'beli', 'drug', 'dadah', 'mabuk', 'arak', 'dating', 'hookup', 'sugarbaby', 'sugaraddy'
    ],

    // 2. Patterns for Social Media and Contact Sharing
    outsidePatterns: {
        whatsapp: /(whatsapp|wsap|wsapp|wsp|vscap|vassap)/i,
        phone: /(\+?6?01[0-9](\s|-)?\d{3}(\s|-)?\d{4})|(\d{10,11})|([0]{1}[1]{1}[0-9]{1}[\s-]?\d{7,8})/,
        instagram: /(@[a-zA-Z0-9._]+)|(ig:|insta:|instagram:)/i,
        facebook: /(fb:|facebook:|fb.com)/i,
        telegram: /(tg:|tele:|telegram:|t.me)/i
    },

    /**
     * Contextual Scan - Detects intent to move outside or use bad language
     */
    async scan(text) {
        if (!text) return { clean: true, filtered: '' };
        const lower = text.toLowerCase().replace(/[\s.-]/g, ''); // Compact for pattern matching

        // -- RULE 1: STRICT WORD CHECK --
        let foundBad = this.forbidden.find(word => lower.includes(word));
        if (foundBad) {
            return {
                clean: false,
                error: "Mesej disekat: Sila gunakan bahasa yang sopan dan halal. Perkataan '"+foundBad+"' tidak dibenarkan.",
                filtered: "***"
            };
        }

        // -- RULE 2: OUTSIDE CONTACT CHECK (WHATSAPP/PHONE) --
        if (this.outsidePatterns.whatsapp.test(text) || this.outsidePatterns.phone.test(text)) {
            return {
                clean: false,
                error: "Mesej disekat: Anda dilarang berkongsi nombor telefon atau WhatsApp di sini demi keselamatan anda.",
                filtered: "[PRIVATE_CONTACT]"
            };
        }

        // -- RULE 3: SOCIAL MEDIA (IG/FB/TELE) --
        if (this.outsidePatterns.instagram.test(text) || this.outsidePatterns.facebook.test(text) || this.outsidePatterns.telegram.test(text)) {
            return {
                clean: false,
                error: "Mesej disekat: Sila fokus pada taaruf di dalam aplikasi sahaja. Perkongsian IG/FB/Telegram tidak dibenarkan.",
                filtered: "[SOCIAL_ACCOUNT]"
            };
        }

        // -- RULE 4: CONTEXTUAL INTENT (ILLEGAL/UNHALAL MEETUPS) --
        const intentKeywords = ['jumpa', 'meet', 'hotel', 'bilik', 'kamar', 'pay', 'bayar'];
        const suspiciousCount = intentKeywords.filter(w => lower.includes(w)).length;
        if (suspiciousCount >= 1 && (lower.includes('luar') || lower.includes('malam') || lower.includes('sekarang'))) {
             return {
                clean: false,
                error: "Mesej disekat: Perbualan ini dikesan mempunyai unsur 'pancingan' atau temu janji tidak sah. Kekalkan perbualan profesional.",
                filtered: "[SUSPICIOUS_CONTENT]"
            };
        }

        return { clean: true, filtered: text };
    }
};

window.Guard = Guard;
