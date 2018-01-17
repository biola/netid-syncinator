NetID Syncinator [![Build Status](https://travis-ci.org/biola/netid-syncinator.svg?branch=master)](https://travis-ci.org/biola/netid-syncinator)
================

NetID Syncinator creates unique NetID usernames and University Accounts for certain users in [trogdir-api](https://github.com/biola/trogdir-api).

Requirements
------------
- Ruby
- Redis server (for Sidekiq)
- trogdir-api installation

Installation
------------
```bash
git clone git@github.com:biola/netid-syncinator.git
cd netid-syncinator
bundle install
cp config/settings.local.yml.example config/settings.local.yml
```

Configuration
-------------
- Edit `config/settings.local.yml` accordingly.

Running
-------

```ruby
sidekiq -r ./config/environment.rb
```

Deployment
----------
```bash
blazing setup [target name in blazing.rb]
git push [target name in blazing.rb]
```
