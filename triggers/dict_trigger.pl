# Generic trigger to intercept, examine and possibly modify a jobspec.
# must be of type form-in or form-commit so that %formfile% is avialable.
# makes a connection back to the server to fetch/parse the jobspec

# in trigger table entry, set debug=0 or leave unset altogether in production use

use strict;

# these modules used for debugging/logging
use IO::File;
use English;
use Data::Dumper; 
use File::Copy;
use P4;


my %options = (
    'debug' => 1,
    );

my $date = `date`;

#logfile
my $trigger_log;



$trigger_log = IO::File->new(">>dict_trigger_logfile.txt") or &report_failure("Failed to open trigger logfile");
print $trigger_log "\n=====\n" . $date . "\n=====\n";
print $trigger_log Dumper(\%options);

chomp (my @dict_arr = <STDIN>);
my %dict_hash =  map { my @thing = split /:/, $_; $thing[0] => $thing[1] } @dict_arr;



print $trigger_log Dumper(\%dict_hash);

print "action:pass\n";


sub report_failure {
    my $fail_msg = shift;
    print $fail_msg if ($options{'debug'});
    exit 0;
}

__END__
