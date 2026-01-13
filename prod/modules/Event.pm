package Event;

use strict;
use warnings;
use Data;

# Log events dynamically
my @event_log;

sub log_event {
    my ($event) = @_;
    push @event_log, $event;
    shift @event_log if @event_log > 10; # Keep only the last 10 events
}

sub get_recent_events {
    return @event_log;
}

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
        my $virus_event = trigger_virus_event();
        push @events, $virus_event if $virus_event;
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

    # Random disaster from msgsv.dat
    if (int(rand(100)) < 5) {
        my $disaster_event = trigger_disaster_event();
        push @events, $disaster_event if $disaster_event;
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

# Trigger work-related events from msgsa.dat
sub trigger_work_event {
    my $events = Data::get_data('msgsa');
    return unless $events && @$events;

    my $event = $events->[rand @$events];

    return {
        description => $event->{text},
        impact      => {
            satisfaction => $event->{value},
        },
    };
}

# Trigger user mail from msgsr.dat
sub trigger_mail_event {
    my $mail = Data::get_data('msgsr');
    return unless $mail && @$mail;

    my $message = $mail->[rand @$mail];

    return {
        description => $message->{text},
        action      => $message->{action},
        value       => $message->{value},
    };
}

# Trigger a virus event from virus.dat
sub trigger_virus_event {
    my $viruses = Data::get_data('viruses');
    return unless $viruses && @$viruses;

    my $virus_name = $viruses->[rand @$viruses];

    return {
        description => "Your system was infected by the $virus_name virus!",
        impact      => {
            satisfaction => -10,
            money        => -100,
        },
    };
}

# Trigger a random disaster from msgsv.dat
sub trigger_disaster_event {
    my $disasters = Data::get_data('msgsv');
    return unless $disasters && @$disasters;

    my $disaster = $disasters->[rand @$disasters];

    return {
        description => $disaster->{text},
        impact      => {
            satisfaction => $disaster->{value},
            money        => 0,
        },
    };
}

1; # Return true for module loading
