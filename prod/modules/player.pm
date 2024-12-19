package Player;

use strict;
use warnings;

# Player stats
my %player = (
    free_users        => 50,
    paying_users      => 10,
    satisfaction      => 75,  # Percentage
    hardware_quality  => 5,   # Out of 10
    actions_remaining => 100, # Actions per day
    money             => 500, # Starting currency
    achievements      => [],  # List of achievements
    problems_resolved => 0,   # Initialize to avoid warnings
);

# Initialize the player profile
sub initialize {
    %player = (
        free_users        => 50,
        paying_users      => 10,
        satisfaction      => 75,
        hardware_quality  => 5,
        actions_remaining => 100,
        money             => 500,
        achievements      => [],
        problems_resolved => 0,  # Reset this during initialization
    );
}

# Get player stats
sub get_stats {
    return %player;
}

# Update player stats
sub update_stats {
    my (%updates) = @_;
    foreach my $key (keys %updates) {
        if (exists $player{$key}) {
            $player{$key} = $updates{$key};
        } else {
            warn "Unknown player stat: $key\n";
        }
    }
}

# Add an achievement
sub add_achievement {
    my ($achievement) = @_;
    push @{$player{achievements}}, $achievement;
}

# Deduct actions
sub deduct_actions {
    my ($actions) = @_;
    if ($player{actions_remaining} >= $actions) {
        $player{actions_remaining} -= $actions;
        return 1; # Success
    } else {
        warn "Not enough actions remaining!\n";
        return 0; # Failure
    }
}

# Display player stats (ASCII output)
sub display_stats {
    print "================ Player Stats ================\n";
    print "Free Users       : $player{free_users}\n";
    print "Paying Users     : $player{paying_users}\n";
    print "Satisfaction     : $player{satisfaction}%\n";
    print "Hardware Quality : $player{hardware_quality}/10\n";
    print "Actions Remaining: $player{actions_remaining}\n";
    print "Money            : \$ $player{money}\n";
    print "Achievements     : ", join(", ", @{$player{achievements}}), "\n";
    print "Problems Resolved: $player{problems_resolved}\n";
    print "=============================================\n";
}

1; # Return true for module loading