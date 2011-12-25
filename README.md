== Festival de ideias

- Setup

You should edit the `database.sample.yml` file, to your Postgres configuration.
You should create/migrate/seed the data.
You should run the test suite to assure everything is O.K.


*Configuration (in the root dir, lol)
`mv config/database.sample.yml config/database.yml`
`vi config/database.yml` (change `vi` to your favorite editor)

**Migration:
`rake db:create db:migrate db:seed`

**Test
`rake db:test:prepare`


**Running
`rails s -p 3000` (you have to set the port to 3000 due to Facebook/Omniauth access)

**YAML files
`vi config/config.yml` to set up the facebook auth and other configurations.
