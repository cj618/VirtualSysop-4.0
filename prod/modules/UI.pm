package UI;

use strict;
use warnings;
use Data::Dumper; # For debugging purposes

# Display the main menu
sub display_menu {
    print "Commands:\n";
    print "    W - Work on your BBS to attract users and resources.\n";
    print "    M - Mall of the Future (coming soon).\n";
    print "    V - Scan for and remove viruses from your system.\n";
    print "    R - View reports on your progress and score.\n";
    print "    N - Network (coming soon).\n";
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

# Display an event
sub display_event {
    my ($event) = @_;
    
    # Debugging output to verify the event structure
    print Dumper($event) if !$event->{description};

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

1; # Return true for module loading
