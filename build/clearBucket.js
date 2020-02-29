'use strict';

const AWS = require('aws-sdk');
const s3 = require('./modules/s3.js');


var awsS3Client = new AWS.S3();

var options = {
  s3Client: awsS3Client,
};

let bucket = 'photosite-gallery-webhost';
let dbgLvL = 1;

s3.empty(options, bucket, dbgLvL);
