use strict;

print $_;

if (m/^exit_internal =/) {
    print q(exit = #(@exit_internal @kbd-set-backlight-off));
}
