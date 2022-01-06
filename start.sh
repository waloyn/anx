#!/bin/sh

# Global variables
DIR_CONFIG="/etc/Xray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/config.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get Xray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o ${DIR_TMP}/Xray_dist.zip
busybox unzip ${DIR_TMP}/Xray_dist.zip -d ${DIR_TMP}

# Copy configuration
mkdir -p ${DIR_CONFIG}
cp ${DIR_TMP}/config.json ${DIR_CONFIG}/config.json

# Install Xray
install -m 755 ${DIR_TMP}/xray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run Xray
${DIR_RUNTIME}/xray run -config ${DIR_CONFIG}/config.json
