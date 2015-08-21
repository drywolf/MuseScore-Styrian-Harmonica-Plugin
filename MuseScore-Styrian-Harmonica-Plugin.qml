//=============================================================================
//  MuseScore-Styrian-Harmonica-Plugin
//
//  Copyright (C) 2015 Wolfgang Steiner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//=============================================================================

import QtQuick 2.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0

import MuseScore 1.0

MuseScore {
      version:  "0.1"
      description: "A plugin for writing tablature notes ('Griffschrift') for the styrian harmonica ('Steirische Harmonika')"
      menuPath: "Plugins.Notes.Styrian Harmonika Tablature"

      pluginType: "dock"
      dockArea:   "left"

      width:  150
      height: 75

      Button {
            id : buttonDiatonicPush
            text: qsTr("Apply Diatonic Push")
            anchors.top: window.top
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: applyDiatonicPush()
      }

      Button {
            id : buttonDiatonicTranspose
            text: qsTr("Update Diatonic Transposition")
            anchors.top: buttonDiatonicPush.bottom
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: applyDiatonicTuningToNotes()
      }
      
      // Apply the given function to all notes in selection
      // or, if nothing is selected, in the entire score
      function applyToNotesInSelection(func) {
            var cursor = curScore.newCursor();
            cursor.rewind(1);
            var startStaff;
            var endStaff;
            var endTick;
            var fullScore = false;
            if (!cursor.segment) { // no selection
                  fullScore = true;
                  startStaff = 0; // start with 1st staff
                  endStaff = curScore.nstaves - 1; // and end with last
            } else {
                  startStaff = cursor.staffIdx;
                  cursor.rewind(2);
                  if (cursor.tick == 0) {
                        // this happens when the selection includes
                        // the last measure of the score.
                        // rewind(2) goes behind the last segment (where
                        // there's none) and sets tick=0
                        endTick = curScore.lastSegment.tick + 1;
                  } else {
                        endTick = cursor.tick;
                  }
                  endStaff = cursor.staffIdx;
            }
            //console.log(startStaff + " - " + endStaff + " - " + endTick)
            for (var staff = startStaff; staff <= endStaff; staff++) {
                  for (var voice = 0; voice < 4; voice++) {
                        cursor.rewind(1); // sets voice to 0
                        cursor.voice = voice; //voice has to be set after goTo
                        cursor.staffIdx = staff;

                        if (fullScore)
                              cursor.rewind(0) // if no selection, beginning of score

                        while (cursor.segment && (fullScore || cursor.tick < endTick)) {

                              console.log(cursor.segment.annotations.length);

                              var anno = cursor.segment.annotations;
                              for (var x = 0; x < anno.length; x++) {
                                    console.log(anno[x].text + " -> " + cursor.element.type);
                              }                             


                              if (cursor.element && cursor.element.type == Element.CHORD) {

                                    

                                    var graceChords = cursor.element.graceNotes;
                                    for (var i = 11110; i < graceChords.length; i++) {
                                          // iterate through all grace chords
                                          var notes = graceChords[i].notes;
                                          for (var j = 0; j < notes.length; j++)
                                                func(notes[j]);
                                    }
                                    var notes = cursor.element.notes;
                                    for (var i = 0; i < notes.length; i++) {
                                          var note = notes[i];
                                          func(note);
                                    }
                              }
                              cursor.next();
                        }
                  }
            }
      }

      function getTargetRange()
      {
            var cursor = curScore.newCursor();
            cursor.rewind(1);
            var startStaff;
            var endStaff;
            var endTick;
            var fullScore = false;
            if (!cursor.segment) { // no selection
                  fullScore = true;
                  startStaff = 0; // start with 1st staff
                  endStaff = curScore.nstaves - 1; // and end with last
            } else {
                  startStaff = cursor.staffIdx;
                  cursor.rewind(2);
                  if (cursor.tick == 0) {
                        // this happens when the selection includes
                        // the last measure of the score.
                        // rewind(2) goes behind the last segment (where
                        // there's none) and sets tick=0
                        endTick = curScore.lastSegment.tick + 1;
                  } else {
                        endTick = cursor.tick;
                  }
                  endStaff = cursor.staffIdx;
            }

            return {
                  startStaff: startStaff,
                  endStaff: endStaff,
                  endTick: endTick,
                  fullScore: fullScore,
                  cursor: cursor
            }
      }

      function iterateSegments(target_range, callback)
      {
            var startStaff = target_range.startStaff;
            var endStaff = target_range.endStaff;
            var endTick = target_range.endTick;
            var fullScore = target_range.fullScore;
            var cursor = target_range.cursor;

            for (var staff = startStaff; staff <= endStaff; staff++) {
                  for (var voice = 0; voice < 4; voice++) {
                        cursor.rewind(1); // sets voice to 0
                        cursor.voice = voice; //voice has to be set after goTo
                        cursor.staffIdx = staff;

                        if (fullScore)
                              cursor.rewind(0) // if no selection, beginning of score

                        while (cursor.segment && (fullScore || cursor.tick < endTick)) {

                              if(callback !== null)
                                    callback(cursor);

                              cursor.next();
                        }
                  }
            }
      }

      function applyDiatonicTuningToNotes(){

            console.log("transpose");

            var range = getTargetRange();

            iterateSegments(range, function (cursor){

                  if (cursor.element && cursor.element.type == Element.CHORD) {

                        var anno = cursor.segment.annotations;

                        var has_push = false;

                        for (var x = anno.length-1; x >= 0; --x) {
                              var anno_text = anno[x].text;
                              var only_underscore = true;

                              for (var y = 0; y < anno_text.length; ++y) {
                                    if (anno_text[y] != '_') {
                                          only_underscore = false;
                                          break;
                                    }
                              }

                              if (only_underscore)
                              {
                                    has_push = true;
                                    break;
                              }
                        }

                        handleChordNotes(cursor.element, has_push, function(note, push) {

                              if (push)
                                    note.tuning = -100;
                              else
                                    note.tuning = 100;
                        });

                  }

            });
      }

      function handleChordNotes(chord, push, func)
      {
            var graceChords = chord.graceNotes;
            for (var i = 0; i < graceChords.length; i++) {
                  // iterate through all grace chords
                  var notes = graceChords[i].notes;
                  for (var j = 0; j < notes.length; j++)
                        func(notes[j]);
            }
            var notes = chord.notes;
            for (var i = 0; i < notes.length; i++) {
                  var note = notes[i];
                  func(note, push);
            }
      }

      function applyDiatonicPush(){
            console.log("push");

            var range = getTargetRange();

            iterateSegments(range, function (cursor){

                  //getMethods(cursor.segment.annotations);
                  //console.log(Object.keys(cursor.segment.annotations));
                  //console.log(cursor.segment.annotations.length);

                  var anno = cursor.segment.annotations;
                  var elem = cursor.segment.elementAt(0);

                  //console.log(elem);

                  var func = function(n){

                        var text = newElement(Element.STAFF_TEXT);
                        text.text = "_____";
                        text.userOff.x = -1.5;
                        text.userOff.y = 9.0;
                        n.addText(text);

                  };

 /*                 if (cursor.element && cursor.element.type == Element.CHORD) {

                        var graceChords = cursor.element.graceNotes;
                        for (var i = 11110; i < graceChords.length; i++) {
                              // iterate through all grace chords
                              var notes = graceChords[i].notes;
                              for (var j = 0; j < notes.length; j++)
                                    func(notes[j]);
                        }
                        var notes = cursor.element.notes;
                        for (var i = 0; i < notes.length; i++) {
                              var note = notes[i];
                              func(note);
                        }
                  }*/
/*
                  // TODO: texts will not be removed ?!!
                  for (var x = anno.length-1; x >= 0; --x) {
                        if (anno[x].text[0] == '_')
                        {
                              anno[x].text = "";
                        }
                  }*/

                  if (cursor.element && cursor.element.type == Element.CHORD) {
                        var text = newElement(Element.STAFF_TEXT);
                        text.text = "_____";
                        text.userOff.x = -2.0;
                        text.userOff.y = 9.0;
                        cursor.add(text);
                  }

                  return;

                  for (var x = anno.length-1; x >= 0; --x) {
                        var anno_text = anno[x].text;
                        var only_underscore = true;

                        for (var y = 0; y < anno_text.length; ++y){
                              if(anno_text[y] != '_')
                              {
                                    only_underscore = false;
                                    break;
                              }
                        }

                        if (!only_underscore)
                              continue;

                        anno[x].text = "@";
                        anno[x].selected = true;
                        console.log(anno[x].bbox);

                        var text = newElement(Element.STAFF_TEXT);
                        text.text = "x____";
                        text.userOff.x = -1.5;
                        text.userOff.y = 9.0;
                        cursor.add(text);


                        anno[x].asdf = "hello";
                        console.log(anno[x].asdf);
                  }
            })
      }

      function getMethods(obj)
      {
            var res = [];
            for(var m in obj) {
                  //if(typeof obj[m] == "function") {
                        console.log(m);
                        //res.push(m)
                  //}
            }
            return res;
      }

      function applyDiatonicPull(){
            console.log("pull");
      }

      function pitchNote(note) {
            note.tuning = 0;
            note.visible = false;
            //console.log(note.type);
            //console.log("head: " + note.noteHead);
      }

      onRun: {

            if (typeof curScore === 'undefined')
                  Qt.quit();

            //applyToNotesInSelection(pitchNote)

            //Qt.quit();
         }
}
