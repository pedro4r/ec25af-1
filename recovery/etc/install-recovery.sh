#!/system/bin/sh
if ! applypatch -c MTD:recovery:5421056:ebb3a35eb5c76da5b0ee3c1c288d8a2e95bf32c3; then
  log -t recovery "Installing new recovery image"
  applypatch MTD:boot:5421056:ebb3a35eb5c76da5b0ee3c1c288d8a2e95bf32c3 MTD:recovery ebb3a35eb5c76da5b0ee3c1c288d8a2e95bf32c3 5421056 ebb3a35eb5c76da5b0ee3c1c288d8a2e95bf32c3:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
