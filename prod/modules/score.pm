package Score;

use strict;
use warnings;

# Recalculate metrics dynamically based on player stats
sub recalculate_metrics {
    my (%player_stats) = @_;

    # Adjust user growth based on upgrades and satisfaction
    my $growth_multiplier = 1 + ($player_stats{satisfaction} / 100);
    $player_stats{free_users} += int($player_stats{inventory}->{"Server Rack"} * $growth_multiplier);
    $player_stats{paying_users} += int($player_stats{inventory}->{"Premium Subscription"} * $growth_multiplier / 2);

    # Adjust satisfaction based on actions and upgrades
    $player_stats{satisfaction} += $player_stats{inventory}->{"Entertainment System"} // 0;
    $player_stats{satisfaction} -= $player_stats{actions_remaining} < 10 ? 5 : 0; # Penalize low actions

    # Cap satisfaction at 100
    $player_stats{satisfaction} = 100 if $player_stats{satisfaction} > 100;
    $player_stats{satisfaction} = 0 if $player_stats{satisfaction} < 0;

    # Calculate expenses based on inventory and employees
    $player_stats{expenses} = ($player_stats{employees} * 50) + ($player_stats{inventory}->{"Server Rack"} * 10);
    $player_stats{money} -= $player_stats{expenses};

    # Prevent negative money
    $player_stats{money} = 0 if $player_stats{money} < 0;

    return %player_stats;
}

# Add achievements logic for score-based milestones
sub check_achievements {
    my (%player_stats) = @_;
    my @new_achievements;

    if ($player_stats{money} >= 5000 && !grep { $_ eq "Rich BBS Owner" } @{$player_stats{achievements}}) {
        push @new_achievements, "Rich BBS Owner";
    }
    if ($player_stats{paying_users} >= 100 && !grep { $_ eq "Top Tier Subscription" } @{$player_stats{achievements}}) {
        push @new_achievements, "Top Tier Subscription";
    }
    if ($player_stats{satisfaction} >= 90 && !grep { $_ eq "User Favorite" } @{$player_stats{achievements}}) {
        push @new_achievements, "User Favorite";
    }

    return @new_achievements;
}

# Adjust action costs dynamically
sub adjust_action_costs {
    my (%player_stats) = @_;

    my $base_cost = 10; # Default cost for actions like "Work"

    # Reduce action costs based on upgrades
    if ($player_stats{inventory}->{"Efficiency Suite"}) {
        $base_cost -= $player_stats{inventory}->{"Efficiency Suite"};
    }

    # Ensure costs don't go below a minimum value
    $base_cost = 1 if $base_cost < 1;

    return $base_cost;
}

1; # Return true for module loading