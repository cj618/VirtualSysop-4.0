package Event;

use strict;
use warnings;
use Data;

# Hash to store event probabilities and handlers
my %event_registry = (
    "work_action" => {
        probability => 0.5,  # 50% chance
        handler     => \&handle_work_event,
    },
    "problem_mail" => {
        probability => 0.2,  # 20% chance
        handler     => \&handle_problem_mail,
    },
    "virus_event" => {
        probability => 0.1,  # 10% chance
        handler     => \&handle_virus_event,
    },
    "positive_outcome" => {
        probability => 0.2,  # 20% chance
        handler     => \&handle_positive_outcome,
    },
);

# Function to trigger events based on probabilities
sub trigger_events {
    my @triggered_events;

    foreach my $event_type (keys %event_registry) {
        if (rand() < $event_registry{$event_type}{probability}) {
            push @triggered_events, $event_registry{$event_type}{handler}->();
        }
    }

    return @triggered_events;  # Return descriptions of triggered events
}

# Handlers for different event types

sub handle_work_event {
    my $events = Data::get_data('msgsa');
    return _random_event($events, "Work Event");
}

sub handle_problem_mail {
    my $events = Data::get_data('msgsr');
    return _random_event($events, "Problem Mail");
}

sub handle_virus_event {
    my $events = Data::get_data('msgsv');
    return _random_event($events, "Virus Event");
}

sub handle_positive_outcome {
    my $events = Data::get_data('msgsa');
    return _random_event($events, "Positive Outcome");
}

# Helper function to pick a random event from a list
sub _random_event {
    my ($events, $event_type) = @_;
    
    return "$event_type: No data available" unless $events && @$events;

    my $event = $events->[int(rand(@$events))];
    
    return {
        type => $event_type,
        description => $event->{text},
        action => $event->{action},
        value => $event->{value},
    };
}

1; # Return true for module loading