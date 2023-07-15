const fs = require('fs');

const password = fs.readFileSync('./pass', encoding='utf-8');

function authenticate(pass) {
    if (pass.trim() === password) {
        return true;
    } else {
        return false;
    }
}

module.exports = authenticate