package Rival;

use strict;
use warnings;
use List::Util qw(shuffle);

# Data structure for rival BBSs
my @rivals = (
    { name => 'CyberNet Elite', free_users => 200, paying_users => 50, satisfaction => 80, hardware_quality => 7 },
    { name => 'Digital Haven', free_users => 150, paying_users => 30, satisfaction => 70, hardware_quality => 6 },
    { name => 'ByteStorm', free_users => 300, paying_users => 100, satisfaction => 85, hardware_quality => 9 },
);

# Get the list of rivals
sub get_rivals {
    return @rivals;
}

# Update rival stats (e.g., growth or events)
sub update_rivals {
    foreach my $rival (@rivals) {
        # Random user growth
        my $growth = int(rand(20));
        $rival->{free_users} += $growth;
        $rival->{paying_users} += int($growth / 4);

        # Random satisfaction changes
        $rival->{satisfaction} += int(rand(3)) - 1; # Slight fluctuation
        $rival->{satisfaction} = 100 if $rival->{satisfaction} > 100;
        $rival->{satisfaction} = 0 if $rival->{satisfaction} < 0;

        # Random hardware improvements
        if (rand() < 0.1) {
            $rival->{hardware_quality}++;
            $rival->{hardware_quality} = 10 if $rival->{hardware_quality} > 10;
        }

        # Add effects of rare events
        if (rand() < 0.1) { # 10% chance of rare impact
            my $event_type = int(rand(3));
            if ($event_type == 0) {
                $rival->{free_users} -= 30;
                print "$rival->{name} lost users due to a bad review.\n";
            } elsif ($event_type == 1) {
                $rival->{hardware_quality} -= 2;
                print "$rival->{name} suffered hardware failures.\n";
            } elsif ($event_type == 2) {
                $rival->{satisfaction} += 5;
                print "$rival->{name} implemented a successful marketing campaign.\n";
            }
        }
    }
}

# Handle rival interaction (partnership or competition)
sub interact_with_rival {
    my ($rival_name, $action) = @_;
    my ($rival) = grep { $_->{name} eq $rival_name } @rivals;

    if (!$rival) {
        warn "Rival not found: $rival_name\n";
        return;
    }

    if ($action eq 'partnership') {
        print "You formed a partnership with $rival->{name}.
";
        $rival->{satisfaction} += 5;
        return { free_users => 20, satisfaction => 5 }; # Boost to player's stats
    } elsif ($action eq 'competition') {
        print "You competed against $rival->{name}.
";
        my $success = rand() < 0.5; # 50% chance of success
        if ($success) {
            print "You successfully poached users from $rival->{name}!
";
            $rival->{free_users} -= 20;
            return { free_users => 20 }; # Boost to player's free users
        } else {
            print "$rival->{name} retaliated and poached your users!
";
            return { free_users => -10 }; # Loss to player's free users
        }
    } else {
        warn "Unknown action: $action\n";
    }
}

# Display rival stats
sub display_rivals {
    print "\nRival BBS Stats:\n";
    foreach my $rival (@rivals) {
        print "Name: $rival->{name}\n";
        print "  Free Users: $rival->{free_users}\n";
        print "  Paying Users: $rival->{paying_users}\n";
        print "  Satisfaction: $rival->{satisfaction}%\n";
        print "  Hardware Quality: $rival->{hardware_quality}/10\n";
        print "\n";
    }
}

1; # Return true for module loading