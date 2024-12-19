#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);
use POSIX qw(strftime);

# Import modules
use Data;
use Event;
use Player;
use UI;
use Score;

# Constants
my $USER_DIR = "users";

# Ensure user directory exists
make_path($USER_DIR) unless -d $USER_DIR;

# Clear the screen
sub clear_screen {
    print "\033[2J\033[H";  # ANSI escape codes to clear screen and reset cursor
}

# Prompt user to set or load BBS name
clear_screen();
print "Do you want to (L)oad an existing game or start a (N)ew game? ";
my $choice = <STDIN>;
chomp($choice);
my $bbs_name;
if (uc($choice) eq 'L') {
    print "Enter the name of the saved game file: ";
    my $save_file = <STDIN>;
    chomp($save_file);
    if (-e "$USER_DIR/$save_file") {
        Player::load_game("$USER_DIR/$save_file");
        print "Game loaded successfully!\n";
        $bbs_name = $save_file;
    } else {
        print "Save file not found. Starting a new game instead.\n";
        Player::initialize();
    }
} else {
    print "Enter the name of your BBS: ";
    $bbs_name = <STDIN>;
    chomp($bbs_name);
    Player::initialize();
}

# Load data files
Data::load_file('data/msgsa.dat');
Data::load_file('data/msgsr.dat');
Data::load_file('data/msgsv.dat');
Data::load_file('data/text.dat');
Data::load_file('data/virus.dat');

# Game loop state
my $game_running = 1;

# Main game loop
while ($game_running) {
    # Display BBS admin console header
    my $current_time = strftime("%Y-%m-%d %H:%M:%S", localtime);
    my %player_stats = Player::get_stats();
    my $current_score = Score::calculate_score(%player_stats);

    print "\n===========================================\n";
    print "$bbs_name Admin Console\n";
    print "Date and Time: $current_time\n";
    print "Current Score: $current_score\n";
    print "Remaining Actions: $player_stats{actions_remaining}\n";
    print "===========================================\n";

    # Display main menu
    UI::display_menu();
    
    # Get player command
    my $command = UI::get_player_input();

    if ($command eq 'W') {
        # Work command
        my @events = Event::trigger_events();
        foreach my $event (@events) {
            UI::display_event($event);
        }
        Player::deduct_actions(10); # Deduct 10 actions for working
    } elsif ($command eq 'M') {
        # Check mail command
        my @events = Event::trigger_events();
        foreach my $event (@events) {
            UI::display_event($event);
        }
        Player::deduct_actions(5); # Deduct 5 actions for checking mail
    } elsif ($command eq 'V') {
        # Virus scan command
        my @events = Event::trigger_events();
        foreach my $event (@events) {
            UI::display_event($event);
        }
        Player::deduct_actions(8); # Deduct 8 actions for virus scanning
    } elsif ($command eq 'S') {
        # Store command (placeholder)
        UI::display_message("Store functionality is under development.");
    } elsif ($command eq 'R') {
        # Report command
        my %stats = Player::get_stats();
        my $score = Score::calculate_score(%stats);
        Score::display_score($score, %stats);
    } elsif ($command eq 'C') {
        # Charge users command (placeholder)
        UI::display_message("Charge users functionality is under development.");
    } elsif ($command eq 'SAVE') {
        # Save game command
        print "Enter the filename to save your game: ";
        my $save_file = <STDIN>;
        chomp($save_file);
        Player::save_game("$USER_DIR/$save_file");
    } elsif ($command eq 'Q') {
        # Quit command
        $game_running = 0;
        my %stats = Player::get_stats();
        my $score = Score::calculate_score(%stats);
        UI::display_end_game($score, $stats{achievements});
    } else {
        # Invalid command
        UI::display_error("Invalid command. Please try again.");
    }
}

print "Game over. Goodbye!\n";

