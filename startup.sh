#!/bin/bash

bundle install
govuk_setenv frontend bundle exec rails s -p 3005
