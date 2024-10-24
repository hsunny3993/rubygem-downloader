# README

Powerful ruby gems downloader

* Loading & Importing gems database
    Go to data directory from source directory on terminal.
    `./load-pg-dump -d rubygems -c ~/Downloads/public_postgresql.tar`

* Migrate on database
    `rails db:migrate`

* Run rake task to download all gems from rubygems.org
    `rails gems:download_all`