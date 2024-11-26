#!/bin/bash

temp_dir=$(mktemp -d)
targets=(logitech_keyboard.kbdx system_keyboard.kbdx keychron_c3_pro_keyboard.kbdx keychron_v1_max_keyboard.kbdx)
for target in "${targets[@]}"; do
    # -l makes prints do newline
    perl -l ./preprocess.pl "$(basename -s .kbdx $target)" > "$temp_dir/$target"
done

# prepend "$temp_dir/" to each array item
kmonadx "${targets[@]/#/$temp_dir\/}"

mv $temp_dir/*.kbd .

rm $temp_dir/*.kbdx
rmdir $temp_dir
