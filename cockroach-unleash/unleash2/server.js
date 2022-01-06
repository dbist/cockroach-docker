const unleash = require('unleash-server');

unleash
  .start({
    db: {
      ssl: false,
      host: 'lb',
      port: 26257,
      database: 'unleash',
      user: 'root',
      password: '',
    },
    server: {
      port: 4242,
    },
  })
  .then((unleash) => {
    console.log(
      `Unleash started on http://localhost:${unleash.app.get('port')}`,
    );
  });