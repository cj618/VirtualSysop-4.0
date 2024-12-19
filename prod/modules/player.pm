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
    achievements      => [],  # List of achievements
    problems_resolved => 0,   # Tracks resolved problems
    inventory         => {},  # Tracks purchased items
);

# Blowfish encryption key (must be 8 bytes)
my $blowfish_key = 'BBSGame!';

# Initialize the player profile
sub initialize {
    %player = (
        free_users        => 50,
        paying_users      => 10,
        satisfaction      => 75,
        hardware_quality  => 5,
        actions_remaining => 100,
        money             => 500,
        achievements      => [],
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

# Add an achievement
sub add_achievement {
    my ($achievement) = @_;
    push @{$player{achievements}}, $achievement;
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
