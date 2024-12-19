# Virtual SysOp 4.0 - A BBS Simulation Game!

Virtual SysOp is a text-based simulation game that lets you experience the life of a system operator (SysOp) managing a Bulletin Board System (BBS). Inspired by the classic BBS era, the game features dynamic events, resource management, and nostalgic ASCII art.

## Features
- Manage users (free and paying) while keeping them satisfied.
- Upgrade hardware and manage resources.
- Handle random events, including viruses and user complaints.
- Perform daily actions like working, checking mail, and running virus scans.
- View detailed reports and track your score.
- Nostalgic BBS-era pop culture references and humor.

## Installation
1. Clone the repository or download the game files.
    ```bash
    git clone <repository_url>
    cd virtual-sysop
    ```
2. Ensure you have Perl installed on your system.
    - On Linux/MacOS: Perl is typically pre-installed.
    - On Windows: Download Perl from [Strawberry Perl](https://strawberryperl.com/).
3. Run the game script:
    ```bash
    perl game.pl
    ```

## Game Commands
| Command | Action                | Description                                |
|---------|-----------------------|--------------------------------------------|
| `W`     | Work                 | Perform actions to attract users and earn resources. |
| `M`     | Check Mail           | Handle user complaints or problem mail.   |
| `V`     | Virus Scan           | Scan and remove viruses from your system. |
| `S`     | Store                | Upgrade hardware and purchase resources.  |
| `R`     | Report               | View stats, user satisfaction, and score. |
| `C`     | Charge Users         | Set or modify subscription charges.       |
| `Q`     | Quit                 | Exit the game.                            |

## File Structure
```
virtual-sysop/
├── game.pl                # Main game script
├── modules/
│   ├── Data.pm            # Handles data parsing and loading
│   ├── Event.pm           # Manages random events
│   ├── Player.pm          # Tracks player stats and achievements
│   ├── UI.pm              # User interface and ASCII art handling
│   ├── Score.pm           # Scoring system
├── data/
│   ├── msgsa.dat          # Work events data
│   ├── msgsr.dat          # Problem mail data
│   ├── msgsv.dat          # Virus events data
│   ├── text.dat           # General game text
│   ├── virus.dat          # List of virus names
└── assets/
    ├── mainmenu.ans       # ANSI art for the main menu
    └── themes/            # Customizable themes
```

## Gameplay Tips
- **Satisfaction is key**: Keep users happy by resolving issues promptly.
- **Manage resources**: Balance upgrades and actions to maximize efficiency.
- **Plan actions**: Use your limited daily actions wisely.
- **Explore events**: Random events can offer opportunities or challenges.

## Contributing
Contributions are welcome! Feel free to fork the repository and submit a pull request. For major changes, please open an issue to discuss your ideas first.

## License
Virtual SysOp is released under the [BSD-2-Clause License](LICENSE).

## Credits
Inspired by the classic BBS games of the 80s and 90s, this project aims to bring back the nostalgia of the early internet era.
# VirtualSysop-4.0