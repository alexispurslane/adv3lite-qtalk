#charset "us-ascii"

//----------------------------------------------------------------------
// QTALKVERBS.T
// Part of a set of files including:
//   Qtalk.t, Qtalkverbs.t, Qtalk.h, & Qtalkdemo.t
// A set of files for conversation menus in TADS 3
// Version 2
// by Greg Boettcher
// This set of files is freeware. You may use them for any purpose 
// without permission, but please credit me.
//----------------------------------------------------------------------

#include <advlite.h>


////////////////////
// Ask
////////////////////

DefineIAction(Ask)
    execAction() {
        dmsg(gActor.useTalkToMsg);
    }
;

modify AskFor
    action = Ask
;

modify AskAbout
    action = Ask
;

modify AskAboutImplicit
    action = Ask
;

modify AskForImplicit
    action = Ask
;

////////////////////
// Tell
////////////////////

DefineIAction(Tell)
    execAction() { dmsg(gActor.useTalkToMsg); }
;

modify TellAbout
    action = Tell
;

modify TellAboutImplicit
    action = Tell
;

modify TellTo
    action = Tell
;

////////////////////
// Hello
////////////////////

replace DefineIAction(Hello)
    execAction(cmd) {
        dmsg(gActor.useTalkToMsg);
    }
;

////////////////////
// Goodbye
////////////////////

modify Goodbye
    execAction(cmd) {
        dmsg(gActor.useTalkToMsg);
    }
;

////////////////////
// Yes
////////////////////

modify SayYes
    execAction(cmd) {
        dmsg(gActor.useTalkToMsg);
    }
;

////////////////////
// No
////////////////////

modify SayNo
    execAction(cmd) {
        dmsg(gActor.useTalkToMsg);
    }
;

////////////////////
// Topics
////////////////////

modify Topics
    execAction(cmd) {
        dmsg(gActor.useTalkToMsg);
    }
;

////////////////////
// Thing/Actor modifications due to Qtalkverbs.t verb modifications.
// These should be unnecessary, as the verb rules have been modified
// so that these situations should never arise. But they're here
// just for good measure.
////////////////////

modify Thing
    dobjFor(Tell) {
        verify() { illogical(notAddressableMsg); }
    }
    dobjFor(TellAbout) {
        verify() { illogical(notAddressableMsg); }
    }
    dobjFor(Ask) {
        verify() { illogical(notAddressableMsg); }
    }
    dobjFor(AskFor) {
        verify() { illogical(notAddressableMsg); }
    }
    dobjFor(AskAbout) {
        verify() { illogical(notAddressableMsg); }
    }
    //dobjFor(TalkTo) {
    //  verify() { illogical(&notAddressableMsg, self); }
    //}
;

modify Actor
    dobjFor(Tell) {
        verify() { illogical(useTalkToMsg); }
    }
    dobjFor(TellAbout) {
        verify() { illogical(useTalkToMsg); }
    }
    dobjFor(Ask) {
        verify() { illogical(useTalkToMsg); }
    }
    dobjFor(AskFor) {
        verify() { illogical(useTalkToMsg); }
    }
    dobjFor(AskAbout) {
        verify() { illogical(useTalkToMsg); }
    }
    dobjFor(TalkTo) {
        //verify() {}
        action() { say(canSayNoQuip); }
    }
;



