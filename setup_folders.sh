#!/bin/bash

# Get the base directory from the first argument
BASE_DIR=$1

# Diretórios de instalação dos binários Appserver
mkdir -p "$BASE_DIR/protheus/bin/appbroker"
mkdir -p "$BASE_DIR/protheus/bin/appsec01"
mkdir -p "$BASE_DIR/protheus/bin/appsec02"

# Diretório do repositório de dados e repositório customizado
mkdir -p "$BASE_DIR/protheus/rpo"

# Diretório Protheus Data e system
mkdir -p "$BASE_DIR/protheus_data"
mkdir -p "$BASE_DIR/protheus_data/system"

# Diretório dbaccess
mkdir -p "$BASE_DIR/protheus/bin/dbaccess"

# Diretório para instalação do License Server
mkdir -p "$BASE_DIR/protheus/bin/licenseserver"
