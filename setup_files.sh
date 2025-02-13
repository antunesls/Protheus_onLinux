#!/bin/bash

# Get the base directory from the first argument
BASE_DIR=$1

# Define the folder containing the files to be extracted
SOURCE_FOLDER="../source/folder"

# Function to find the latest file by name pattern
find_latest_file() {
    local pattern=$1
    find "$SOURCE_FOLDER" -type f -name "$pattern" | sort | tail -n 1
}

# Function to find the latest .RPO file
find_latest_rpo() {
    find "$SOURCE_FOLDER" -type f -name "*REPOSITORIO_DE_OBJETOS_BRASIL*.RPO" | sort | tail -n 1
}

# List of required files
REQUIRED_FILES=(
    "*DICIONARIOS_COMPL*.ZIP"
    "*HELPS_COMPL*.ZIP"
    "*MENUS*.ZIP"
    "*DBACCESS_LINUX_X64*.TAR.GZ"
    "*APPSERVER_BUILD*.TAR.GZ"
    "*REPOSITORIO_DE_OBJETOS_BRASIL*.RPO"
    "appserver_appbroker.ini"
    "appserver_appsec01.ini"
    "appserver_appsec02.ini"
    "dbaccess.ini"
    "totvsappbroker"
    "totvsappsec01"
    "totvsappsec02"
    "totvsdbaccess"
    "totvslicensesrv"
)

# Check if all required files are present
for FILE_PATTERN in "${REQUIRED_FILES[@]}"; do
    if ! find "$SOURCE_FOLDER" -type f -name "$FILE_PATTERN" | grep -q .; then
        echo "Error: Required file matching pattern '$FILE_PATTERN' not found in $SOURCE_FOLDER"
        exit 1
    fi
done

# Descompactar dicionários de dados
unzip "$(find_latest_file '*DICIONARIOS_COMPL*.ZIP')" -d "$BASE_DIR/protheus_data/systemload/"

# Descompactar arquivos de helps
unzip "$(find_latest_file '*HELPS_COMPL*.ZIP')" -d "$BASE_DIR/protheus_data/systemload/"

# Descompactar arquivos de menus
unzip "$(find_latest_file '*MENUS*.ZIP')" -d "$BASE_DIR/protheus_data/system/"

# Descompactar DBAccess
tar -xvf "$(find_latest_file '*DBACCESS_LINUX_X64*.TAR.GZ')" -C "$BASE_DIR/protheus/bin/dbaccess/"

# Descompactar Binário Appserver
tar -xvf "$(find_latest_file '*APPSERVER_BUILD*.TAR.GZ')" -C "$BASE_DIR/microsiga/protheus/bin/applocksrv"

# Mover repositório
mv "$(find_latest_rpo)" "$BASE_DIR/protheus/rpo/tttp120.rpo"

# Copiar arquivos para serviços de Broker e Secundários
cp -rf "$BASE_DIR/microsiga/protheus/bin/applocksrv/*" "$BASE_DIR/protheus/bin/appbroker/"
cp -rf "$BASE_DIR/microsiga/protheus/bin/applocksrv/*" "$BASE_DIR/protheus/bin/appsec01/"
cp -rf "$BASE_DIR/microsiga/protheus/bin/applocksrv/*" "$BASE_DIR/protheus/bin/appsec02/"

# Copy and rename .ini files
SOURCE_DIR="."
FILES_AND_DIRS=(
    "appserver_appbroker.ini:$BASE_DIR/protheus/bin/appbroker"
    "appserver_appsec01.ini:$BASE_DIR/protheus/bin/appsec01"
    "appserver_appsec02.ini:$BASE_DIR/protheus/bin/appsec02"
    "dbaccess.ini:$BASE_DIR/protheus/bin/dbaccess"
)

for FILE_AND_DIR in "${FILES_AND_DIRS[@]}"; do
    IFS=":" read -r FILE DEST_DIR <<< "$FILE_AND_DIR"
    cp "$SOURCE_DIR/$FILE" "$DEST_DIR/appserver.ini"
    echo "Copied and renamed $FILE to $DEST_DIR/appserver.ini"
done

echo "All .ini files copied and renamed."

# Copy files to respective init.d directories
INITD_FILES=(
    "totvsappbroker:/etc/init.d/totvsappbroker"
    "totvsappsec01:/etc/init.d/totvsappsec01"
    "totvsappsec02:/etc/init.d/totvsappsec02"
    "totvsdbaccess:/etc/init.d/totvsdbaccess"
    "totvslicensesrv:/etc/init.d/totvslicensesrv"
)

for FILE_AND_DIR in "${INITD_FILES[@]}"; do
    IFS=":" read -r FILE DEST_DIR <<< "$FILE_AND_DIR"
    cp "$SOURCE_DIR/$FILE" "$DEST_DIR"
    echo "Copied $FILE to $DEST_DIR"
done

echo "All init.d files copied."

# Make the manage_services.sh script executable
chmod +x "$BASE_DIR/manage_services.sh"
