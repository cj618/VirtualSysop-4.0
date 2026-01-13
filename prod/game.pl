#!/usr/bin/perl

#
# Virtual SysOp 4.0 
#
# DEVELOPMENT VERSION
#

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
        print "Enter the name of your BBS: ";
        $bbs_name = <STDIN>;
        chomp($bbs_name);
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
Data::load_file('data/cpu.dat');
Data::load_file('data/modems.dat');

# Track player stats history for reports
my @stats_history;
my @rival_history;

# Game loop state
my $game_running = 1;

# Main game loop
while ($game_running) {
    # Capture current player stats for history tracking
    my %player_stats = Player::get_stats();
    %player_stats = Score::recalculate_metrics(%player_stats);
    my @new_achievements = Score::check_achievements(%player_stats);
    if (@new_achievements) {
        push @{$player_stats{achievements}}, @new_achievements;
    }
    Player::update_stats(%player_stats);

    my $current_time = time;
    push @stats_history, { %player_stats, timestamp => $current_time };

    # Display BBS admin console header
    UI::display_admin_console($bbs_name, \%player_stats, $current_time);

    # Get player command
    my $command = UI::get_player_input();

    if ($command eq 'W') {
        # Work command
        if (Player::deduct_actions(10)) {
            $player_stats{actions_remaining} -= 10;
            my @events = Event::trigger_events();
            my $work_event = Event::trigger_work_event();
            push @events, $work_event if $work_event;
            foreach my $event (@events) {
                UI::display_event($event);
                # Apply event impacts to player stats
                foreach my $key (keys %{$event->{impact}}) {
                    $player_stats{$key} += $event->{impact}{$key};
                }
            }
            Player::update_stats(%player_stats);
            Player::check_for_upgrades();
        } else {
            UI::display_error("Not enough actions remaining for this task.");
        }
    } elsif ($command eq 'M') {
        # Mall of the Future command
        my $updated_stats = UI::handle_purchase(\%player_stats);
        Player::update_stats(%$updated_stats);
    } elsif ($command eq 'V') {
        # Virus scan command
        if (Player::deduct_actions(8)) {
            $player_stats{actions_remaining} -= 8;
            my @events = Event::trigger_events();
            my $scan_event = Event::trigger_disaster_event();
            push @events, $scan_event if $scan_event;
            foreach my $event (@events) {
                UI::display_event($event);
                # Apply event impacts to player stats
                foreach my $key (keys %{$event->{impact}}) {
                    $player_stats{$key} += $event->{impact}{$key};
                }
            }
            Player::update_stats(%player_stats);
            Player::check_for_upgrades();
        } else {
            UI::display_error("Not enough actions remaining for this task.");
        }
    } elsif ($command eq 'R') {
        # Reports command
        print "\nChoose a report to view:\n";
        print "    1 - User Growth\n";
        print "    2 - Satisfaction and Hardware Quality\n";
        print "    3 - Financial Report\n";
        print "    4 - Inventory Report\n";
        print "    5 - Rival Interactions Report\n";
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
        } elsif ($report_choice eq '4') {
            Reports::generate_inventory_report(\%player_stats);
        } elsif ($report_choice eq '5') {
            Reports::generate_rival_report(\@rival_history);
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
                if ($result) {
                    foreach my $key (keys %$result) {
                        $player_stats{$key} += $result->{$key};
                    }
                    push @rival_history, {
                        timestamp => time,
                        rival     => $rival_name,
                        action    => 'partnership',
                        result    => "Gained $result->{free_users} free users and \$ $result->{money}.",
                    };
                }
            } elsif (uc($action) eq 'C') {
                my $result = Rival::interact_with_rival($rival_name, 'competition');
                if ($result) {
                    foreach my $key (keys %$result) {
                        $player_stats{$key} += $result->{$key};
                    }
                    push @rival_history, {
                        timestamp => time,
                        rival     => $rival_name,
                        action    => 'competition',
                        result    => "Gained $result->{free_users} free users and \$ $result->{money}.",
                    };
                }
            } else {
                print "Invalid action. Returning to main menu.\n";
            }
        }
        Player::update_stats(%player_stats);
    } elsif ($command eq 'U') {
        # Read User Mail command
        if (Player::deduct_actions(5)) {
            my $mail_event = Event::trigger_mail_event();
            if ($mail_event) {
                UI::display_event($mail_event);
                print "\nChoose a response:\n";
                print "    1 - Approve\n";
                print "    2 - Reject\n";
                print "    3 - Ignore\n";
                print "\nEnter your choice: ";
                my $response = <STDIN>;
                chomp($response);
                if ($response eq '1') {
                    Player::update_stats(satisfaction => $mail_event->{value});
                } elsif ($response eq '2') {
                    Player::update_stats(satisfaction => -5);
                } else {
                    print "You chose to ignore the message.\n";
                }
            } else {
                print "No new mail at this time.\n";
            }
            Player::check_for_upgrades();
        } else {
            UI::display_error("Not enough actions remaining to read mail.");
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
        UI::display_end_game($stats{money}, $stats{achievements});
    } else {
        # Invalid command
        UI::display_error("Invalid command. Please try again.");
    }
}

print "Game over. Goodbye!\n";
