CodeDoor
========

CodeDoor is intended to run on Heroku, although that is not supported yet.  Among other things, CodeDoor needs to move off of SQLite. :)

Copy config/application.yml.sample to config/application.yml, and add the relevant keys to your sandbox.

The oAuth callback should be ROOT_URL/users/auth/github
