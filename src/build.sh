#!/bin/sh

# Remove and recreate temp directory
rm -rf tmp
mkdir -p tmp

# Copy entire mod contents to tmp

cp -R /code/. tmp/

# Remove info.json
rm -f tmp/info.json

# Use info.json override, otherwise build infofile from create_infofile.py
if [ -f tmp/info.override.json ] ; then
    mv tmp/info.override.json tmp/info.json
else
    # Build infofile
    python create_infofile.py
    cat cleanup_list | while read fn ; 
    do
        rm -f "tmp/${fn}"
    done
fi

if [ ! -f tmp/info.json ] ; then
    echo "No info.json file present, aborting build"
    exit 1
fi

# Package the mod into properly named directory
MOD_DIR_NAME="${MOD_NAME}_${MOD_VERSION}"
mkdir "${MOD_DIR_NAME}"
cp -R tmp/. "${MOD_DIR_NAME}/"

if [ ! -z "$BUILD_ZIP" ] ; then
    zip "/target/${MOD_DIR_NAME}.zip" "${MOD_DIR_NAME}"
else
    cp -R "${MOD_DIR_NAME}" /target
fi

# TODO: add syntax check, dependency check etc.