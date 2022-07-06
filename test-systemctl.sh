#!/bin/sh

# Test if systemctl is not crashed
testname="test-systemctl-crash"
status=$(systemctl is-system-running)
if [ $? -le 4 ]; then
  echo "${testname}: pass"
else
  echo "${testname}: fail"
  exit 1
fi

# Test if systemctl return non-empty string
testname="test-systemctl-value"
if [ -n "$status" ]; then
  echo "${testname}: pass"
else
  echo "${testname}: fail"
  exit 1
fi

# Test if systemctl is reporting the same status as
# systemd exposing via D-Bus
testname="test-systemctl-dbus-status"
gdbus call --system --dest=org.freedesktop.systemd1 \
  --object-path "/org/freedesktop/systemd1" \
  --method org.freedesktop.DBus.Properties.Get \
  org.freedesktop.systemd1.Manager SystemState | \
  grep "${status}"
if [ $? -eq 0 ]; then
  echo "${testname}: pass"
else
  echo "${testname}: fail"
  exit 1
fi