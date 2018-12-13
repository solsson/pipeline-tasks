let c = require('knative-pipeline-tasks-example-nodelib');
let Walker = require('walker');
let w = Walker('./');
let fs = require('fs');

try {
  fs.statSync('./node_modules/once');
  console.error('Seeing a dev dependency from nodelib2');
  process.exit(1);
} catch(err) {}

module.exports = function run(cb) {
  w.on('end', () => {
    console.log('nodelib2 async end for', c.now);
    cb();
  });
}
