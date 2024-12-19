package Score;

use strict;
use warnings;

# Recalculate success metrics based on updated game dynamics
sub recalculate_metrics {
    my (%player_stats) = @_;

    # Calculate money based on paid users
    my $income_from_users = $player_stats{paying_users} * 10; # Each paying user generates $10
    my $expenses = $player_stats{expenses} || 0; # Track expenses dynamically
    
    # Update money
    $player_stats{money} += $income_from_users - $expenses;

    # Ensure money doesn't go negative
    $player_stats{money} = 0 if $player_stats{money} < 0;

    # Free users increase satisfaction
    $player_stats{satisfaction} += int($player_stats{free_users} / 50);
    $player_stats{satisfaction} = 100 if $player_stats{satisfaction} > 100;

    return %player_stats;
}

# Display key success metrics
sub display_metrics {
    my (%player_stats) = @_;

    print "===========================================\n";
    print "Success Metrics:\n";
    print "  Free Users: $player_stats{free_users}\n";
    print "  Paying Users: $player_stats{paying_users}\n";
    print "  Money: \$ $player_stats{money}\n";
    print "  Employees: $player_stats{employees}\n";
    print "===========================================\n";
}

# Deduct expenses for purchases or events
sub deduct_expenses {
    my ($amount, %player_stats) = @_;

    $player_stats{expenses} += $amount;
    print "\$ $amount has been deducted for expenses.\n";

    return %player_stats;
}

# Update metrics after each action
sub update_after_action {
    my ($action_type, %player_stats) = @_;

    if ($action_type eq 'work') {
        $player_stats{free_users} += int(rand(20));
        $player_stats{paying_users} += int(rand(5));
    } elsif ($action_type eq 'virus_scan') {
        $player_stats{free_users} -= int(rand(10));
        $player_stats{satisfaction} += 2;
    } elsif ($action_type eq 'network') {
        $player_stats{free_users} += int(rand(15));
    }

    return %player_stats;
}

1; # Return true for module loading