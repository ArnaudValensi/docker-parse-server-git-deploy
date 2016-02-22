#!/usr/bin/env node

const express = require('express');
const ParseServer = require('parse-server').ParseServer;
const links = require('docker-links').parseLinks(process.env);

const databaseUri = process.env.DATABASE_URI || process.env.MONGOLAB_URI

if (!databaseUri) {
  if (links.mongo) {
    databaseUri = 'mongodb://' + links.mongo.hostname + ':' + links.mongo.port + '/dev';
  }
}

if (!databaseUri) {
  console.log('DATABASE_URI not specified, falling back to localhost.');
}

const facebookAppIds = process.env.FACEBOOK_APP_IDS;

if (facebookAppIds) {
    facebookAppIds = facebookAppIds.split(",");
}

const cloudHome = process.env.CLOUD_HOME || __dirname + '/parse-cloud';

const api = new ParseServer({
  databaseURI: databaseUri || 'mongodb://localhost:27017/dev',
  cloud: cloudHome + '/cloud/main.js',
  appId: process.env.APP_ID || 'myAppId',
  masterKey: process.env.MASTER_KEY, //Add your master key here. Keep it secret!
  collectionPrefix: process.env.COLLECTION_PREFIX,
  clientKey: process.env.CLIENT_KEY,
  restAPIKey: process.env.REST_API_KEY,
  dotNetKey: process.env.DOTNET_KEY,
  javascriptKey: process.env.JAVASCRIPT_KEY,
  dotNetKey: process.env.DOTNET_KEY,
  fileKey: process.env.FILE_KEY,
  facebookAppIds: facebookAppIds
});

const app = express();

// Serve the Parse API on the /parse URL prefix
const mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

// Allows the user to configure the express server before mounting it
try {
    const userServerConf = require(cloudHome + '/cloud/server.js');
    userServerConf(app);
} catch (ex) {
  if (ex.code === 'MODULE_NOT_FOUND') {
    console.log('no \'cloud/server.js\' found, continuing...');
  } else {
    throw ex;
  }
}

const port = process.env.PORT || 1337;
app.listen(port, function() {
    console.log('parse server running on http://localhost:'+ port + mountPath);
});
