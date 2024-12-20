package UI;

use strict;
use warnings;
use POSIX qw(strftime);
use Data;

# Displays an error message
sub display_error {
    my ($message) = @_;
    print "Error: $message\n";
}

# Displays events triggered during gameplay
sub display_event {
    my ($event) = @_;
    print "$event->{description}\n";
}

# Handles player purchases (Mall of the Future)
sub handle_purchase {
    my ($player_stats_ref) = @_;

    print "\nWelcome to the Mall of the Future!\n";
    print "Choose a store:\n";
    print "  1. Sears (Hardware)\n";
    print "  2. Best Buy (Software)\n";
    print "  3. CompUSA (BBS Tools)\n";
    print "  4. News Corporation (Marketing)\n";
    print "  5. 7-Eleven (Food & Drinks)\n";
    print "  6. Exit Mall\n";

    print "\nEnter your choice: ";
    my $choice = <STDIN>;
    chomp($choice);

    if ($choice == 1) {
        _visit_store("Sears", [
            { name => "New Hard Disk", cost => 500, effect => { free_users => 10, satisfaction => 2 } },
            { name => "New Desk and Chair", cost => 250, effect => { employees => 1 } }
        ], $player_stats_ref);
    } elsif ($choice == 2) {
        _visit_store("Best Buy", [
            { name => "Antivirus Software", cost => 300, effect => { satisfaction => 5, virus_protection => 10 } },
            { name => "Door Games", cost => 150, effect => { satisfaction => 3 } }
        ], $player_stats_ref);
    } elsif ($choice == 3) {
        _visit_store("CompUSA", [
            { name => "Modem", cost => 400, effect => { free_users => 15 } },
            { name => "Bandwidth Booster", cost => 700, effect => { paying_users => 5 } }
        ], $player_stats_ref);
    } elsif ($choice == 4) {
        _visit_store("News Corporation", [
            { name => "Newspaper Ad", cost => 1000, effect => { free_users => 30, paying_users => 30 } },
            { name => "Radio Ad", cost => 800, effect => { free_users => 30, paying_users => 10 } },
            { name => "Flyers", cost => 300, effect => { free_users => 10 } }
        ], $player_stats_ref);
    } elsif ($choice == 5) {
        _visit_store("7-Eleven", [
            { name => "Jolt Cola", cost => 5, effect => { actions_remaining => 10, daily_action_limit => 10 } },
            { name => "Pepsi", cost => 4, effect => { actions_remaining => 5, daily_action_limit => 5 } },
            { name => "Mountain Dew", cost => 4, effect => { actions_remaining => 5, daily_action_limit => 5 } },
            { name => "Pringles", cost => 10, effect => { actions_remaining => 10, daily_action_limit => 10 } },
            { name => "Nachos", cost => 10, effect => { actions_remaining => 10, daily_action_limit => 10 } }
        ], $player_stats_ref);
    } else {
        print "Exiting the mall.\n";
    }

    return $player_stats_ref;
}

# Visits a specific store
sub _visit_store {
    my ($store_name, $items, $player_stats_ref) = @_;

    print "\nWelcome to $store_name!\n";
    print "Available items:\n";
    my $i = 1;
    foreach my $item (@$items) {
        print "  $i. $item->{name} (\$ $item->{cost})\n";
        $i++;
    }
    print "  $i. Exit Store\n";

    print "\nEnter your choice: ";
    my $choice = <STDIN>;
    chomp($choice);

    if ($choice >= 1 && $choice <= @$items) {
        my $item = $items->[$choice - 1];
        if ($player_stats_ref->{money} >= $item->{cost}) {
            $player_stats_ref->{money} -= $item->{cost};
            foreach my $key (keys %{$item->{effect}}) {
                $player_stats_ref->{$key} += $item->{effect}->{$key};
            }
            print "You purchased $item->{name} for \$ $item->{cost}.\n";
        } else {
            print "You don\'t have enough money to buy $item->{name}.\n";
        }
    } else {
        print "Exiting $store_name.\n";
    }
}

# Displays the admin console menu
sub display_admin_console {
    my ($bbs_name, $player_stats, $current_time) = @_;
    my $formatted_time = POSIX::strftime("%Y-%m-%d %H:%M:%S", localtime($current_time));

    my $hardware_list = Data::get_data('cpu');
    my $current_hardware = $hardware_list->[$player_stats->{hardware_level}] // 'Unknown';

    print "===========================================\n";
    print "*** $bbs_name Admin Console ***\n";
    print "Date and Time: $formatted_time\n";
    print "===========================================\n";
    print " Free Users: $player_stats->{free_users}     |  Bank acct: \$ $player_stats->{money}\n";
    print " Paying Users: $player_stats->{paying_users}   |  Employees: $player_stats->{employees}\n";
    print " Daily Actions Remaining: $player_stats->{actions_remaining} / $player_stats->{daily_action_limit}\n";
    print " Hardware: $current_hardware\n";
    print "===========================================\n\n";
    print "    W - Work on your BBS to attract users and resources.\n";
    print "    M - Mall of the Future.\n";
    print "    V - Scan for and remove viruses from your system.\n";
    print "    R - View reports on your progress and score.\n";
    print "    N - Network with rivals.\n";
    print "    U - Read user mail.\n";
    print "    S - Save Game.\n";
    print "    C - Clear Screen.\n";
    print "    Q - Quit the game.\n";
    print "\n===========================================\n\n";
    print "Command: ";
}

# Gets player input for commands
sub get_player_input {
    my $input = <STDIN>;
    chomp($input);
    return uc($input); # Convert to uppercase for consistency
}

# Displays reports based on type
sub display_report {
    my ($report_type, $data) = @_;

    print "\n===========================================\n";
    print "Report: $report_type\n";
    print "===========================================\n";
    print "$data\n";
    print "===========================================\n\n";
}

# Displays end-game summary
sub display_end_game {
    my ($money, $achievements) = @_;

    print "\n===========================================\n";
    print "Game Over\n";
    print "Final Score: \$ $money\n";
    print "Achievements Unlocked:\n";

    if (ref($achievements) eq 'ARRAY' && @$achievements) {
        foreach my $achievement (@$achievements) {
            print "  - $achievement\n";
        }
    } else {
        print "  None\n";
    }

    print "===========================================\n\n";
}

1; # Return true for module loading