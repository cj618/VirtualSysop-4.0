package Score;

use strict;
use warnings;

# Recalculate metrics dynamically based on player stats
sub recalculate_metrics {
    my (%player_stats) = @_;

    # Adjust metrics based on current player stats
    $player_stats{user_growth} = ($player_stats{free_users} * 0.5) + ($player_stats{paying_users} * 1.5);
    $player_stats{satisfaction} += ($player_stats{inventory}->{satisfaction_boost} // 0);
    $player_stats{money} -= $player_stats{expenses};

    # Cap satisfaction at 100
    $player_stats{satisfaction} = 100 if $player_stats{satisfaction} > 100;

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

1; # Return true for module loading