#!/bin/bash

cd /app
rails db:create
rails db:migrate
rails db:seed

exec "$@"