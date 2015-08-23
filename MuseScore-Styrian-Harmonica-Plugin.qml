//=============================================================================
//  MuseScore-Styrian-Harmonica-Plugin
//
//  Copyright (C) 2015 Wolfgang Steiner (aka. stoneMcClane)
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

      Button {
            id : buttonResetTuning
            text: qsTr("Reset to default tuning")
            anchors.top: buttonDiatonicTranspose.bottom
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: resetTuningOfNotes()
      }

      // PUSH 1st / 2nd row
      property variant note_transpose_push_1_2 : [
      //      0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //   0 -  15
      //     16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  16 -  31
      //     32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  32 -  47
      //     48    49    50    51    52    53    54    55    56    57    58    59    60    61    62    63   //
            null, null, null, null, -600, -200, null, -500, null, -200, null, -600, -200, null, -400, null, //  48 -  63
      //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            -100, -300, null, 0000, null, -400, null, -100, -200, null, +100, null, -200, +200, null, -200, //  64 -  79
      //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, +100, null, -100, +300, null, 0000, null, +300, 0000, null, +300, null, +100, null, null, //  80 -  95
      //     96    97    98    99    100   101   102   103   104   105   106   107   108   109   110   111  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  96 - 111
      //     112   113   114   115   116   117   118   119   120   121   122   123   124   125   126   127  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, // 112 - 127
      ]

      // PULL 1st / 2nd row
      property variant note_transpose_pull_1_2 : [
      //      0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //   0 -  15
      //     16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  16 -  31
      //     32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  32 -  47
      //     48    49    50    51    52    53    54    55    56    57    58    59    60    61    62    63   //
            null, null, null, null, -100, +300, null, -200, null, +100, null, -200, +200, null, -200, null, //  48 -  63
      //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            +100, -200, null, +100, null, -200, null, -100, -300, null, 0000, null, -400, 0000, null, -400, //  64 -  79
      //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, -100, null, -400, 0000, null, -500, null, -200, -500, null, -200, null, -600, null, null, //  80 -  95
      //     96    97    98    99    100   101   102   103   104   105   106   107   108   109   110   111  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  96 - 111
      //     112   113   114   115   116   117   118   119   120   121   122   123   124   125   126   127  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, // 112 - 127
      ]

      // PUSH 3rd / 4th row
      property variant note_transpose_push_3_4 : [
            //      0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //   0 -  15
            //     16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  16 -  31
            //     32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  32 -  47
            //     48    49    50    51    52    53    54    55    56    57    58    59    60    61    62    63   //
            null, null, null, null, -600, -200, null, -500, null, -200, null, -600, -200, null, -400, null, //  48 -  63
            //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            -100, -300, null, 0000, null, -400, null, -100, -200, null, +100, null, -200, +200, null, -200, //  64 -  79
            //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, +100, null, -100, +300, null, 0000, null, +300, 0000, null, +300, null, +100, null, null, //  80 -  95
            //     96    97    98    99    100   101   102   103   104   105   106   107   108   109   110   111  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  96 - 111
            //     112   113   114   115   116   117   118   119   120   121   122   123   124   125   126   127  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, // 112 - 127
      ]

      // PULL 3rd / 4th row
      property variant note_transpose_pull_3_4 : [
            //      0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //   0 -  15
            //     16    17    18    19    20    21    22    23    24    25    26    27    28    29    30    31   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  16 -  31
            //     32    33    34    35    36    37    38    39    40    41    42    43    44    45    46    47   //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  32 -  47
            //     48    49    50    51    52    53    54    55    56    57    58    59    60    61    62    63   //
            null, null, null, null, -100, +300, null, -200, null, +100, null, -200, +200, null, -200, null, //  48 -  63
            //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            +100, -200, null, +100, null, -200, null, -100, -300, null, 0000, null, -400, 0000, null, -400, //  64 -  79
            //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, -100, null, -400, 0000, null, -500, null, -200, -500, null, -200, null, -600, null, null, //  80 -  95
            //     96    97    98    99    100   101   102   103   104   105   106   107   108   109   110   111  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, //  96 - 111
            //     112   113   114   115   116   117   118   119   120   121   122   123   124   125   126   127  //
            null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, // 112 - 127
      ]

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

      function resetTuningOfNotes(){

            var range = getTargetRange();

            iterateSegments(range, function (cursor) {

                  if (cursor.element && cursor.element.type == Element.CHORD) {

                        handleChordNotes(cursor.element, undefined, function(note, push) {

                              note.tuning = 0;
                        });
                  }
            });
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

                              var tuning_table = null;

                              if (push) {
                                    // PUSH 3rd / 4th row
                                    if (note.accidental != null) {
                                          tuning_table = note_transpose_push_3_4;
                                    }
                                    // PUSH 1st / 2nd row
                                    else {
                                          tuning_table = note_transpose_push_1_2;
                                    }
                              }
                              else {
                                    // PULL 3rd / 4th row
                                    if (note.accidental != null) {
                                          tuning_table = note_transpose_pull_3_4;
                                    }
                                    // PULL 1st / 2nd row
                                    else {
                                          tuning_table = note_transpose_pull_1_2;
                                    }
                              }

                              var tuning = tuning_table[note.pitch];

                              console.log("pitch: " + note.pitch + " diatonic: " + (push ? "push" : "pull")  + " -> tuning: " + JSON.stringify(tuning));

                              if (tuning !== null)
                              {
                                    note.tuning = tuning;
                              }
                              else
                              {
                                    note.tuning = 0;
                              }
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

                  if (cursor.element && cursor.element.type == Element.CHORD) {
                        var text = newElement(Element.STAFF_TEXT);
                        text.text = "_____";
                        text.userOff.x = -2.0;
                        text.userOff.y = 9.0;
                        cursor.add(text);
                  }
            })
      }

      function applyDiatonicPull(){
            console.log("pull");
      }

      onRun: {

            if (typeof curScore === 'undefined')
                  Qt.quit();
         }
}
