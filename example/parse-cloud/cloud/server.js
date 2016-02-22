'use strict';

module.exports = (app) => {
  const bodyParser = require('body-parser');

  app.set('views', __dirname + '/../public');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');

  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());

  app.get('/robots.txt', (req, res) => {
    res.type('text/plain');
    res.send('User-agent: *\nDisallow:\n');
  });

  app.get('*', (req, res) => {
    res.render('index.html');
  });

}
