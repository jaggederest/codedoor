CodeDoor
========

CodeDoor is a marketplace for freelance programmers to find work.  To qualify as a freelancer, you need at least one commit in a public repository with at least 25 stars.

The CodeDoor platform is open source (MIT and BSD license).  See the LICENSE file for more details.

---------------

CodeDoor is available at https://www.codedoor.com/

You can visit a staging version of CodeDoor at https://stealthcodedoor.herokuapp.com/

---------------

CodeDoor is currently intended to run on Heroku.

Copy config/application.yml.sample to config/application.yml, and add the relevant keys to your sandbox.

The oAuth callback should be ROOT_URL/users/auth/github

Make sure you run db:seed.  If you do not want test data, run db:update_skills instead.

[![Code Climate](https://codeclimate.com/github/CodeDoor/codedoor.png)](https://codeclimate.com/github/CodeDoor/codedoor)

[![Build Status](https://travis-ci.org/CodeDoor/codedoor.png?branch=master)](https://travis-ci.org/CodeDoor/codedoor)

[![Coverage Status](https://coveralls.io/repos/CodeDoor/codedoor/badge.png?branch=master)](https://coveralls.io/r/CodeDoor/codedoor?branch=master)
