package Reports;

use strict;
use warnings;
use POSIX qw(strftime);

# Generate a report on user growth
sub generate_user_growth_report {
    my ($stats_history) = @_;

    print "\n===========================================\n";
    print "User Growth Report\n";
    print "===========================================\n";

    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Free Users: $entry->{free_users}, Paying Users: $entry->{paying_users}\n";
    }

    print "===========================================\n\n";
}

# Generate a report on satisfaction and hardware quality
sub generate_satisfaction_report {
    my ($stats_history) = @_;

    print "\n===========================================\n";
    print "Satisfaction and Hardware Quality Report\n";
    print "===========================================\n";

    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Satisfaction: $entry->{satisfaction}, Employees: $entry->{employees}\n";
    }

    print "===========================================\n\n";
}

# Generate a financial report
sub generate_financial_report {
    my ($stats_history) = @_;

    print "\n===========================================\n";
    print "Financial Report\n";
    print "===========================================\n";

    foreach my $entry (@$stats_history) {
        my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($entry->{timestamp}));
        print "$time - Money: \$ $entry->{money}, Expenses: \$ $entry->{expenses}\n";
    }

    print "===========================================\n\n";
}

# Generate an inventory report
sub generate_inventory_report {
    my ($player_stats) = @_;

    print "\n===========================================\n";
    print "Inventory Report\n";
    print "===========================================\n";

    if ($player_stats->{inventory}) {
        foreach my $item (keys %{$player_stats->{inventory}}) {
            print "$item: $player_stats->{inventory}{$item}\n";
        }
    } else {
        print "No items purchased yet.\n";
    }

    print "===========================================\n\n";
}

# Generate a rival interactions report
sub generate_rival_report {
    my ($rival_interactions) = @_;

    print "\n===========================================\n";
    print "Rival Interactions Report\n";
    print "===========================================\n";

    if (!$rival_interactions || !@$rival_interactions) {
        print "No rival interactions recorded yet.\n";
    } else {
        foreach my $interaction (@$rival_interactions) {
            my $time = strftime("%Y-%m-%d %H:%M:%S", localtime($interaction->{timestamp}));
            print "$time - Rival: $interaction->{rival}, Action: $interaction->{action}, Result: $interaction->{result}\n";
        }
    }

    print "===========================================\n\n";
}

1; # Return true for module loading
