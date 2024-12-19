package Reports;

use strict;
use warnings;
use POSIX qw(strftime);

# Generate user growth report
sub generate_user_growth_report {
    my ($stats_history) = @_;

    print "\nUser Growth Report:\n";
    print "===========================================\n";
    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Free Users: $entry->{free_users}, Paying Users: $entry->{paying_users}\n";
    }
    print "===========================================\n\n";
}

# Generate satisfaction and hardware quality report
sub generate_satisfaction_report {
    my ($stats_history) = @_;

    print "\nSatisfaction and Hardware Quality Report:\n";
    print "===========================================\n";
    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Satisfaction: $entry->{satisfaction}%, Hardware Quality: $entry->{hardware_quality}/10\n";
    }
    print "===========================================\n\n";
}

# Generate income and expenses report
sub generate_financial_report {
    my ($stats_history) = @_;

    print "\nFinancial Report:\n";
    print "===========================================\n";
    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Money: \$ $entry->{money}\n";
    }
    print "===========================================\n\n";
}

1; # Return true for module loading