package Event;

use strict;
use warnings;
use List::Util qw(shuffle);

# Event pool (define various events)
my @events = (
    { description => 'Your system experienced a small crash.', impact => { satisfaction => -5 } },
    { description => 'A popular user promoted your BBS!', impact => { free_users => 20 } },
    { description => 'A competitor launched a new feature.', impact => { satisfaction => -3 } },
    { description => 'Your antivirus caught a potential threat.', impact => { virus_protection => 1 } },
);

# Rare events
my @rare_events = (
    { description => 'A celebrity endorsed your BBS!', impact => { free_users => 50, paying_users => 10 } },
    { description => 'Major hardware failure!', impact => { hardware_quality => -5, satisfaction => -10 } },
    { description => 'A viral post brought in a surge of users!', impact => { free_users => 100 } },
);

# Trigger random events
sub trigger_events {
    my @triggered_events;

    # Randomly add a common event
    if (rand() < 0.8) { # 80% chance for a common event
        my $event = (shuffle @events)[0];
        push @triggered_events, $event;
    }

    # Randomly add a rare event
    if (rand() < 0.2) { # 20% chance for a rare event
        my $rare_event = (shuffle @rare_events)[0];
        push @triggered_events, $rare_event;
    }

    return @triggered_events;
}

# Add new events dynamically (for Mall of the Future purchases)
sub add_event {
    my ($event) = @_;
    push @events, $event;
}

# Add a new rare event dynamically
sub add_rare_event {
    my ($rare_event) = @_;
    push @rare_events, $rare_event;
}

1; # Return true for module loading