package Rival;

use strict;
use warnings;

# Store rival stats
my %rivals = (
    "UltraNet" => { users => 500, money => 1000, satisfaction => 70 },
    "DataDome" => { users => 450, money => 800, satisfaction => 65 },
    "FastWave" => { users => 300, money => 1200, satisfaction => 75 },
);

# Display a list of rivals
sub display_rivals {
    print "\nRival BBS Systems:\n";
    print "===========================================\n";
    foreach my $name (keys %rivals) {
        print "$name:\n";
        print "    Users: $rivals{$name}{users}\n";
        print "    Money: \$ $rivals{$name}{money}\n";
        print "    Satisfaction: $rivals{$name}{satisfaction}\n\n";
    }
    print "===========================================\n\n";
}

# Interact with a rival
sub interact_with_rival {
    my ($rival_name, $action) = @_;

    if (!exists $rivals{$rival_name}) {
        print "Rival BBS not found.\n";
        return;
    }

    if ($action eq 'partnership') {
        return _form_partnership($rival_name);
    } elsif ($action eq 'competition') {
        return _engage_competition($rival_name);
    } else {
        print "Invalid action.\n";
        return;
    }
}

# Form a partnership with a rival
sub _form_partnership {
    my ($rival_name) = @_;

    print "\nYou have formed a partnership with $rival_name!\n";
    my %impact = (
        free_users => 50,
        paying_users => 20,
        money => 200,
    );

    # Update rival stats
    $rivals{$rival_name}{users} += 30;
    $rivals{$rival_name}{money} += 150;

    return \%impact;
}

# Engage in competition with a rival
sub _engage_competition {
    my ($rival_name) = @_;

    print "\nYou are competing with $rival_name!\n";

    my $player_gain = int(rand(50)) + 50;
    my $rival_loss = int(rand(30)) + 20;

    my %impact = (
        free_users => $player_gain,
        money => 100,
    );

    # Reduce rival stats
    $rivals{$rival_name}{users} -= $rival_loss;
    $rivals{$rival_name}{satisfaction} -= 5;

    return \%impact;
}

# Update rival stats dynamically
sub update_rivals {
    foreach my $name (keys %rivals) {
        $rivals{$name}{users} += int(rand(10));
        $rivals{$name}{money} += int(rand(50));
        $rivals{$name}{satisfaction} += int(rand(3)) - 1; # Satisfaction fluctuates slightly
        $rivals{$name}{satisfaction} = 100 if $rivals{$name}{satisfaction} > 100;
        $rivals{$name}{satisfaction} = 0 if $rivals{$name}{satisfaction} < 0;
    }
}

1; # Return true for module loading