/**
 * Main server entry-point
 * @author mtownsend
 * @since June 2020
 */

import express from 'express';
import handlebars from 'express-handlebars';
import { sendReport } from './mail.js';

const PORT = 8080;

(async () => {

  const app = express();

  // Set up template rendering
  app.engine('handlebars', handlebars());
  app.set('view engine', 'handlebars');

  // Set up body parsing
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Serve static content
  app.use(express.static('static'));

  // Serve the reporting UI
  app.get('/', async (req, res) => {
    res.render('report', { 
      style: 'report.css',
      script: 'report.js'
    });
  });

  // Accept report submission
  app.post('/submit', async (req, res) => {
    sendReport(req.body);
    res.render('submit');
  });

  app.listen(PORT, () => console.log(`Listening on port ${PORT}`));

})();
