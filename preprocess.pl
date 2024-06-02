use strict;

open(my $input_file, "<", "./logitech_keyboard.kbdx") or die "Couldn't open logitech_keyboard.kbd";

# e.g. "logitech_keyboard"
my $target_keyboard = $ARGV[0];

if (not defined $target_keyboard) {
    die "Please pass in the name of the target keyboard!\n";
}

my $state = "";

my $SKIP_UNTIL_END = "skip_until_end";
my $SKIP_ONE = "skip_one";

while (<$input_file>) {
    if (m/^#\[PP:(ONLY|SKIP|SKIP_START|SKIP_END)\(([^)]+)\)\]/) {
        # remember that Perl is compiled, and so this regex will certainly not be recomputed in every iteration.
        my @specifiedKeyboards = split /,\s+/, $2;
        my $directiveMatchesKeyboard = grep(/^$target_keyboard$/, @specifiedKeyboards);

        if ($1 eq "ONLY") {
            if ($directiveMatchesKeyboard) {
                $state = "";
            } else {
                $state = $SKIP_ONE;
            }
        } elsif ($1 eq "SKIP") {
            if ($directiveMatchesKeyboard) {
                $state = $SKIP_ONE;
            } else {
                $state = "";
            }
        } elsif ($1 eq "SKIP_START") {
            if ($directiveMatchesKeyboard) {
                $state = $SKIP_UNTIL_END;
            }
        } elsif ($1 eq "SKIP_END") {
            if ($directiveMatchesKeyboard) {
                $state = "";
            }
        }

        next;
    }

    if ($state eq "") {
        print $_;

        if (m/^exit_internal =/) {
            print q(exit = #(@exit_internal @kbd-set-backlight-off));
        }

        if (/lmet = exit/) {
            print q(lalt = (tap-hold-next-release $tap-hold-delay-min @exit #(@exit_internal (layer-toggle leader))));
            print q(ralt = (tap-hold-next-release $tap-hold-delay-min @exit #(@exit_internal (layer-toggle leader-no-block) 'ralt')));
        }
    } elsif ($state eq $SKIP_ONE) {
        $state = "";
    }
}
