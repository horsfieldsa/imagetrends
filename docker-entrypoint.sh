#!/bin/bash

/wait

cd /app
rails db:migrate
rails db:seed

exec "$@"