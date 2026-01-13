package Data;

use strict;
use warnings;

# Hash to store parsed data
my %data_store;

# Function to load and parse a file
sub load_file {
    my ($filename) = @_;

    # Check if the file exists
    unless (-e $filename) {
        die "File not found: $filename\n";
    }

    # Determine file type based on name and parse accordingly
    if ($filename =~ /msgsa\.dat$/i) {
        _parse_msg_file($filename, 'msgsa');
    } elsif ($filename =~ /msgsr\.dat$/i) {
        _parse_msg_file($filename, 'msgsr');
    } elsif ($filename =~ /msgsv\.dat$/i) {
        _parse_msg_file($filename, 'msgsv');
    } elsif ($filename =~ /text\.dat$/i) {
        _parse_text_file($filename);
    } elsif ($filename =~ /virus\.dat$/i) {
        _parse_list_file($filename, 'viruses');
    } elsif ($filename =~ /cpu\.dat$/i) {
        _parse_list_file($filename, 'cpu');
    } elsif ($filename =~ /modems\.dat$/i) {
        _parse_modems_file($filename);
    } else {
        warn "Unknown file type: $filename\n";
    }
}

# Function to retrieve parsed data
sub get_data {
    my ($type) = @_;
    return $data_store{$type};
}

# Parse message files (msgsa.dat, msgsr.dat, msgsv.dat)
sub _parse_msg_file {
    my ($filename, $key) = @_;
    open my $fh, '<', $filename or die "Cannot open $filename: $!\n";

    my @entries;
    my %current_entry;

    while (my $line = <$fh>) {
        chomp($line);
        if ($line =~ /^!@#$/) {
            # Save the current entry if it exists
            push @entries, {%current_entry} if %current_entry;
            %current_entry = (action => undef, value => undef, text => '');
        } elsif ($line =~ /^\d+$/) {
            if (!defined $current_entry{action}) {
                $current_entry{action} = $line;
            } elsif (!defined $current_entry{value}) {
                $current_entry{value} = $line;
            }
        } else {
            $current_entry{text} .= "$line\n";
        }
    }

    # Save the last entry
    push @entries, {%current_entry} if %current_entry;
    $data_store{$key} = \@entries;

    close $fh;
}

# Parse text.dat
sub _parse_text_file {
    my ($filename) = @_;
    open my $fh, '<', $filename or die "Cannot open $filename: $!\n";

    my %text_entries;

    while (my $line = <$fh>) {
        chomp($line);
        next if $line =~ /^;/;  # Skip comments
        if ($line =~ /^(\d{4})\s+(.*)$/) {
            $text_entries{$1} = $2;
        }
    }

    $data_store{text} = \%text_entries;
    close $fh;
}

# Parse simple list files like virus.dat or CPU.DAT
sub _parse_list_file {
    my ($filename, $key) = @_;
    open my $fh, '<', $filename or die "Cannot open $filename: $!\n";

    my @list;
    while (my $line = <$fh>) {
        chomp($line);
        push @list, $line unless $line =~ /^\s*$/;  # Skip empty lines
    }

    $data_store{$key} = \@list;
    close $fh;
}

# Parse modems.dat
sub _parse_modems_file {
    my ($filename) = @_;
    open my $fh, '<', $filename or die "Cannot open $filename: $!\n";

    my @modems;
    while (my $line = <$fh>) {
        chomp($line);
        next if $line =~ /^\s*$/;  # Skip empty lines
        my ($name, $speed, $cost) = split /\|/, $line;
        $cost //= 0;
        push @modems, { name => $name, speed => $speed, cost => $cost };
    }

    $data_store{modems} = \@modems;
    close $fh;
}

# Randomly trigger less frequent hardware upgrades
sub random_hardware_upgrade {
    my $probability = int(rand(100));
    return $probability < 5;  # 5% chance for upgrade event
}

sub random_modem_upgrade {
    my $probability = int(rand(100));
    return $probability < 5;  # 5% chance for upgrade event
}

1; # Return true for module loading
