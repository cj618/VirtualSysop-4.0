#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);
use POSIX qw(strftime);

# Tell it where the modules live
use lib './modules';

# Import modules
use Data;
use Event;
use Player;
use UI;
use Score;
use Rival;
use Reports;

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
    print "Enter the name of your saved BBS (without extension): ";
    my $save_file = <STDIN>;
    chomp($save_file);
    $save_file = "$USER_DIR/$save_file.vso";
    if (-e $save_file) {
        Player::load_game($save_file);
        print "Game loaded successfully!\n";
        ($bbs_name) = $save_file =~ m|/([^/]+)\.vso$|;
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

# Track player stats history for reports
my @stats_history;

# Game loop state
my $game_running = 1;
my $screen_cleared = 0; # Track whether the screen has been cleared

# Main game loop
while ($game_running) {
    # Clear the screen only once at the beginning
    if (!$screen_cleared) {
        clear_screen();
        $screen_cleared = 1;
    }

    # Capture current player stats for history tracking
    my %player_stats = Player::get_stats();
    my $current_time = time;
    push @stats_history, { %player_stats, timestamp => $current_time };

    # Display BBS admin console header
    my $formatted_time = strftime("%Y-%m-%d %H:%M:%S", localtime($current_time));
    my $current_score = Score::calculate_score(%player_stats);

    print "===========================================\n";
    print "*** $bbs_name Admin Console ***\n";
    print "Date and Time: $formatted_time\n";
    print "===========================================\n";
    print "Commands:\n";
    print "    W - Work on your BBS to attract users and resources.\n";
    print "    M - Mall of the Future.\n";
    print "    V - Scan for and remove viruses from your system.\n";
    print "    R - View reports on your progress and score.\n";
    print "    N - Network with rivals.\n";
    print "    S - Save Game.\n";
    print "    C - Clear Screen.\n";
    print "    Q - Quit the game.\n";
    print "\n===========================================\n";
    print "Current Score: $current_score   ||  Remaining Actions: $player_stats{actions_remaining}\n";
    print "===========================================\n";
    print "\nCommand: ";

    # Get player command
    my $command = UI::get_player_input();

    if ($command eq 'W') {
        # Work command
        my @events = Event::trigger_events();
        foreach my $event (@events) {
            UI::display_event($event);
            # Apply event impacts to player stats
            foreach my $key (keys %{$event->{impact}}) {
                $player_stats{$key} += $event->{impact}{$key};
            }
        }
        Player::update_stats(%player_stats);
        Player::deduct_actions(10); # Deduct 10 actions for working
    } elsif ($command eq 'M') {
        # Mall of the Future command
        my $updated_stats = UI::handle_purchase(\%player_stats);
        %player_stats = %$updated_stats;
    } elsif ($command eq 'V') {
        # Virus scan command
        my @events = Event::trigger_events();
        foreach my $event (@events) {
            UI::display_event($event);
            # Apply event impacts to player stats
            foreach my $key (keys %{$event->{impact}}) {
                $player_stats{$key} += $event->{impact}{$key};
            }
        }
        Player::update_stats(%player_stats);
        Player::deduct_actions(8); # Deduct 8 actions for virus scanning
    } elsif ($command eq 'R') {
        # Reports command
        print "\nChoose a report to view:\n";
        print "    1 - User Growth\n";
        print "    2 - Satisfaction and Hardware Quality\n";
        print "    3 - Financial Report\n";
        print "    C - Cancel\n";
        print "\nEnter your choice: ";
        my $report_choice = <STDIN>;
        chomp($report_choice);

        if ($report_choice eq '1') {
            Reports::generate_user_growth_report(\@stats_history);
        } elsif ($report_choice eq '2') {
            Reports::generate_satisfaction_report(\@stats_history);
        } elsif ($report_choice eq '3') {
            Reports::generate_financial_report(\@stats_history);
        } elsif (uc($report_choice) eq 'C') {
            print "Returning to main menu.\n";
        } else {
            print "Invalid choice. Returning to main menu.\n";
        }
    } elsif ($command eq 'N') {
        # Network command
        Rival::display_rivals();
        print "\nChoose a rival to interact with (enter name or type C to cancel): ";
        my $rival_name = <STDIN>;
        chomp($rival_name);

        if (uc($rival_name) eq 'C') {
            print "Returning to main menu.\n";
        } else {
            print "Choose an action: (P)artnership or (C)ompetition: ";
            my $action = <STDIN>;
            chomp($action);

            if (uc($action) eq 'P') {
                my $result = Rival::interact_with_rival($rival_name, 'partnership');
                foreach my $key (keys %$result) {
                    $player_stats{$key} += $result->{$key};
                }
            } elsif (uc($action) eq 'C') {
                my $result = Rival::interact_with_rival($rival_name, 'competition');
                foreach my $key (keys %$result) {
                    $player_stats{$key} += $result->{$key};
                }
            } else {
                print "Invalid action. Returning to main menu.\n";
            }
        }
    } elsif ($command eq 'S') {
        # Save game command
        my $save_file = "$USER_DIR/$bbs_name.vso";
        Player::save_game($save_file);
        print "Game saved successfully to $save_file\n";
    } elsif ($command eq 'C') {
        # Clear screen command
        clear_screen();
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