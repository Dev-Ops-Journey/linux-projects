#!/bin/bash

# Step 1: Sourcing the .env file
FILE=$1
set -a
source ${FILE}
set +a

# Step 2: Validate the required variables
required_vars=(APP_ENV DB_HOST DB_PORT DB_NAME)
if [[ "$APP_ENV" = "prod" ]]; then
    required_vars=(APP_ENV DB_HOST DB_PORT DB_NAME SECRET)
fi
missing_vars=()

for var in "${required_vars[@]}"; do
    # using indirect expansion here '!' to retrieve the value of the variable name
    if [[ -z "${!var}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
    echo "Missing required vars: ${missing_vars[@]}"
    exit 1
fi

# Step 3: Behave differently, depending on APP_ENV
case "$APP_ENV" in 
    dev)
        LOG_LEVEL="DEBUG"
        SSL_MODE="disabled"
        ;;
    prod)
        LOG_LEVEL="PROD"
        SSL_MODE="enabled"
        ;;
    staging)
        LOG_LEVEL="INFO"
        SSL_MODE="optional"
        ;;
    *)
        echo "ERROR: Unknown APP_ENV value ${APP_ENV} (expected dev|staging|prod)" >&2
        exit 1
        ;;
esac

echo "=============================="
echo "App Configuration Summary"
echo "=============================="
echo "Environment: ${APP_ENV}"
echo "DB Host: ${DB_HOST}"
echo "DB Port: ${DB_PORT}"
echo "DB Name: ${DB_NAME}"
echo "Log Level: ${LOG_LEVEL}"
echo "SSL Mode: ${SSL_MODE}"
echo "============================="
