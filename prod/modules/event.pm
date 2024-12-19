package Event;

use strict;
use warnings;

# Trigger random events based on probabilities
sub trigger_events {
    my @events;

    # Random event: User surge
    if (int(rand(100)) < 20) {
        push @events, {
            description => "A popular post on your BBS has gone viral!",
            impact => {
                free_users => int(rand(50)) + 50,
                paying_users => int(rand(10)) + 10,
                satisfaction => 5,
            },
        };
    }

    # Random event: Virus attack
    if (int(rand(100)) < 10) {
        push @events, {
            description => "A virus has infiltrated your system!",
            impact => {
                satisfaction => -10,
                money => -100,
            },
        };
    }

    # Random event: System upgrade success
    if (int(rand(100)) < 15) {
        push @events, {
            description => "Your recent system upgrade has boosted performance!",
            impact => {
                satisfaction => 10,
                free_users => int(rand(20)) + 10,
            },
        };
    }

    return @events;
}

# Network-related events
sub network_events {
    my ($interaction_type, $rival_name) = @_;

    if ($interaction_type eq 'partnership') {
        return {
            description => "Your partnership with $rival_name has brought mutual growth!",
            impact => {
                free_users => int(rand(30)) + 20,
                paying_users => int(rand(10)) + 5,
                money => int(rand(200)) + 100,
            },
        };
    } elsif ($interaction_type eq 'competition') {
        return {
            description => "Your competition with $rival_name has disrupted their user base!",
            impact => {
                free_users => int(rand(50)) + 30,
                satisfaction => -5,
                money => int(rand(150)) + 50,
            },
        };
    } else {
        return {
            description => "No notable events occurred during this interaction.",
            impact => {},
        };
    }
}

1; # Return true for module loading
