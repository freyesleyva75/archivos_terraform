#!/bin/bash

RULE_NAME="ssh_rule"
SSH_PORT=2022
SOURCE_IP="$2"

enable_ssh() {
  echo "Habilitando acceso SSH temporal..."
  openstack firewall rule create \
    --name "$RULE_NAME" \
    --protocol tcp \
    --port "$SSH_PORT" \
    --source-ip "$SOURCE_IP" \
    --action allow
  echo "Acceso SSH habilitado desde $SOURCE_IP."
}

disable_ssh() {
  echo "Deshabilitando acceso SSH..."
  RULE_ID=$(openstack firewall rule list --name "$RULE_NAME" -f value -c ID)
  if [ -n "$RULE_ID" ]; then
    openstack firewall rule delete "$RULE_ID"
    echo "Regla SSH eliminada."
  else
    echo "No se encontró ninguna regla SSH activa."
  fi
}

case "$1" in
  enable) enable_ssh ;;
  disable) disable_ssh ;;
  *) echo "Uso: $0 {enable|disable} <source-ip>" ;;
esac
