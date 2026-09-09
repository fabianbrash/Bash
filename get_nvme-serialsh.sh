#/bin/bash


set -e


for d in nvme0n1 nvme1n1 nvme2n1 nvme3n1 nvme4n1 nvme5n1 nvme6n1 nvme7n1; do
  echo "=== $d ==="
  sudo udevadm info --query=all --name=/dev/$d | grep -i "ID_SERIAL_SHORT\|ID_SERIAL="
done
