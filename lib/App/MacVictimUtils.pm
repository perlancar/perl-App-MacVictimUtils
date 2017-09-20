package App::MacVictimUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

our %SPEC;

$SPEC{delete_ds_store} = {
    v => 1.1,
    summary => 'Recursively delete .DS_Store files',
    args => {
        dirs => {
            schema => ['array*', of=>'dirname*'],
            pos => 0,
            greedy => 1,
        },
    },
    features => {
        dry_run => 1,
    },
};
sub delete_ds_store {
    require File::Find;

    my %args = @_;

    my @dirs = @{ $args{dirs} || ["."] };

    File::Find::find(
        sub {
            return unless -f && $_ eq '.DS_Store';
            if ($args{-dry_run}) {
                log_info("[DRY] Deleting %s/.DS_Store ...", $File::Find::dir);
                return;
            }
            log_info("Deleting %s/.DS_Store ...", $File::Find::dir);
            unlink $_ or do {
                log_warn("Can't delete %s/.DS_Store: %s", $File::Find::dir, $!);
            };
        },
        @dirs,
    );
    [200];
}

1;
#ABSTRACT: CLI utilities for when dealing with Mac computers/files

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

=cut
