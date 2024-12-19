package Player;

use strict;
use warnings;

# Player stats storage
my %player_data = (
    free_users      => 0,
    paying_users    => 0,
    money           => 1000,  # Initial money for demonstration purposes
    employees       => 1,
    satisfaction    => 50,
    expenses        => 0,
    actions_remaining => 100,
    inventory       => {},   # Inventory for purchased items
    achievements    => [],   # Initialize as an array reference
);

# Initialize player stats
sub initialize {
    %player_data = (
        free_users      => 0,
        paying_users    => 0,
        money           => 1000,
        employees       => 1,
        satisfaction    => 50,
        expenses        => 0,
        actions_remaining => 100,
        inventory       => {},   # Initialize inventory
        achievements    => [],
    );
}

# Get current player stats
sub get_stats {
    return %player_data;
}

# Update player stats
sub update_stats {
    my (%new_stats) = @_;
    foreach my $key (keys %new_stats) {
        $player_data{$key} = $new_stats{$key} if exists $player_data{$key};
    }
}

# Deduct actions
sub deduct_actions {
    my ($actions) = @_;
    $player_data{actions_remaining} -= $actions;
    $player_data{actions_remaining} = 0 if $player_data{actions_remaining} < 0;
}

# Add achievements
sub add_achievement {
    my ($achievement) = @_;
    push @{$player_data{achievements}}, $achievement;
}

# Purchase an item and update inventory/stats
sub purchase_item {
    my ($item_name, $item_cost, $effects) = @_;
    if ($player_data{money} >= $item_cost) {
        $player_data{money} -= $item_cost;

        # Add item to inventory
        $player_data{inventory}{$item_name} = ($player_data{inventory}{$item_name} // 0) + 1;

        # Apply effects
        foreach my $key (keys %$effects) {
            $player_data{$key} += $effects->{$key};
        }
        return 1;  # Success
    }
    return 0;  # Insufficient funds
}

# Save game to file
sub save_game {
    my ($filename) = @_;
    open my $fh, '>', $filename or die "Cannot open file $filename: $!";
    foreach my $key (keys %player_data) {
        if (ref($player_data{$key}) eq 'ARRAY') {
            print $fh "$key=" . join(',', @{$player_data{$key}}) . "\n";
        } elsif (ref($player_data{$key}) eq 'HASH') {
            print $fh "$key=" . join(',', map { "$_:$player_data{$key}{$_}" } keys %{$player_data{$key}}) . "\n";
        } else {
            print $fh "$key=$player_data{$key}\n";
        }
    }
    close $fh;
}

# Load game from file
sub load_game {
    my ($filename) = @_;
    open my $fh, '<', $filename or die "Cannot open file $filename: $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($key, $value) = split /=/, $line, 2;
        if (exists $player_data{$key}) {
            if (ref($player_data{$key}) eq 'ARRAY') {
                @{$player_data{$key}} = split /,/, $value;
            } elsif (ref($player_data{$key}) eq 'HASH') {
                %{$player_data{$key}} = map { split /:/ } split /,/, $value;
            } else {
                $player_data{$key} = $value;
            }
        }
    }
    close $fh;
}

# Get actions remaining
sub get_actions_remaining {
    return $player_data{actions_remaining};
}

# Get inventory
sub get_inventory {
    return $player_data{inventory};
}

1; # Return true for module loading