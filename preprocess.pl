use strict;

print $_;

if (m/^exit_internal =/) {
    print q(exit = #(@exit_internal @kbd-set-backlight-off));
}

if (/lmet = exit/) {
    print q(lalt = (tap-hold-next-release $tap-hold-delay-min @exit #(@exit_internal (layer-toggle leader))));
    print q(ralt = (tap-hold-next-release $tap-hold-delay-min @exit #(@exit_internal (layer-toggle leader-no-block) 'ralt')));
}
