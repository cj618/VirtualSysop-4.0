package UI;

use strict;
use warnings;

# Display the main menu
sub display_menu {
    print "\n================ Main Menu ================\n";
    print "[W] Work\n";
    print "[M] Check Mail\n";
    print "[V] Virus Scan\n";
    print "[S] Store\n";
    print "[R] Report\n";
    print "[C] Charge Users\n";
    print "[Q] Quit\n";
    print "========================================\n";
    print "Enter your choice: ";
}

# Get player input
sub get_player_input {
    my $input = <STDIN>;
    chomp($input);
    return uc($input);  # Convert to uppercase for uniformity
}

# Display a message to the player
sub display_message {
    my ($message) = @_;
    print "\n$message\n";
}

# Display an error message
sub display_error {
    my ($error) = @_;
    print "\n[ERROR]: $error\n";
}

# Display a triggered event
sub display_event {
    my ($event) = @_;
    print "\n*** Event Triggered ***\n";
    print "Type       : $event->{type}\n";
    print "Description: $event->{description}\n";
    print "Action     : $event->{action}\n";
    print "Value      : $event->{value}\n";
    print "*************************\n";
}

# Display the end-game screen
sub display_end_game {
    my ($final_score, $achievements) = @_;
    print "\n================ End Game =================\n";
    print "Final Score     : $final_score\n";
    print "Achievements    : ", join(", ", @$achievements), "\n";
    print "=========================================\n";
    print "Thank you for playing Virtual SysOp!\n";
}

1; # Return true for module loading
