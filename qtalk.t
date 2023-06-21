#charset "us-ascii"

//----------------------------------------------------------------------
// QTALK.T
// Part of a set of files including:
//   Qtalk.t, Qtalkverbs.t, Qtalk.h, & Qtalkdemo.t
// A set of files for conversation menus in TADS 3
// Version 2
// by Greg Boettcher
// This set of files is freeware. You may use them for any purpose 
// without permission, but please credit me.
//----------------------------------------------------------------------

#include <advlite.h>

/***********************************************************************

BEFORE YOU BEGIN:

Note: Qtalk.t is used to create conversation menus and other kinds of 
menus. Before you use it, I suggest you consider all the alternatives.

In particular, Qtalk.t can be used in conjunction with Qtalkverbs.t
to completely replace the standard TADS 3 conversation system. Before
you do this, you would be well advised to understand the nature of 
your decision:

 1. If you don't already know the advantages of the standard TADS 3
    conversation system, you should consider them. Read about them here:
         http://www.tads.org/howto/t3actor.htm
         http://www.tads.org/howto/convbkg.htm
         http://www.tads.org/howto/t3conv.htm

 2. If you still want to use conversation menus, please check out
    Soren J. Lovborg's convmenu.t. Lovborg's system is both menu-based 
    and also makes use of many powerful aspects of the TADS 3 
    conversation system. It works well for the type of conversation 
    menus found in games such as _City of Secrets_ or _Max Blaster
    and Doris De Lightning Against the Parrot Creatures of Venus_. 
    Find convmenu.t at:
         http://kwi.homepage.dk/t3/convmenu.htm

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

ACKNOWLEDGMENTS:

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

------------------------------------------------------------------------

HOW TO USE THIS LIBRARY:

These instructions assume you'll be using qtalk.t for conversation 
menus. If you want to use qtalk.t to create *non-conversation* menus --
well, then just read the instructions below and modify them to suit
your purposes.

 1. In your TADS 3 project file (e.g. mygame.t3m), include qtalk.t as 
    a source file.
 2. If you want to handle conversation verbs (AskAbout, TellAbout, 
    TalkTo, etc.) in the same manner as qtalkdemo.t (the demo that
    accompanies this file), then you should also include the 
    file qtalkverbs.t in your .t3m project file. If you plan on doing 
    a different handling of conversation verbs, you may still find it 
    worthwhile to consult qtalkverbs.t and either modify it or use it 
    as a reference for your own verb code.
 3. In your source files, for every case where you want to initiate a 
    qtalk.t-style menu, you must call the select() method of a 
    conversation object (concerning such objects, see the next step). 
    If you are dealing with conversation verbs in the manner defined
    qtalkverbs.t, then for every non-player character in your game, 
    you'll probably do something like this:
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
 4. The next step is to create a series of objects, where each object
    represents a conversation menu option. Each of these objects must be 
    of class Quip (or else a subclass thereof, namely QMain or QSub). 
 5. Each conversation menu option -- each quip -- can contain any of the
    following elements:
      *  quipID:                   The quip's identifier.
      *    Quip OR QMain OR QSub   The quip's class:
                                     Quip  = regular quip
                                     QMain = main menu quip
                                     QSub  = submenu quip
      *    desc = "double-quoted   The quip's "short description" -- 
                     string"         i.e., how it is shown in a list of 
            OR                       conversation menu options.
           desc
           {
             method;
           }
      *    reply = "double-quoted  The response given when this quip is
                     string"         selected, including a textual 
            OR                       response, and perhaps also including 
           reply                     additional programming statements.
           {
             method;
           }
      *    isOn  = true [DEFAULT]  Quip is turned on from the beginning
                                     of the game.
                 = nil             Quip is turned off from the beginning
                                     of the game.
      *    killZ = true            Disallow the "0 to say nothing"
                                     option.
                 = nil  [DEFAULT]  Allow the "0 to say nothing" option.
      *    killQ = true            After this quip, don't ever say "What
                                     would you like to say?"
                 = nil  [DEFAULT]  After this quip, say "What would you
                                     like to say?" if applicable.
      *    qOn  = [quip1, quip2]   Turn the specified quips on.
      *    qOff = [quip1, quip2]   Turn the specified quips off.
      *    qOffSelf = true         Automatically turn off this quip 
                                     after finishing with it.
                   = nil [DEFAULT] Don't automatically turn off this 
                                     quip after finishing with it.
      *    options =               Provide a menu consisting of the
             [list of quips]         following options.
      *    transfer = quipID       "Go back to the main menu" or any 
                                     other previously defined set of 
                                     options.
      *    zeroOption = quipID     Do this if you want to do something 
                                     special when the player types
                                     0 to say nothing.
      *    [And there are also a number of message properties that
           you can override if needed; see the code below.]
         ;
 6. Here is a sample quip, or conversation menu option:
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
    In this example, quip21 and quip22 represent responses to the 
    question "You're not from around here, are you?" The rest of this
    quip shouldn't be terribly hard to figure it out if you look through
    all the documentation here and study qtalkdemo.t as needed. 
 7. Each set of quips must have (at least) one quip that represents the 
    "main menu." This main menu quip should be of class QMain. (To find 
    out why, read Note #2 below.) This "main menu" quip need not have a 
    desc property or a reply property, but it should have an options 
    property, which should consist of a list of other quips. In 
    qtalkdemo.t, the main menu quip is called gbMain.
 8. If you investigate qtalkdemo.t, you will find that it contains 
    submenus (represented by the objects gbSubPeople, gbSubPlaces, and 
    gbSubFeatures). If you want to include such submenus, then they
    should belong to class QSub.
 9. Each quip has a select() routine. To put your conversation menu
    into action, call the select() routine of your "main menu" object, 
    as shown in Step 3 above.
10. It's unlikely that you'll want the choices in your conversation 
    menus to always remain the same forever. Turning them on or off 
    is easy: just use the statement "quip1.isOn = true;" or 
    "quip1.isOn = nil;". There is a shortcut for this when you want to 
    do it during the execution of a quip's reply method. Simply use
    the properties qOn, qOff, and/or qOffSelf, as shown in Step 5 above. 
    The value of qOn or qOff should be a list containing quips to 
    turn on or off, while the value of qOffSelf should be either true
    or nil, depending on whether you want any given quip to turn itself
    off after it's been selected. See Qtalkdemo.t for examples.
11. If you want to save a bit of typing, you can make use of Qtalk.h, 
    which defines a template so that your quips usually won't need
    to contain "desc =" or "reply =". You can see the result in 
    Qtalkdemo.t. There are three ways to do this:
    (a) Include Qtalk.h in your *.t3m file (with the other *.h files).
        At the beginning of your source files, put:
           #include <qtalk.h>
    (b) At the beginning of your source files, put:
           #include "qtalk.h"
        (This way it should not be necessary to put Qtalk.h into your
        .t3m file.)
    (c) Or, at the beginning of your source files, put:
           Quip template "desc"? "reply"?;
        This one line is the entire content of Qtalk.h. Since this is
        just as concise as typing an #include directive, some people
        may prefer to do it this way. Note that you must do one of 
        these three things for *each* of your source files that are
        to contain quips.
11. Qtalk.t does not deal with any verb issues. That is dealt with by 
    Qtalkverbs.t instead. Basically, Qtalkverbs.t disables the verbs 
    ASK (both "ask about" and "ask for"), TELL, HELLO, GOODBYE, YES, NO, 
    and TOPICS, and also makes a halfway-successful attempt to disable 
    NPC commands (e.g. "BOB, GO NORTH"). It also expands somewhat the 
    number of synonyms for the action TalkTo, which it assumes will be 
    the only action used to actually carry out conversation. To accept 
    this verb/action behavior, simply include Qtalkverbs.t in your *.t3m
    project file. Of course, you can always modify Qtalkverbs.t if
    you want, or replace it with something else.
12. See also the following notes -- especially Note #1 to decide
    if you want to use the "AutoDeactivate" feature.

Note #1: Gtalk.h has an optional feature where it can routinely look
for any quip whose options are all turned off, and turn that quip off 
for you. To turn on this feature, simply set libGlobal.autoDeactivate
to true, like so:
       modify libGlobal
         autoDeactivate = true
       ;
See Qtalkdemo.t, which does this. (This feature is not on by default,
because it might be unneeded and might unnecessarily slow games down
a bit.)

Note #2: What, really, is the difference between class QMain (for
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
     
------------------------------------------------------------------------

NOTE:

In my previous version of this extension, I said that you might get 
errors if you included qtalk.t in your project and then compiled for 
release. I was wrong about this. Although I did have such problems, 
they were apparently caused by a bad sector of my hard drive, not by 
any bug in qtalk.t.
    
***********************************************************************/

ModuleID
  name = 'Qtalk.t'
  byLine = 'by Greg Boettcher'
  htmlByLine = 'by Greg Boettcher'
  version = '2'
  //showCredit { "<<name>> <<htmlByLine>>"; }
;

enum regularQuip, mainMenuQuip, subMenuQuip;

class Quip: object
  // The short, one-line description of the quip as shown in the list
  // of conversation options.
  desc = ""
  // The reply: this is printed/executed after this quip is selected.
  // Can be either a double-quoted string or a method.
  reply = ""
  // Quips are initially on by default. Any quip can override this.
  isOn = true
  // If you want to suppress the option where the player can type "0"
  // to exit the menu, then let killZ = true.
  killZ = nil
  // If you want to suppress the question "What would you like to say?",
  // then let killQ = true.
  killQ = nil
  // Before listing the options, should there be a paragraph break, 
  // as opposed to a mere line break? By default, the answer is "yes," 
  // but you can override this if needed.
  breakBeforeOptions = true
  // A "regular quip" is one whose main purpose is to provide content,
  // rather than one whose main purpose is to give a list of options
  // to choose from. Instead of overriding this, you can just use the
  // QMain and QSub classes.
  quipType = regularQuip
  // With qtalk.t, the player often has the chance to type "0 to say 
  // nothing." Normally this will exit the menu. However, in life, 
  // sometimes there are consequences to saying nothing, ones that 
  // go beyond the conversation merely ending. To carry out such 
  // consequences, make zeroOption equal to the value of a quip
  // that defines such consequences.
  zeroOption = nil
  // It is frequently useful to have a quip turn itself off after being
  // selected. To make this happen, set qOffSelf = true.
  qOffSelf = nil
  // To make one or more quips turn themselves off after this
  // quip has been selected, let qOff = a list of such quips.
  qOff = []
  // To make one or more quips turn themselves on after this
  // quip has been selected, let qOn = a list of such quips.
  qOn = []
  // Some quips are designed to provide a list of conversation options 
  // to choose from. In such cases, let options = a list of quips
  // to be used as conversation options. See the full documentation 
  // above for more details.
  options = []
  // Sometimes, after a quip has been selected, you want the player to
  // get a set of conversation options *that have been previously 
  // defined in some other quip*. In that case, instead of using the
  // options property, simply let transfer = that other quip whose
  // options property you want to use.
  transfer = nil
  // If you want to call a quip into action, call its select() method.
  // See the full instructions above for details.
  select() {
    local dealwith, first, seencontent, optionobj, onoptions, 
      selected, objflag, a, k;
    dealwith = self;
    first = true;
    seencontent = nil;
    // Do a gigantic loop, because this quip could be only
    // the first of many in an extended conversation.
    do {
      // Auto-Deactivation:
      // This section does nothing unless you set 
      // libGlobal.autoDeactivate to true. If, however, 
      // libGlobal.autoDeactivate == true, then continually check 
      // for any quips whose option properties are all turned off.
      // Upon finding any such quips, turn them off.
      if (libGlobal.autoDeactivate) {
        do {
          objflag = 0;
          for(local obj = firstObj(Quip) ; obj ; 
                    obj = nextObj(obj, Quip)) { 
            if (obj.propDefined(&options)
                && obj.propType(&options) == TypeList 
                && obj.isOn && obj.options.length() > 0) {
              onoptions = 0;
              for (a = 1, local cnt = obj.options.length(); 
                   a <= cnt; ++a) {
                if (obj.options[a].propDefined(&isOn)) {
                  if (obj.options[a].isOn) ++onoptions;
                }
              }
              if (onoptions == 0) {
                obj.isOn = nil;
                ++objflag;
              }
            }
          }
        } while (objflag != 0);
      }
      
      // Keep track of whether we've seen actual content; i.e.
      // whether we've yet seen a normal quip whose main purpose
      // is to give the content in its reply property, as opposed to 
      // a quip whose main purpose is to provide options.
      if (dealwith.quipType == regularQuip)
        seencontent = true;
      
      // If the current Quip provides a qOff property, and if
      // qOff is a list, then turn off all the quips in the list.
      // If qOff is not a list, or if it's an empty list, 
      // ignore it.
      if (dealwith.propDefined(&qOff) 
          && dealwith.propType(&qOff) == TypeList
          && dealwith.qOff.length() > 0) {
        for (a = 1, local cnt = dealwith.qOff.length(); 
             a <= cnt; ++a) {
          dealwith.qOff[a].isOn = nil;
        }
      }
      
      // If dealwith.qOffSelf = true, then turn
      // the current Quip off.
      if (dealwith.qOffSelf)
        dealwith.isOn = nil;
      
      // If the current Quip provides a qOn property, and if
      // qOn is a list, then turn on all the quips in the list.
      // If qOn is not a list, or if it's an empty list, 
      // ignore it.
      if (dealwith.propDefined(&qOn)
          && dealwith.propType(&qOn) == TypeList
          && dealwith.qOn.length() > 0) {
        for (a = 1, local cnt = dealwith.qOn.length(); 
             a <= cnt; ++a) {
          dealwith.qOn[a].isOn = true;
        }
      }
      
      // Print/execute the reply property.
      if (dealwith.propDefined(&reply)) {
        dealwith.reply;
      }
      else {
        " "; // So as to not get "Nothing obvious happens."
      }
      
      // Next, determine whether we need to print options
      // and ask the player to make a selection.
      // 
      // The first step in this process is to determine "optionobj":
      // the quip that is supposed to store the information about 
      // any options that are to be printed. "Optionobj"
      // is the quip currently being considered, unless a "transfer"
      // property is provided.
      if (dealwith.propDefined(&transfer) && dealwith.transfer != nil)
        optionobj = dealwith.transfer;
      else
        optionobj = dealwith;
      
      // Print either a line break or a paragraph mark, depending
      // on circumstances.
      if (optionobj.breakBeforeOptions)
        "<.p>";
      else
        "\n";
      
      // Check to see if the current quip provides options, 
      // and if at least one of those options is on.
      onoptions = 0;
      if (optionobj.propDefined(&options)
          && optionobj.propType(&options) == TypeList
          && optionobj.options.length() > 0) {
        for (a = 1, local cnt = optionobj.options.length(); 
             a <= cnt; ++a) {
          if (optionobj.options[a].isOn) ++onoptions;
        }
      }
      
      // Begin scenario: the current quip provides options, 
      // and at least one of them is turned on.
      if (onoptions > 0) {
        // If we're supposed to ask a question before listing the 
        // options, then ask the question.
        if (optionobj.killQ == nil) {
          if (!first)
            "\n";
          "<<optionobj.quipQuestion>>";
          //"What would {you/he} like to say? ";
          "\n";
        }
        
        // List the options, then do a paragraph break.
        onoptions = 0;
        for (a = 1, local cnt = optionobj.options.length(); 
             a <= cnt; ++a) {
          if (optionobj.options[a].propDefined(&isOn)) {
            if (optionobj.options[a].isOn) {
              ++onoptions;
              "<<optionobj.quipOptionStart>>";
              "<<onoptions>>";
              "<<optionobj.quipOptionEnd>>";
              "<<optionobj.options[a].desc>> ";
              "\n";
            }
          }
        }
        "<.p>";
        
        // Get input
        do {
          "<.inputline>";
          "<<optionobj.selectAnOption>>";
          if (!optionobj.killZ)
            "<<optionobj.orZeroToSayNothing>>";
          "<<optionobj.quipPrompt>>";
          "<./inputline>";
          k = inputManager.getInputLine();
          selected = qToInteger(k);
          if (optionobj.killZ == true && selected == 0)
            selected = -1;
        } while ((selected < 0) || (selected > onoptions));
        
        // If the player chooses "0" to say nothing -- and if
        // this is supposed to successfully end the conversation --
        // then end the conversation.
        if (selected == 0 && optionobj.zeroOption == nil) {
          // If so far we've only seen quips whose main purpose
          // is to provide options rather than give content,
          // then print the appropriate message.
          if (seencontent == nil) {
            //"{You/he} decide{s} not to say anything after all. ";
            "<<optionobj.decideToSayNoQuip>>";
            "\n";
          }
          // If we *have* seen content by this point, then
          // just exit without another word.
          else {
            " "; // So as to not get "Nothing obvious happens."
          }
          return;
        }
        
        // If the player chooses "0" to say nothing, BUT the
        // game has defined a custom response to "0", then we
        // will have to deal with that custom response next
        // instead of just exiting.
        if (selected == 0 && optionobj.zeroOption != nil) {
          dealwith = optionobj.zeroOption;
        }
        
        // If the player has chosen an option that isn't "0",
        // then we will just have to deal with the corresponding
        // quip next time around. Let dealwith = that quip.
        else {
          onoptions = 0;
          for (a = 1, local cnt = optionobj.options.length(); 
               a <= cnt; ++a) {
            if (optionobj.options[a].propDefined(&isOn)) {
              if (optionobj.options[a].isOn) {
                ++onoptions;
                if (selected == onoptions) {
                  dealwith = optionobj.options[a];
                  break;
                }
              }
            }
          }
        }
      }
      // End "at least one option is turned on" scenario.

      // Begin scenario: the current quip provides no options, 
      // or all of its options are turned off.
      else {
        if (optionobj.quipType == mainMenuQuip) {
          "<<optionobj.canSayNoQuip>>";
          //"{You/he} can't think of anything to say. ";
          "\n";
        }
        dealwith = nil; // end this routine
        //return;
      }
      // End "no options turned on" scenario.
      
      // Any subsequent iterations of the loop will not be
      // the first iteration anymore.
      first = nil;
    
    // If this is the last quip to be dealt with (that is,
    // dealwith = nil), then exit the loop. Otherwise,
    // do the loop again.
    } while (dealwith != nil);
    
    // We're done.
    return;
  }
  // Messages.
  // The following messages are defined as properties of Quip -- as 
  // opposed to properties of libMessages or playerActionMessages -- 
  // because individual quips may need to override them. For instance, 
  // you might want some of your menus to say "0 to say nothing," while 
  // perhaps other menus should say "0 to exit" (if they are not 
  // conversation menus, for example).
  quipOptionStart = '('
  quipOptionEnd = ') '
  selectAnOption = 'Select an option '
  orZeroToSayNothing = 'or 0 to say nothing '
  quipPrompt = '&gt;&gt; '
  quipQuestion {
    // Present tense
    if (!gameMain.usePastTense && gActor) {
      if (gActor.person != 2)
        // E.g., for 3rd person: 'What should Roger say? '
        // For 1st person: 'What should I say? '
        return 'What should ' + gActor.theName + ' say? ';
      else
        return 'What would you like to say? ';
    }
    // Past tense
    // It's hard to know how to say this satisfactorily in the past 
    // tense. So, in all other cases, just go with the simple message 
    // 'What to say?'
    return 'What to say? ';
  }
;

class QMain: Quip
  quipType = mainMenuQuip
;

class QSub: Quip
  quipType = subMenuQuip
;

noWarningsPlease: object
  qOn      = [noWarningsPlease]
  qOff     = [noWarningsPlease]
  options  = [noWarningsPlease]
  transfer = noWarningsPlease
  killQ    = nil
  killZ    = nil
  autoDeactivate = nil
;

qToInteger(str) {
  if (rexMatch('<space>*[-+]?<space>*<digit>+<space>*$', str) == nil)
    return -1;
  else
    return toInteger(str);
} 

modify Thing
  canSayNoQuip = '{I} {can\'t} think of anything to say. '
  decideToSayNoQuip = '{I} decide{s/d} not to say anything after all. '
  useTalkToMsg = 'To talk to {the dobj}, please type TALK TO {the dobj}. '
  noQuipsMsg   = '{I} can\'t think of anything to say. '
  doNotGiveCommandMsg = useTalkToMsg
;
