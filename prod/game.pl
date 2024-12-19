#!/usr/bin/perl

use strict;
use warnings;

# Import modules
use Data;
use Event;
use Player;
use UI;
use Score;

# Initialize game state
Player::initialize();

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
