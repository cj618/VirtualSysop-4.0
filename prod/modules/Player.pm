package Player;

use strict;
use warnings;
use POSIX qw(strftime);
use Data;

# Player stats storage
my %player_data = (
    free_users         => 0,
    paying_users       => 0,
    money              => 1000,  # Initial money for demonstration purposes
    employees          => 1,
    satisfaction       => 50,
    expenses           => 0,
    actions_remaining  => 100,
    daily_action_limit => 100,
    last_action_date   => strftime("%Y-%m-%d", localtime),
    inventory          => {},   # Inventory for purchased items
    achievements       => [],   # Initialize as an array reference
    hardware_level     => 0,    # Tracks CPU hardware level
    phone_lines        => 1,    # Initial number of phone lines
    modem_level        => 0,    # Tracks the player's modem level
);

# Initialize player stats
sub initialize {
    %player_data = (
        free_users         => 0,
        paying_users       => 0,
        money              => 1000,
        employees          => 1,
        satisfaction       => 50,
        expenses           => 0,
        actions_remaining  => 100,
        daily_action_limit => 100,
        last_action_date   => strftime("%Y-%m-%d", localtime),
        inventory          => {},
        achievements       => [],
        hardware_level     => 0,
        phone_lines        => 1,
        modem_level        => 0,
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
        print "Hardware upgraded to: $new_hardware\n";
        $player_data{satisfaction} += 5;  # Increase satisfaction due to upgrade
    }
}

sub upgrade_modem {
    my $modem_list = Data::get_data('modems') // [];
    return unless @$modem_list;

    if ($player_data{modem_level} < @$modem_list - 1) {
        $player_data{modem_level}++;
        my $new_modem = $modem_list->[$player_data{modem_level}];
        my $display_name = $new_modem;
        if (ref($new_modem) eq 'HASH') {
            my $speed = $new_modem->{speed} ? " ($new_modem->{speed} baud)" : '';
            $display_name = ($new_modem->{name} // 'Unknown') . $speed;
        }
        print "Modem upgraded to: $display_name\n";
        $player_data{satisfaction} += 3;
    }
}

# Purchase a modem
sub purchase_modem {
    my $modem_list = Data::get_data('modems');
    return unless @$modem_list;

    if ($player_data{modem_level} < @$modem_list - 1) {
        my $next_modem = $modem_list->[$player_data{modem_level} + 1];

        if ($player_data{money} >= $next_modem->{cost}) {
            $player_data{money} -= $next_modem->{cost};
            $player_data{modem_level}++;
            print "Purchased modem: $next_modem->{name}\n";
        } else {
            print "Not enough money to purchase: $next_modem->{name}\n";
        }
    } else {
        print "You already have the best modem available!\n";
    }
}

# Add or remove phone lines
sub modify_phone_lines {
    my ($lines_to_add) = @_;
    my $cost_per_line = 50;
    my $total_cost = $lines_to_add * $cost_per_line;

    if ($lines_to_add > 0 && $player_data{money} >= $total_cost) {
        $player_data{phone_lines} += $lines_to_add;
        $player_data{money} -= $total_cost;
        print "Added $lines_to_add phone lines for \$ $total_cost.\n";
    } elsif ($lines_to_add < 0 && $player_data{phone_lines} + $lines_to_add >= 1) {
        $player_data{phone_lines} += $lines_to_add;
        print "Removed " . abs($lines_to_add) . " phone lines.\n";
    } else {
        print "Invalid operation. Either insufficient funds or trying to reduce below 1 line.\n";
    }
}

# Check for upgrades based on player stats and milestones
sub check_for_upgrades {
    if (Data::random_hardware_upgrade()) {
        upgrade_hardware();
    }
    if (Data::random_modem_upgrade()) {
        upgrade_modem();
    }
    _maybe_trigger_setback();
}

sub _maybe_trigger_setback {
    my $setback_chance = 3; # percent chance per check
    return if int(rand(100)) >= $setback_chance;

    if ($player_data{hardware_level} > 0 && int(rand(100)) < 50) {
        $player_data{hardware_level}--;
        my $cpu_list = Data::get_data('cpu') // [];
        my $current_hardware = $cpu_list->[$player_data{hardware_level}] // 'Unknown';
        print "Hardware failure! Downgraded to: $current_hardware\n";
        $player_data{satisfaction} -= 5;
    } else {
        print "Unexpected maintenance costs hit your budget.\n";
        $player_data{money} -= 100 if $player_data{money} >= 100;
        $player_data{satisfaction} -= 3;
    }
    $player_data{satisfaction} = 0 if $player_data{satisfaction} < 0;
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
