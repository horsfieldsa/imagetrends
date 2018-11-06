# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# Daemonize the server into the background.
daemonize true

run Rails.application