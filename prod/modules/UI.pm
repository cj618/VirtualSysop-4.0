package UI;

use strict;
use warnings;
use Data::Dumper;

# Store items for the "Mall of the Future"
my @store_items = (
    { name => 'Hardware Upgrade', cost => 200, impact => { hardware_quality => 2 } },
    { name => 'Antivirus License', cost => 150, impact => { virus_protection => 1 } },
    { name => 'User Engagement Tool', cost => 300, impact => { satisfaction => 5 } },
);

# Display the main menu
sub display_menu {
    print "Commands:\n";
    print "    W - Work on your BBS to attract users and resources.\n";
    print "    M - Mall of the Future.\n";
    print "    V - Scan for and remove viruses from your system.\n";
    print "    R - View reports on your progress and score.\n";
    print "    N - Network with rivals.\n";
    print "    S - Save Game.\n";
    print "    C - Clear Screen.\n";
    print "    Q - Quit the game.\n";
}

# Get input from the player
sub get_player_input {
    print "Enter your command: ";
    my $input = <STDIN>;
    chomp($input);
    return uc($input);
}

# Display the "Mall of the Future" menu
sub display_store {
    print "\nWelcome to the Mall of the Future!\n";
    print "Here are the items available for purchase:\n";
    
    my $index = 1;
    foreach my $item (@store_items) {
        print "[$index] $item->{name} - \$ $item->{cost}\n";
        $index++;
    }
    print "[C] Cancel\n";
}

# Handle player purchases
sub handle_purchase {
    my ($player_stats_ref) = @_;
    my %player_stats = %$player_stats_ref;

    display_store();

    print "\nEnter the number of the item you want to purchase: ";
    my $choice = <STDIN>;
    chomp($choice);

    if ($choice =~ /^\d+$/ && $choice > 0 && $choice <= scalar @store_items) {
        my $item = $store_items[$choice - 1];

        if ($player_stats{money} >= $item->{cost}) {
            $player_stats{money} -= $item->{cost};
            foreach my $stat (keys %{$item->{impact}}) {
                $player_stats{$stat} += $item->{impact}{$stat};
            }
            print "\nYou purchased $item->{name} for \$ $item->{cost}.\n";
            Player::add_to_inventory($item->{name});
        } else {
            print "\nYou do not have enough money to purchase this item.\n";
        }
    } elsif (uc($choice) eq 'C') {
        print "\nPurchase canceled.\n";
    } else {
        print "\nInvalid choice. Returning to the main menu.\n";
    }

    return \%player_stats;
}

# Display an event
sub display_event {
    my ($event) = @_;

    my $event_description = $event->{description} // 'Unknown event';
    print "Event: $event_description\n";

    if (exists $event->{impact}) {
        foreach my $key (keys %{$event->{impact}}) {
            print "  Impact on $key: $event->{impact}{$key}\n";
        }
    }
}

# Display a general message
sub display_message {
    my ($message) = @_;
    print "$message\n";
}

# Display unlocked achievements
sub display_achievements {
    my (@achievements) = @_;

    if (@achievements) {
        print "\nCongratulations! You have unlocked the following achievements:\n";
        foreach my $achievement (@achievements) {
            print "  - $achievement\n";
        }
    }
}

# Display an error message
sub display_error {
    my ($error) = @_;
    print "Error: $error\n";
}

# Display end game summary
sub display_end_game {
    my ($score, $achievements) = @_;
    print "\n===========================================\n";
    print "Game Over\n";
    print "Final Score: $score\n";
    print "Achievements Unlocked:\n";
    foreach my $achievement (@$achievements) {
        print "  - $achievement\n";
    }
    print "===========================================\n\n";
}

# Display reports menu
sub display_reports_menu {
    print "\nReports Menu:\n";
    print "    1 - User Growth Report\n";
    print "    2 - Satisfaction and Hardware Quality Report\n";
    print "    3 - Financial Report\n";
    print "    C - Cancel\n";
    print "\nEnter your choice: ";
}

1; # Return true for module loading