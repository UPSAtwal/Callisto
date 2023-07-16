const fs = require('fs');

const password = fs.readFileSync('./pass', encoding='utf-8');

function authenticate(pass) {
    try {
        if (pass.trim() === password) {
            return true;
        } else {
            return false;
        }
    } catch (err) {
        console.log(err);
        return false;
    }
}

module.exports = authenticate