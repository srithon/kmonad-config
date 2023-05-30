#!/bin/sh

temp_dir=$(mktemp -d)
# preprocess kbdx before compilation
perl -lne "$(cat preprocess.pl)" logitech_keyboard.kbdx > "$temp_dir/logitech_keyboard.kbdx"

# render system_keyboard.kbdx
sed -e 's:/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd:/dev/input/by-path/platform-i8042-serio-0-event-kbd:' -e 's:Logitech KMonad Output:System KMonad Output:' "$temp_dir/logitech_keyboard.kbdx" >"$temp_dir/system_keyboard.kbdx"

kmonadx "$temp_dir/logitech_keyboard.kbdx" "$temp_dir/system_keyboard.kbdx"

mv $temp_dir/*.kbd .

rm $temp_dir/*.kbdx
rmdir $temp_dir
