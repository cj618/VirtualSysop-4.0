package Player;

use strict;
use warnings;
use Storable qw(nfreeze thaw);
use Crypt::Blowfish;
use MIME::Base64;

# Player stats
my %player = (
    free_users        => 50,
    paying_users      => 10,
    satisfaction      => 75,  # Percentage
    hardware_quality  => 5,   # Out of 10
    actions_remaining => 100, # Actions per day
    money             => 500, # Starting currency
    achievements      => {},  # Tracks unlocked achievements
    problems_resolved => 0,   # Tracks resolved problems
    inventory         => {},  # Tracks purchased items
);

# Blowfish encryption key (must be 8 bytes)
my $blowfish_key = 'BBSGame!';

# Define possible achievements
my @achievements = (
    { id => '100_free_users', description => 'Reached 100 free users.', condition => sub { $player{free_users} >= 100 } },
    { id => '50_paying_users', description => 'Reached 50 paying users.', condition => sub { $player{paying_users} >= 50 } },
    { id => 'hardware_max', description => 'Hardware quality is 10/10.', condition => sub { $player{hardware_quality} == 10 } },
    { id => 'high_satisfaction', description => 'Satisfaction score is 90% or more.', condition => sub { $player{satisfaction} >= 90 } },
    { id => 'wealthy', description => 'Accumulated $1000 or more.', condition => sub { $player{money} >= 1000 } },
);

# Initialize the player profile
sub initialize {
    %player = (
        free_users        => 50,
        paying_users      => 10,
        satisfaction      => 75,
        hardware_quality  => 5,
        actions_remaining => 100,
        money             => 500,
        achievements      => {},
        problems_resolved => 0,
        inventory         => {},
    );
}

# Get player stats
sub get_stats {
    return %player;
}

# Update player stats
sub update_stats {
    my (%updates) = @_;
    foreach my $key (keys %updates) {
        if (exists $player{$key}) {
            $player{$key} = $updates{$key};
        } else {
            warn "Unknown player stat: $key\n";
        }
    }
}

# Check and unlock achievements
sub check_achievements {
    my @new_achievements;
    foreach my $achievement (@achievements) {
        if (!$player{achievements}{$achievement->{id}} && $achievement->{condition}->()) {
            $player{achievements}{$achievement->{id}} = 1;
            push @new_achievements, $achievement->{description};
        }
    }
    return @new_achievements;
}

# Get unlocked achievements
sub get_achievements {
    return keys %{$player{achievements}};
}

# Deduct actions
sub deduct_actions {
    my ($actions) = @_;
    if ($player{actions_remaining} >= $actions) {
        $player{actions_remaining} -= $actions;
        return 1; # Success
    } else {
        warn "Not enough actions remaining!\n";
        return 0; # Failure
    }
}

# Add an item to the inventory
sub add_to_inventory {
    my ($item, $quantity) = @_;
    $quantity ||= 1; # Default quantity is 1
    $player{inventory}{$item} += $quantity;
}

# Get inventory
sub get_inventory {
    return %{$player{inventory}};
}

# Save player data to a file
sub save_game {
    my ($filename) = @_;
    my $cipher = Crypt::Blowfish->new($blowfish_key);
    
    # Serialize player data
    my $serialized = nfreeze(\%player);
    
    # Encrypt the data
    my $encrypted = '';
    for (my $i = 0; $i < length($serialized); $i += 8) {
        my $block = substr($serialized, $i, 8);
        $block .= chr(0) x (8 - length($block)) if length($block) < 8;
        $encrypted .= $cipher->encrypt($block);
    }
    
    # Encode as Base64 and save to file
    open my $fh, '>', $filename or die "Cannot open file: $filename\n";
    print $fh encode_base64($encrypted, '');
    close $fh;
    print "Game saved successfully to $filename\n";
}

# Load player data from a file
sub load_game {
    my ($filename) = @_;
    my $cipher = Crypt::Blowfish->new($blowfish_key);
    
    # Read and decode the file
    open my $fh, '<', $filename or die "Cannot open file: $filename\n";
    my $encoded = do { local $/; <$fh> };
    close $fh;
    my $encrypted = decode_base64($encoded);
    
    # Decrypt the data
    my $decrypted = '';
    for (my $i = 0; $i < length($encrypted); $i += 8) {
        $decrypted .= $cipher->decrypt(substr($encrypted, $i, 8));
    }
    
    # Deserialize and load player data
    %player = %{ thaw($decrypted) };
    print "Game loaded successfully from $filename\n";
}

1; # Return true for module loading