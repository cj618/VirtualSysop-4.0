package Player;

use strict;
use warnings;
use POSIX qw(strftime);
use Data;

# Player stats storage
my %player_data = (
    free_users        => 0,
    paying_users      => 0,
    money             => 1000,  # Initial money for demonstration purposes
    employees         => 0,
    satisfaction      => 50,
    expenses          => 0,
    actions_remaining => 100,
    daily_action_limit => 100,
    last_action_date  => strftime("%Y-%m-%d", localtime),
    inventory         => {},   # Inventory for purchased items
    achievements      => [],   # Initialize as an array reference
    hardware_level    => 0,    # Tracks CPU hardware level
);

# Initialize player stats
sub initialize {
    %player_data = (
        free_users        => 0,
        paying_users      => 0,
        money             => 1000,
        employees         => 0,
        satisfaction      => 50,
        expenses          => 0,
        actions_remaining => 100,
        daily_action_limit => 100,
        last_action_date  => strftime("%Y-%m-%d", localtime),
        inventory         => {},   # Initialize inventory
        achievements      => [],
        hardware_level    => 0,    # Initial hardware level
    );
}

# Get current player stats
sub get_stats {
    _reset_daily_actions_if_needed();
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
    _reset_daily_actions_if_needed();

    if ($player_data{actions_remaining} >= $actions) {
        $player_data{actions_remaining} -= $actions;
        return 1;  # Success
    } else {
        return 0;  # Failure: Not enough actions remaining
    }
}

# Add daily action limit
sub increase_daily_action_limit {
    my ($amount) = @_;
    $player_data{daily_action_limit} += $amount;
    $player_data{actions_remaining} += $amount;  # Reflect the increase immediately
}

# Reset daily actions if it's a new day
sub _reset_daily_actions_if_needed {
    my $current_date = strftime("%Y-%m-%d", localtime);

    if ($player_data{last_action_date} ne $current_date) {
        $player_data{actions_remaining} = $player_data{daily_action_limit};
        $player_data{last_action_date} = $current_date;
    }
}

# Upgrade hardware based on milestones
sub upgrade_hardware {
    my $cpu_list = Data::get_data('cpu');
    return unless @$cpu_list;

    if ($player_data{hardware_level} < @$cpu_list - 1) {
        $player_data{hardware_level}++;
        my $new_hardware = $cpu_list->[$player_data{hardware_level}];
        Event::log_event({ description => "Hardware upgraded to: $new_hardware", impact => { satisfaction => 5 } });
        $player_data{satisfaction} += 5;  # Increase satisfaction due to upgrade
    }
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

1; # Return true for module loading
