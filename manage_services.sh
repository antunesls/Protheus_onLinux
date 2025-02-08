#!/bin/bash

# Este script gerencia os serviços do Protheus. 
# Uso: ./manage_services.sh {start|stop|status}
# start - Inicia todos os serviços
# stop - Para todos os serviços
# status - Verifica o status de todos os serviços

# Function to manage services
manage_service() {
    local action=$1
    local services=(
        "totvsapplocksrv"
        "totvsapplicensesrv"
        "totvsdbaccess"
        "totvsappbroker"
        "totvsappsec01"
        "totvsappsec02"
    )

    for service in "${services[@]}"; do
        ./$service $action
    done
}

# Check if the action is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {start|stop|status}"
    exit 1
fi

# Call the manage_service function with the provided action
manage_service $1
