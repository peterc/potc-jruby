# Prelude of the Chambered (JRuby port)

This is an in-progress JRuby port of notch's 48 hour "Ludum Dare" game competition entry, _Prelude of the Chambered_.

![](http://no.gd/m/potc-20110823-230659.jpg)

Notch's Java code is pretty straightforward and I've been looking for an excuse to do a "real" project in JRuby for ages. This seemed an ideal opportunity.

Porting is still in progress but the first few levels of the game are playable (start level, dungeon, overworld, and ice level - no bosses yet).

Controls are W, A, S, D and space. Or arrow keys. To get started, turn around and punch the "broken" wall. Best place to head is along the corridor, to the left, and down into the dungeon. You'll find boulders to punch, magic gloves, and bats to kill down there.

## Running

To run this code, get JRuby installed (rvm install jruby?) and then just run (from the root folder):

    ruby escape.rb
    
## Known bugs

* If you take focus away from the game and then come back, the left and right controls stop working
    
## Credits

_Prelude of the Chambered_ is a game by Markus "Notch" Persson and Mojang

This JRuby port was started by, and is maintained by, Peter Cooper - http://peterc.org/

Contributions by:

* Charles Nutter (@headius)
* Tim Felgentreff (github:timfel)
* Andrew Chalkley (@chalkers)

## License

Unsure as yet, not sure of the license for the original game.

Original game and content is Copyright 2011 to Mojang so don't use Notch's graphical assets for your own blockbuster hit until he says it's OK :-)