#!/bin/bash
echo "Capture DB backup"
heroku pg:backups:capture DATABASE_URL

echo "Download DB backup"
curl -o tmp/latest.dump `heroku pg:backups:url #{heroku_app_flag} | cat`

echo "Restore DB backup"
pg_restore --clean --verbose --no-acl --no-owner -U postgres  -h localhost -d maker-community-development tmp/latest.dump

echo "Remove DB backup"
# rm tmp/latest.dump