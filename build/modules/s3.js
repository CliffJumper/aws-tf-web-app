'use strict';
const s3 = require('s3');

function exitWithError(err) {
  throw new Error(err);
}

function log(msg, lvl, dbLvl) {
  if (lvl <= dbLvl) {
    console.log(msg);
  }
}

module.exports.empty = function empty(conf, bucket, dbgLvl) {
  let debugLevel = dbgLvl || 1;

  return new Promise((resolve) => {
    let objects = [];
    // let s3ClientOpts = {
    //   s3Options: {
    //     accessKeyId: conf.S3_ACCESS_KEY,
    //     secretAccessKey: conf.S3_SECRET,
    //     region: conf.S3_REGION
    //   }
    // };
    let s3Client = s3.createClient(conf);

    let listParams = {recursive: true, s3Params: {Bucket: bucket}};
    let s3list = s3Client.listObjects(listParams, exitWithError);

    s3list.on('error', exitWithError);
    s3list.on('data', (data) => (data.Contents) ? objects = objects.concat(data.Contents) : '');
    s3list.on('end', () => {

      let keyArr = objects.map((o) => {
        log(`Preparing delete for file [${o.Key}]`, 2, debugLevel);
        return {Key: o.Key};
      });
      log(`Attempting to delete ${keyArr.length} files...`, 1, debugLevel);
      if (!keyArr.length) {
        log('No files to delete, bucket empty.', 1, debugLevel);
        resolve();
      } else {
        const s3Params = {Bucket: bucket, Delete: {Objects: keyArr}};
        const s3 = s3Client.deleteObjects(s3Params);
        s3.on('error', exitWithError);
        s3.on('end', () => {
          log('Bucket emptied.', 1, debugLevel);
          resolve();
        });
      }
    });
  });
};