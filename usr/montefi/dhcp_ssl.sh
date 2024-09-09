#!/bin/sh

# Configuration
DHCP_LOG="/var/log/dhcp.log"
PRIVATE_KEY="/etc/ssl/private/device.key"
PUBLIC_CERT="/etc/ssl/certs/device.crt"
SIGNED_LOG="/var/log/dhcp_signed.log"

# Check if required files exist
if [ ! -f "$DHCP_LOG" ]; then
    echo "DHCP log file not found: $DHCP_LOG"
    exit 1
fi

if [ ! -f "$PRIVATE_KEY" ]; then
    echo "Private key not found: $PRIVATE_KEY"
    exit 1
fi

if [ ! -f "$PUBLIC_CERT" ]; then
    echo "Public certificate not found: $PUBLIC_CERT"
    exit 1
fi

# Sign the DHCP log file
openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "${DHCP_LOG}.sig" "$DHCP_LOG"

# Combine the original log and the signature
cat "$DHCP_LOG" "${DHCP_LOG}.sig" > "$SIGNED_LOG"

# Clean up the temporary signature file
rm "${DHCP_LOG}.sig"

echo "DHCP log has been signed and saved to $SIGNED_LOG"

# Verify the signature (optional)
openssl dgst -sha256 -verify "$PUBLIC_CERT" -signature "${SIGNED_LOG}" "$DHCP_LOG"

if [ $? -eq 0 ]; then
    echo "Signature verification successful"
else
    echo "Signature verification failed"
fi
