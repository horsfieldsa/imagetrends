#!/bin/bash

/wait

cd /app
rails db:create
rails db:schema:load
rails db:seed

exec "$@"