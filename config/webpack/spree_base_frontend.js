const execSync = require('child_process').execSync;
code = execSync('bundle show spree_base_frontend');

module.exports = {
  resolve: {
    alias: {
      '~spree_base_frontend': code.toString().trim(),
    }
  }
}
