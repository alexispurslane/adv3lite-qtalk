# Menu-based conversations for adv3Lite

Based on the qtalk library by Greg Boettcher, which can be found [here](https://unbox.ifarchive.org/?url=/if-archive/programming/tads3/library/contributions/qtalk.zip).

The following documentation is copied from the `qtalk.t` source file and
formatted.

------------------------------------------------------------------------

## Introduction and alternatives

Qtalk.t can be used in conjunction with Qtalkverbs.t to completely replace the standard TADS 3 conversation system.

Before you do this, you would be well advised to understand the nature of your decision:

 1. If you don't already know the advantages of the standard TADS 3
    conversation system, you should consider them. Read about them here:

    - http://www.tads.org/howto/t3actor.htm
    - http://www.tads.org/howto/convbkg.htm
    - http://www.tads.org/howto/t3conv.htm

 2. If you still want to use conversation menus, please check out
    Soren J. Lovborg's convmenu.t. Lovborg's system is both menu-based 
    and also makes use of many powerful aspects of the TADS 3 
    conversation system. It works well for the type of conversation 
    menus found in games such as _City of Secrets_ or _Max Blaster
    and Doris De Lightning Against the Parrot Creatures of Venus_. 
    Find convmenu.t at: http://kwi.homepage.dk/t3/convmenu.htm

 3. If convmenu.t doesn't appeal to you either, it could be that you 
    want the conversation menu options to appear in the same window as 
    the rest of the game text, as in games such as _Photopia_, 
    _Rameses_, or _Being Andrew Plotkin_, rather than using the 
    split-pane style of, e.g., _City of Secrets_. If so, then Qtalk.t 
    might be for you. The main disadvantages: (1) you'll have to give up 
    the powerful conversation-handling options of the standard TADS 3 
    system, and (2) you'll lose some flexibility compared with the 
    split-screen system, which permits the player to *either* select a 
    conversation menu option *or* enter a standard command at any given 
    moment.

If you want to use qtalk.t for *non-conversation* menus, then you should 
consider the usual TADS 3 way of doing menus, found in menusys.t (part 
of the standard TADS 3 library). Menusys.t is a menu system commonly 
used for, e.g., hint menus, and is certainly worth knowing about.

With that out of the way, let's move on.

------------------------------------------------------------------------

## How to use this library

These instructions assume you'll be using `qtalk.t` for conversation 
menus. If you want to use `qtalk.t` to create *non-conversation* menus --
well, then just read the instructions below and modify them to suit
your purposes.

### Installation

 1. In your TADS 3 project file (e.g. `mygame.t3m`), include `qtalk.t` as 
    a source file.
 2. If you want to handle conversation verbs (`AskAbout`, `TellAbout`, 
    `TalkTo`, etc.) in the same manner as `qtalkdemo.t` (the demo that
    accompanies this repo), then you should also include the 
    file `qtalkverbs.t` in your .t3m project file. If you plan on doing 
    a different handling of conversation verbs, you may still find it 
    worthwhile to consult qtalkverbs.t and either modify it or use it 
    as a reference for your own verb code.

### Starting a menu-based conversation

In your source files, for every case where you want to initiate a qtalk.t-style
menu, you must call the `select()` method of a conversation object. Typically,
you'll want to start the player's conversation at a main menu of dialogue
options, where they can choose how to initiate the conversation, so in order to
initiate a conversation, call `select()` on a `QMain` (conversation main menu)
object.

For example, if you are dealing with conversation verbs in the manner defined in
`qtalkverbs.t`, then for every non-player character in your game, you'll
probably do something like this:

```tads3
somebody: Actor
   ...
   dobjFor(TalkTo)
   {
       action()
       {
           somebodyMainMenu.select();
       }
   }
;
```

The next step is to create a series of **conversation objects**, where each
object represents a conversation menu option. Each of these objects must be of
class `Quip` (or else a subclass thereof, namely `QMain` or `QSub`):

- the `GMain` class represents a dialogue choice box, instead of a discrete
  dialogue choice. As such, it has no description, reply, or any other
  interaction to it, just a list of options, and reaching it does not count as
  actually having said anything. This is typically where
  conversations start.

  Each set of quips must have (at least) one quip that represents the "main
  menu." This main menu quip should be of class QMain. (To find out why, read
  Note #2 below.)
  
- the `Quip` class represents a single dialogue choice, with a description (what the
  player says), and a reply (what the NPC does/says in response) that is played
  when the choices is selected. It can also have options of its own, if the
  dialogue option should lead to another branching dialogue choice that leads
  deeper into the dialogue tree, and a transfer property, which tells the
  dialogue system where to go (for instance, back to the main menu) when the
  interaction is complete.
  
- the `GSub` class represents a sub-menu of dialogue options. It is not itself a
  dialogue choice &emdash; so selecting it won't actually say anything to the
  NPC for example &emdash; but rather a way of organizing many dialogue choices
  or *building* a dialogue option choice by choice. See `qtalkdemo.t` for how
  this works.

Each conversation menu option &emdash; each quip &emdash; can contain any of the
following elements:

| Element                     | Description                                                                                                                                    |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `quipID`                    | The quip's identifier                                                                                                                          |
| `Quip` or `QMain` or `QSub` | The quip's class.                                                                                                                              |
| `desc`                      | A double-quoted string or method holding the quip's "short description" &emdash; i.e., how it is shown in a list of conversation menu options. |
| `reply`                     | The double-quoted string or method with the response given by the NPC that holds these dialogue choices when this choice is chosen.            |
| `isOn`                      | `true` by default. Whether the quip starts visible in the menu or not                                                                          |
| `killZ`                     | `nil` by default. Disallow the "0 to say nothing" option                                                                                       |
| `killQ`                     | `nil` by default. After this quip, don't ever say "What would you like to say?" again.                                                         |
| `qOn`                       | List of quips to turn on after this dialogue option is chosen.                                                                                 |
| `qOff`                      | Same as above, but turns them off.                                                                                                             |
| `qOffSelf`                  | Automatically turn off this quip after finishing it. Defaults to `nil`                                                                         |
| `options`                   | Provide a menu consisting of the following options after this piece of dialogue.                                                               |
| `transfer`                  | Transfer control to some other Quip (for instance the main menu) after completing this dialogue.                                               |
| `zeroOption`                | Method or double-quoted string to use when the user chooses the "say nothing" option                                                           |
| Misc. message properties    | These can be overridden to change the default messages                                                                                         |

Here is a sample quip, or conversation menu option:
  ```tads3
    quip20: Quip
        desc = "<q>Could I have that apple?</q> "
        reply {
            "<q>Sure, why not.</q> She hands you the apple. <q>Say, 
            you're not from around here, are you?</q> ";
            apple.moveInto(me);
        }
        isOn = true
        qOn = [quip21, quip22]
        qOff = [quip20]
        options = [quip21, quip22] 
    ;
  ```
In this example, quip21 and quip22 represent responses to the 
question "You're not from around here, are you?" The rest of this
quip shouldn't be terribly hard to figure it out if you look through
all the documentation here and study qtalkdemo.t as needed. 

### Toggling quips on and off

It's unlikely that you'll want the choices in your conversation menus to always
remain the same forever. Turning them on or off is easy: just use the statement
`quip1.isOn = true;` or `quip1.isOn = nil;`. There is a shortcut for this when
you want to do it during the execution of a quip's reply method. Simply use the
properties `qOn`, `qOff`, and/or `qOffSelf`, as shown in Step 5 above. The value
of qOn or qOff should be a list containing quips to turn on or off, while the
value of `qOffSelf` should be either true or nil, depending on whether you want
any given quip to turn itself off after it's been selected. See qtalkdemo.t for
examples.

### Using the Quip template

If you want to save a bit of typing, you can make use of `qtalk.h`, 
which defines a template so that your quips usually won't need
to contain "desc =" or "reply =". You can see the result in 
`qtalkdemo.t`. There are three ways to do this:

- Include Qtalk.h in your *.t3m file (with the other *.h files).
    At the beginning of your source files, put:
    ```tads3
    #include <qtalk.h>
    ```
- At the beginning of your source files, put:
    ```tads3
    #include "qtalk.h"
    ```
    (This way it should not be necessary to put Qtalk.h into your
    .t3m file.)
- Or, at the beginning of your source files, put:
    ```tads3
    Quip template "desc"? "reply"?;
    ```
    This one line is the entire content of Qtalk.h. Since this is
    just as concise as typing an #include directive, some people
    may prefer to do it this way. Note that you must do one of 
    these three things for *each* of your source files that are
    to contain quips.

### Dealing with verbs left over from adv3Lite's existing conversation system

Qtalk.t does not deal with any verb issues. That is dealt with by Qtalkverbs.t
instead. Basically, Qtalkverbs.t disables the verbs ASK (both "ask about" and
"ask for"), TELL, HELLO, GOODBYE, YES, NO, and TOPICS, and also makes a
halfway-successful attempt to disable NPC commands (e.g. "BOB, GO NORTH"). It
also expands somewhat the number of synonyms for the action TalkTo, which it
assumes will be the only action used to actually carry out conversation. To
accept this verb/action behavior, simply include Qtalkverbs.t in your *.t3m
project file. Of course, you can always modify Qtalkverbs.t if you want, or
replace it with something else.

### Important Notes

See also the following notes &emdash; especially Note #1 to decide if you want
to use the "AutoDeactivate" feature.

**Note #1**: Gtalk.h has an optional feature where it can routinely look
for any quip whose options are all turned off, and turn that quip off 
for you. To turn on this feature, simply set libGlobal.autoDeactivate
to true, like so:
       modify libGlobal
         autoDeactivate = true
       ;
See Qtalkdemo.t, which does this. (This feature is not on by default,
because it might be unneeded and might unnecessarily slow games down
a bit.)

**Note #2**: What, really, is the difference between class QMain (for
main menu quips), class QSub (for submenu quips), and ordinary quips?
quips, SubMenu quips, and normal quips?
  - QMain quips (unlike QSub quips and normal quips) will print "You
     can't think of anything to say" when all of their options are 
     turned off.
  - Having reached a QMain quip or a QSub quip (as opposed to a 
     normal quip) does not constitute actually having said anything. 
     Gtalk.h takes this into account when deciding whether it makes 
     sense to print the message "You decide not to say anything after 
     all."
     
**Note #3**: In my previous version of this extension, I said that you might get
errors if you included qtalk.t in your project and then compiled for release. I
was wrong about this. Although I did have such problems, they were apparently
caused by a bad sector of my hard drive, not by any bug in qtalk.t.

------------------------------------------------------------------------

## Acknowledgements

I'd like to thank the many people whose efforts helped me to produce 
this extension.

Qtalk.t is a TADS 3 port of Gtalk.h for Inform 6. So I am also thanking
the people who helped with Gtalk.h.

Thanks to:

  Steve Breslin, who looked over the new TADS 3 version of this file
    and gave quite a few helpful suggestions.
  Krister Fundin and Mark J. Tilford, who both added to and 
    substantially improved Gtalk.h for Inform 6. This library is,
    after all, a TADS 3 port of Gtalk.h.
  Roger Firth, Krister Fundin, Victor Gijsbers, Cedric Knight, Andrew 
    Plotkin, and J. Robinson Wheeler, who gave various suggestions, 
    feedback, example code, etc., that helped me when I worked on 
    Gtalk.h for Inform.
  David Glasser and Adam Cadre, whose Inform 6 extension phtalkoo.h
    gave me a starting point for Gtalk.h, and hence for this extension
    too.
