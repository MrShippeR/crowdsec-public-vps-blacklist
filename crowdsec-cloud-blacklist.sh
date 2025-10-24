#!/bin/bash
# -------------------------------------------------------------
# CrowdSec – Public Cloud IP blacklist preparer
# Autor: marek@vach.cz
# Účel: Stáhne JSON se seznamem IP rozsahů a připraví CSV pro CrowdSec
# Zdrojový repozitář https://github.com/tobilg/public-cloud-provider-ip-ranges?tab=readme-ov-file
# -------------------------------------------------------------

set -euo pipefail

OUTDIR="/tmp/crowdsec-blacklist"
mkdir -p "$OUTDIR"

JSON_URL="https://raw.githubusercontent.com/tobilg/public-cloud-provider-ip-ranges/main/data/providers/all.json"
OUT_FILE="$OUTDIR/cloud-providers-blacklist.csv"

echo "[$(date '+%F %T')] Stahuji JSON soubor z $JSON_URL..."
curl -s -o "$OUTDIR/all.json" "$JSON_URL"

echo "[$(date '+%F %T')] Převádím JSON na CSV pro CrowdSec..."

# Přidáme header
echo "duration,reason,scope,type,value" > "$OUT_FILE"

# Převod JSON -> CSV CrowdSec s validní hodnotou
jq -r '
  .[] |
  if .cidr_block != null then
    "24h,VPS block - " + .cloud_provider + ",ip,ban," + .cidr_block
  elif .ip_address != null then
    "24h,VPS block - " + .cloud_provider + ",ip,ban," + .ip_address
  else
    empty
  end
' "$OUTDIR/all.json" >> "$OUT_FILE"

echo "[✓] CSV soubor připraven: $OUT_FILE"


echo "Importuji do CrowdSec..."
sudo cscli decisions import -i "$OUT_FILE"
echo "[✓] Import dokončen."

sudo rm -r "$OUTDIR"
echo "[$(date '+%F %T')] Hotovo."

