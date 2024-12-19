package Score;

use strict;
use warnings;

# Scoring weight configuration
my %weights = (
    user_satisfaction => 0.4,  # 40% weight
    number_of_users   => 0.3,  # 30% weight
    hardware_quality  => 0.2,  # 20% weight
    problem_efficiency => 0.1, # 10% weight
);

# Calculate the score
sub calculate_score {
    my (%stats) = @_;

    # Normalize values
    my $total_users = $stats{free_users} + $stats{paying_users};
    my $normalized_satisfaction = $stats{satisfaction} / 100;
    my $normalized_users = (($stats{free_users} * 0.5) + $stats{paying_users}) / ($total_users || 1);
    my $normalized_hardware = $stats{hardware_quality} / 10; # Assume max hardware quality is 10
    my $normalized_efficiency = ($stats{problems_resolved} // 0) / 10; # Use default if undefined

    # Weighted score calculation
    my $score = (
        $normalized_satisfaction * $weights{user_satisfaction} +
        $normalized_users * $weights{number_of_users} +
        $normalized_hardware * $weights{hardware_quality} +
        $normalized_efficiency * $weights{problem_efficiency}
    ) * 1000;  # Scale to a 1000-point system

    return int($score); # Round to integer
}

# Display score details
sub display_score {
    my ($score, %stats) = @_;

    print "\n================ Score Report =================\n";
    print "User Satisfaction : $stats{satisfaction}%\n";
    print "Total Users       : $stats{free_users} free, $stats{paying_users} paying\n";
    print "Hardware Quality  : $stats{hardware_quality}/10\n";
    print "Problem Efficiency: $stats{problems_resolved}/10\n";
    print "Final Score       : $score\n";
    print "=============================================\n";
}

1; # Return true for module loading