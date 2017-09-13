# Generic trigger to intercept, examine and possibly modify a jobspec.
# must be of type form-in or form-commit so that %formfile% is avialable.
# makes a connection back to the server to fetch/parse the jobspec

# in trigger table entry, set debug=0 or leave unset altogether in production use

use strict;
use Getopt::Long;
# these modules used for debugging/logging
use IO::File;
use English;
use Data::Dumper; 
use File::Copy;
use P4;

# options hash with defaults, can be overriden in trigger table command line
my %options = (
	       "logfile" => "Generic",
);


GetOptions(\%options,
	   "clientip:s",
	   "serverip:s",
	   "clienthost:s",
	   "serverhost:s",
	   "logfile:s",
	   "debug:i",
);

#get timestamp

my $date = `date`;

my $log = $options{'logfile'} . "_log.txt";

#logfile
my $trigger_log;

# Debug/Devel
if ($options{'debug'}) {
  # remove 'die' so trigger will silently fail (instead of blow up and prevent job update) if logfile cannot be opened
  $trigger_log = IO::File->new(">>$log") or &report_failure("Failed to open trigger logfile");
  print $trigger_log "\n=====\n" . $date . "\n=====\n";
  print $trigger_log Dumper(\%options);
}    


if ($options{'debug'}) {

}

# if triggers.io=1 is set, then the trigger will get a lot of config information on stdin.
# the following slurps it up and turns it into a useful hash
chomp (my @dict_arr = <STDIN>);
my %dict_hash =  map { my @thing = split /:/, $_; $thing[0] => $thing[1] } @dict_arr;

# report what you saw on stdin to the logfile
print $trigger_log Dumper(\%dict_hash);

# if triggers.io=1, the trigger must respond with 'action:pass' to stdout
# user the existence of dictApiLevel key as a proxy for triggers.io=1 and respond
# accordingly.  
if (exists($dict_hash{'dictApiLevel'})) {
  print "action:reject";
} else {
  # otherwise fall back to old behavior.
  print "omg failed";
  exit 1;
}



sub report_failure {
    my $fail_msg = shift;
    print $fail_msg if ($options{'debug'});
    exit 0;
}

__END__
