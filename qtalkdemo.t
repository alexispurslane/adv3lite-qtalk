#charset "us-ascii"

//----------------------------------------------------------------------
// QTALKDEMO.T
// Part of a set of files including:
//   Qtalk.t, Qtalkverbs.t, Qtalk.h, & Qtalkdemo.t
// A set of files for conversation menus in TADS 3
// Version 2
// by Greg Boettcher
// This set of files is freeware. You may use them for any purpose 
// without permission, but please credit me.
//----------------------------------------------------------------------

#include <adv3.h>
#include <en_us.h>
#include "qtalk.h"
//Quip template "desc"? "reply"?;

//////////////////////////
// Preliminary stuff
//////////////////////////

versionInfo: GameID
  name = 'Qtalkdemo.t'
  byline = 'by Greg Boettcher'
  htmlByline = 'by Greg Boettcher'
  version = '1'
  authorEmail = 'Greg Boettcher <greg@gregboettcher.com>'
  desc = 'An interactive demo of Qtalk.t, a conversation 
    library for TADS 3.'
  htmlDesc = 'An interactive demo of Qtalk.t, a conversation 
    library for TADS 3.'
;

gameMain: GameMainDef
  initialPlayerChar = me
  showIntro() {
    "Greg's here, the guy behind Qtalk.t. \b";
  }
;

me: Person
  location = genericPlace
;

modify libGlobal
  autoDeactivate = true
;

//////////////////////////
// Game objects
//////////////////////////

genericPlace: Room 'Place' 'place'
  "You are in a place. "
;

note: Readable 'paper note' 'note'
  //@genericPlace
  "The note says:<p>
    -- Thanks to Steve Breslin for looking at 
       my code and suggesting a few changes.\n
    -- Thanks to Krister Fundin and Mark Tilford, who added 
       to gtalk.h for Inform 6 (after all, qtalk.t is a port
       of gtalk.h).\n
    -- Thanks to Adam Cadre, David Glasser, Roger Firth, 
       Andrew Plotkin, Cedric Knight, Victor Gijsbers, and 
       J. Robinson  Wheeler, who in various ways helped me 
       with Gtalk.h for Inform.\n
    -- By all means, do not use qtalk.t until you have 
       considered using the standard TADS 3 style of 
       conversation. See:\n
       http://www.tads.org/howto/t3actor.htm\n
       http://www.tads.org/howto/convbkg.htm\n
       http://www.tads.org/howto/t3conv.htm\n
    -- Likewise, do not use qtalk.t until you look at
       convmenu.t, which is in many ways more powerful than
       qtalk.t and actually makes use of TADS 3's powerful
       conversation features, whereas qtalk.t does not. See:\n
       http://kwi.homepage.dk/t3/convmenu.htm\n
       (Qtalk.t is for those who stubbornly insist on doing
       conversation menus in the style of Photopia or 
       Being Andrew Plotkin, not in the style of City of 
       Secrets or Max Blaster and Doris De Lightning.)\n
    -- For that matter, if you have a non-conversation
       menu system in mind, by all means look at menusys.t,
       which is part of the standard TADS 3 library.\n
    -- Thanks to Mike Roberts, Eric Eve, Steve Breslin, and
       everybody else whose programming, documentation, and 
       technical help made this library possible. "
;

greg: Person 'greg boettcher/guy/man' 'Greg'
  @genericPlace
  "Greg looks weary. "
  isHim = true
  isProperName = true
  dobjFor(TalkTo) {
    action() {
      gbMain.select();
    }
  }
;

//////////////////////////
// Quips
//////////////////////////

// Note that none of these quips would work without
// the Quip template in qtalk.h.

gbMain: QMain
  options = [gbWho, gbCurt, gbMike, gbWeary, 
             gbSubPeople, gbSubPlaces, gbSubFeatures]
;
gbWho: Quip
  "\"Hi there, who are you?\" "
  "\"My name's Greg Boettcher.\" "
  qOff = [gbWho]
  qOn  = [gbCurt, gbMike]
;
gbCurt: Quip 
  "\"Are you related to Curt Boettcher, of the rock group
    Sagittarius?\" "
  "\"No.\" "
  qOff = [gbCurt]
  isOn = nil
;
gbMike: Quip
  "\"Are you related to Mike Boettcher, the CNN news
    correspondent?\" "
  "\"No.\" "
  qOff = [gbMike]
  isOn = nil
;
gbWeary: Quip
  "\"You look weary.\" "
  "\"Well, I should be. I just finished programming a new
    conversation system.\" "
  qOff = [gbWeary]
;

gbSubPeople: QSub
  "Ask Greg about a person . . . "
  quipQuestion = 'Ask Greg about: '
  //reply = "Ask Greg about: "
  //killQ = true
  //breakBeforeOptions = nil
  options = [gbPersonAB, gbPersonCD, gbPersonEF, gbPersonGH, 
             gbPersonIJ, gbPersonKL, gbPersonMN, gbPersonOP,
             gbPersonQR, gbPersonST, gbPersonUV, gbPersonWX, 
             gbPersonYZ]
;
gbPersonAB: Quip
  "Ann Boleyn "
  "\"Isn't she . . . No, wait, she's . . . Oh man. I hate
    history.\" "
  qOff = [gbPersonAB]
;
gbPersonCD: Quip
  "Charlie Daniels "
  "\"Isn't he a country music singer?\" "
  qOff = [gbPersonCD]
;
gbPersonEF: Quip
  "Ethan Frome "
  "\"I never read that one.\" "
  qOff = [gbPersonEF]
;
gbPersonGH: Quip
  "George Harrison "
  "\"I liked 'Something' and 'While My Guitar 
    Gently Weeps.'\" "
  qOff = [gbPersonGH]
;
gbPersonIJ: Quip
  "Ivan the Just "
  "\"'Ivan the Just'? 'Ivan the Just'? He's called
    Ivan the Great, you fool!\" "
  qOff = [gbPersonIJ]
;
gbPersonKL: Quip
  "King Lear "
  "\"Um, yeah. I was supposed to read that in 
    college, but, well, you know.\" "
  qOff = [gbPersonKL]
;
gbPersonMN: Quip
  "Matt Nokes "
  "\"Yeah, he was a baseball player back in the 80s.\" "
  qOff = [gbPersonMN]
;
gbPersonOP: Quip
  "Oliver Platt "
  "\"Yeah, I remember him. He's an actor.\" "
  qOff = [gbPersonOP]
;
gbPersonQR: Quip
  "Queensryche "
  "\"I bought their album Empire, and it rocked!\" "
  qOff = [gbPersonQR]
;
gbPersonST: Quip
  "Steven Tyler "
  "\"The guy can sing, can't he?\" "
  qOff = [gbPersonST]
;
gbPersonUV: Quip
  "Urban V "
  "\"I'm not The Catholic Encyclopedia, you know.\" "
  qOff = [gbPersonUV]
;
gbPersonWX: Quip
  "William X "
  "\"William X? I think you made that name up. Sheesh.\" "
  qOff = [gbPersonWX]
;
gbPersonYZ: Quip
  "your zookeeper "
  "\"You have a zookeeper? Ha!\" "
  qOff = [gbPersonYZ]
;

gbSubPlaces: QSub
  "Ask Greg about a place . . . "
  quipQuestion = 'Ask Greg about: '
  //reply = "Ask Greg about: "
  //killQ = true
  //breakBeforeOptions = nil
  options = [gbAruba, gbBermuda, gbCuba, gbDominica, gbEleuthera, 
             gbFlorida, gbGrenada, gbHavana, gbInagua, gbJamaica]
;
gbAruba: Quip
  "Aruba "
  "\"Off the coast of Venezuela.\" "
  qOff = [gbAruba]
;
gbBermuda: Quip
  "Bermuda "
  "\"Bermuda, yeah.\" A dreamy look in his eyes. \"Bermuda.\" "
  qOff = [gbBermuda]
;
gbCuba: Quip
  "Cuba "
  "\"Did you hear the one about how the CIA left a banana
    peel outside Castro's door?\"\b
    He pauses, musing. \"Um, sorry, I forgot the punchline.\" "
  qOff = [gbCuba]
;
gbDominica: Quip
  "Dominica "
  "\"That's where all those baseball players are from! Oh
    wait. Hmm, maybe not.\" "
  qOff = [gbDominica]
;
gbEleuthera: Quip
  "Eleuthera "
  "\"An island in the Bahamas, I think.\" "
  qOff = [gbEleuthera]
;
gbFlorida: Quip
  "Florida "
  "\"Nice beaches.\" "
  qOff = [gbFlorida]
;
gbGrenada: Quip
  "Grenada "
  "\"Since that one thing back in the 80s, I've heard
    nothing about Grenada.\" "
  qOff = [gbGrenada]
;
gbHavana: Quip
  "Havana "
  "\"Everything I know about Havana I learned by 
    watching Godfather II.\" "
  qOff = [gbHavana]
;
gbInagua: Quip
  "Inagua "
  "\"An island in the Bahamas, I think.\" "
  qOff = [gbInagua]
;
gbJamaica: Quip
  "Jamaica "
  "\"Home of the champion bobsledders.\" "
  qOff = [gbJamaica]
;

gbSubFeatures: QSub
  "Ask Greg about a feature of this conversation
    system . . . "
  quipQuestion = 'Ask Greg about: '
  //reply = "Ask Greg about: "
  //killQ = true
  //breakBeforeOptions = nil
  options = [gbMenus, gbLooping, gbSubmenus, gbOo, gbKillZ, gbKillQ, 
    gbZeroOption, gbSystems]
;
gbMenus: Quip
  "Conversation menus "
  "\"There are lots of ways to handle dialogue in 
    interactive fiction. Conversation menus are 
    one of them. And they can be a good choice, 
    depending on what you're trying to do.\b
    \"If you're playing this demo, chances are 
    you're a game designer who is looking for a 
    way to put conversation menus into your Inform 
    game.\b
    \"If so, then you probably know about 
    Phtalkoo.h: David Glasser's library file based 
    on Adam Cadre's phototalk.inf from his game 
    Photopia.\b
    \"And you probably also know that this demo 
    demonstrates Qtalk.t, my own library file.\" "
  options = [gbAdvantages, gbInteresting]
;
gbLooping: Quip
  "Looping menus "
  "\"In case you don't know what I mean, 'looping' 
    conversation menus are simply ones that repeat 
    without player input in between.\"\bLike so: "
  options = [gbLooping2]
;
gbSubmenus: Quip
  "Submenus and \"menu mazes\" "
  "\"I created this library file to handle submenus,
    and, yes, even 'menu mazes.' I wasn't aware of 
    any existing Inform library files to handle 
    this, so I wrote my own.\b
    \"I think that submenus, in particular, offer 
    exciting possibilities. Conversation menus are 
    often criticized for not allowing enough 
    freedom, but submenus do something to correct 
    for this. They can increase the range of 
    options to as great an extent as the designer 
    allows.\b
    \"This demo is a good example.\" "
  options = [gbSubmenus2]
;
gbOo: Quip
  "Object-oriented menu options "
  "\"Qtalk.t is object-oriented:
    its menu options are represented by objects, 
    which can belong to classes and can inherit 
    properties just like any other objects. 
    This makes for a lot of flexibility.\" "
;
gbKillZ: Quip
  "Ability to turn on/off/on the \"say nothing\" 
    option"
  "\"Yep, my system lets you turn on, off, then on 
    again, the '0 to say nothing' feature.\"\b
    You can't escape this by pressing 0:"
  options = [gbKillQ2]
  killQ = true
  killZ = true
;
gbKillQ: Quip
  "Ability to show/hide/show \"What would you like 
    to say?\" "
  "\"Yes, for any menu option, you can either show 
    or hide the standard question 'What would you 
    like to say?', perhaps replacing it with 
    something different. And for any menu option, 
    you can change this preference at any time.\"\b
    [Question intentionally omitted below.]\b"
  options = [gbKillQ2]
  killQ = true
;
gbZeroOption: Quip
  "Create your own response when a user types 0 to
    say nothing "
  "Yes, with Qtalk.t, you can customize your own
    response for when the user types 0 to say 
    nothing.\b
    For instance, try typing 0 to say nothing right
    now. "
  options = [gbZeroOption2]
  zeroOption = gbZeroOption3
;
gbSystems: Quip
  "Learn more about other conversation systems systems. "
  reply {
    "\"Well, I just happen to have something for 
      that.\" He shuffles in his pockets and pulls out 
      a piece of paper, then hands it to you. \"Check 
      this out.\" ";
    note.moveInto(me);
  }
;
gbAdvantages: Quip
  "\"If you were to compare Qtalk.t to the Inform 
    library Phtalkoo.h, what advantages would it have?\" "
  "\"Several.\"\bAsk about an advantage: "
  options = [gbLooping, gbSubmenus, gbOo, gbKillZ, gbKillQ]
  killQ = true
;
gbInteresting: Quip
  "\"Hmm, that's very interesting.\" "
  "Greg nods. "
;
gbLooping2: Quip
  "\"Ah yes, I see what you mean.\" "
  "\"J. Robinson Wheeler's Being Andrew Plotkin 
    was the first IF game I ever played to use 
    such 'looping' menus.\b
    \"In fact, I wrote Wheeler asking if he could 
    send me his Phtalkoo.h modifications he used 
    for that game. He was gracious enough to do 
    so. I appreciated that very much, even though 
    I didn't end up using his code.\" "
;
gbSubmenus2: Quip
  "\"What about menu mazes?\" "
  "\"'Menu mazes' is a term that has been denigrated 
    by the IF community, even though such 'mazes'
    have been used to quite good effect in graphic
    adventures such as Gateway 2: Homeworld. Even 
    if you really hate 'mazey' conversation menus,
    it is clearly an advantage that Qtalk.t lets 
    you create them if you want to. .\b
    \"This isn't logical, but just to be 'mazey,'
    I'm going to take you back to the main menu.\" "
  //this transfer property is equivalent to:
  //options = [gbWho, gbCurt, gbMike, gbWeary, gbSubPeople, gbSubPlaces, gbSubFeatures]
  transfer = gbMain
;
gbKillQ2: Quip
  "\"Ah yes, I see what you mean.\" "
  // It's probably bad form not to include a reply,
  // but this quip does show you that a reply isn't
  // absolutely necessary.
;
gbZeroOption2: Quip
  "\"Wait a minute. Is this some kind of loop, the
    kind I'll never break out of until I type 0 to
    say nothing?\" "
  "\"That's right.\" "
  transfer = gbZeroOption
;
gbZeroOption3: Quip
  // No "desc" property needed when the quip is only
  // used as a response to "0 to say nothing. '
  reply = "\"So you see what I mean. Here is a custom
    response to '0 to say nothing.'\" "
;




