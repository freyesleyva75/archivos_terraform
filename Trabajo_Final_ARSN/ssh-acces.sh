#!/bin/bash
 
RULE_NAME="ssh_rule"
SSH_PORT=2022
SOURCE_IP="$2"
 
enable_ssh() {
  echo "Habilitando acceso SSH temporal..."
  
  # Comprobar si la regla ya existe
  EXISTING_RULE=$(openstack firewall rule list --name "$RULE_NAME" -f value -c ID)
  if [ -n "$EXISTING_RULE" ]; then
    echo "La regla SSH '$RULE_NAME' ya existe. No es necesario crearla nuevamente."
    return 0
  fi
 
  # Crear la regla si no existe
  openstack firewall rule create \
    --name "$RULE_NAME" \
    --protocol tcp \
    --port "$SSH_PORT" \
    --source-ip "$SOURCE_IP" \
    --action allow
 
  if [ $? -eq 0 ]; then
    echo "Acceso SSH habilitado desde $SOURCE_IP."
  else
    echo "Error al habilitar el acceso SSH."
  fi
}
 
disable_ssh() {
  echo "Deshabilitando acceso SSH..."
  
  # Buscar la regla por nombre
  RULE_ID=$(openstack firewall rule list --name "$RULE_NAME" -f value -c ID)
  if [ -n "$RULE_ID" ]; then
    openstack firewall rule delete "$RULE_ID"
    if [ $? -eq 0 ]; then
      echo "Regla SSH eliminada."
    else
      echo "Error al eliminar la regla SSH."
    fi
  else
    echo "No se encontró ninguna regla SSH activa."
  fi
}
 
# Verificar argumentos y ejecutar la acción correspondiente
case "$1" in
  enable)
    if [ -z "$SOURCE_IP" ]; then
      echo "Debe proporcionar una dirección IP de origen para habilitar el acceso SSH."
      echo "Uso: $0 enable <source-ip>"
      exit 1
    fi
    enable_ssh
    ;;
  disable)
    disable_ssh
    ;;
  *)
    echo "Uso: $0 {enable|disable} <source-ip>"
    ;;
esac