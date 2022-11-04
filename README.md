# Prelude of the Chambered (JRuby port)

This is a JRuby port of notch's 48 hour "Ludum Dare" game competition entry from 2011: _Prelude of the Chambered_.

![potc](https://user-images.githubusercontent.com/118/200089149-eb291cd7-6c5e-4b18-a03c-f3a67efc7974.jpg)

Notch's Java code is pretty straightforward and I've been looking for an excuse to do a "real" project in JRuby for ages. This seemed an ideal opportunity.

The port remains unfinished but the first few levels of the game are playable (start level, dungeon, overworld, and ice level - no bosses).

Controls are W, A, S, D and space. Or arrow keys. To get started, turn around and punch the "broken" wall. Best place to head is along the corridor, to the left, and down into the dungeon. You'll find boulders to punch, magic gloves, and bats to kill down there.

## Running

To run this code, get JRuby installed and then (from the root folder):

    ruby escape.rb
    
## Known bugs

* If you take focus away from the game and then come back, the left and right controls stop working
    
## Credits

_Prelude of the Chambered_ is a game by Markus "Notch" Persson and Mojang

This JRuby port was started by, and is maintained by, Peter Cooper.

Contributions by:

* Charles Nutter (@headius)
* Tim Felgentreff (github:timfel)
* Andrew Chalkley (@chalkers)

## Other links

Romain Lods has been working on a C#-powered .NET port of the game - http://github.com/rlods/PocDotNet

## License

Unsure as yet, not sure of the license for the original game.

Original game and content is Copyright 2011 to Mojang so don't use Notch's graphical assets for your own blockbuster hit until he says it's OK :-)
