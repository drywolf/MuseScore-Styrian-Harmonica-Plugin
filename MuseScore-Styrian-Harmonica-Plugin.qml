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
            text: qsTr("-> push <-")
            anchors.top: window.top
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: cmdApplyDiatonicPush()
      }

      Button {
            id : buttonDiatonicPull
            text: qsTr("<- pull ->")
            anchors.top: buttonDiatonicPush.bottom
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: cmdApplyDiatonicPull()
      }

      Button {
            id : buttonDiatonicTranspose
            text: qsTr("Update Diatonic Transposition")
            anchors.top: buttonDiatonicPull.bottom
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

      Button {
            id : buttonCleanDiatonicPush
            text: qsTr("Clean-Up Diatonic Push")
            anchors.top: buttonResetTuning.bottom
            anchors.left: window.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: cleanDiatonicPush()
      }

      // PUSH 1st / 2nd row
      property variant note_pitch_push_1_2 : [
      //    -29   -28   -27   -26   -25   -24   -23   -22   -21   -20   //
            null, null, null, null, null, null, null, null, null, null, // -29 ... -20
      //    -19   -18   -17   -16   -15   -14   -13   -12   -11   -10   //
            null, null, null, null, null, null, null, null, null, null, // -19 ... -10
      //     -9    -8    -7    -6    -5    -4    -3    -2    -1     0   //
             +1 ,  +3 ,   0 ,  +3 ,   0 ,  +3 ,  -1 ,  +1 ,  -2 ,  +2 , //  -9 ...   0
      //     +1    +2    +3    +4    +5    +6    +7    +8    +9   +10   //
             -2 ,  +1 ,  -2 ,  -1 ,  -4 ,   0 ,  -3 ,  -1 ,  -4 ,  -2 , //  +1 ... +10
      //    +11   +12   +13   +14   +15   +16   +17   +18   +19   +20   //
             -6 ,  -2 ,  -5 ,  -2 ,  -6 , null, null, null, null, null, // +11 ... +20
      //    +21   +22   +23   +24   +25   +26   +27   +28   +29   +30   //
            null, null, null, null, null, null, null, null, null, null, // +21 ... +30
      //    +31   +32   +33   +34   +35                                 //
            null, null, null, null, null,                               // +31 ... +35
      ]

      // PULL 1st / 2nd row
      property variant note_pitch_pull_1_2 : [
      //    -29   -28   -27   -26   -25   -24   -23   -22   -21   -20   //
            null, null, null, null, null, null, null, null, null, null, // -29 ... -20
      //    -19   -18   -17   -16   -15   -14   -13   -12   -11   -10   //
            null, null, null, null, null, null, null, null, null, null, // -19 ... -10
      //     -9    -8    -7    -6    -5    -4    -3    -2    -1     0   //
             -6 ,  -2 ,  -5 ,  -2 ,  -5 ,   0 ,  -4 ,  -1 ,  -4 ,   0 , //  -9 ...   0
      //     +1    +2    +3    +4    +5    +6    +7    +8    +9   +10   //
             -4 ,   0 ,  -3 ,  -1 ,  -2 ,  +1 ,  -2 ,  +1 ,  -2 ,  +2 , //  +1 ... +10
      //    +11   +12   +13   +14   +15   +16   +17   +18   +19   +20   //
             -2 ,  +1 ,  -2 ,  +3 ,  -1 , null, null, null, null, null, // +11 ... +20
      //    +21   +22   +23   +24   +25   +26   +27   +28   +29   +30   //
            null, null, null, null, null, null, null, null, null, null, // +21 ... +30
      //    +31   +32   +33   +34   +35                                 //
            null, null, null, null, null,                               // +31 ... +35
      ]

      // PUSH 3rd / 4th row
      property variant note_pitch_push_3_4 : [
      //    -29   -28   -27   -26   -25   -24   -23   -22   -21   -20   //
            null, null, null, null, null, null, null, null, null, null, // -29 ... -20
      //    -19   -18   -17   -16   -15   -14   -13   -12   -11   -10   //
            null, null, null, null, null, null, null, null, null, null, // -19 ... -10
      //     -9    -8    -7    -6    -5    -4    -3    -2    -1     0   //
            null, null,   0 ,   0 ,  +4 ,  +6 ,  +2 ,  +6 ,  +3 ,  +6 , //  -9 ...   0
      //     +1    +2    +3    +4    +5    +6    +7    +8    +9   +10   //
             +2 ,  +4 ,  +1 ,  +4 ,  +1 ,  +4 ,  +1 ,  +2 ,  -1 ,  +3 , //  +1 ... +10
      //    +11   +12   +13   +14   +15   +16   +17   +18   +19   +20   //
             -1 ,  +2 ,  -1 , null, null, null, null, null, null, null, // +11 ... +20
      //    +21   +22   +23   +24   +25   +26   +27   +28   +29   +30   //
            null, null, null, null, null, null, null, null, null, null, // +21 ... +30
      //    +31   +32   +33   +34   +35                                 //
            null, null, null, null, null,                               // +31 ... +35
      ]

      // PULL 3rd / 4th row
      property variant note_pitch_pull_3_4 : [
      //    -29   -28   -27   -26   -25   -24   -23   -22   -21   -20   //
            null, null, null, null, null, null, null, null, null, null, // -29 ... -20
      //    -19   -18   -17   -16   -15   -14   -13   -12   -11   -10   //
            null, null, null, null, null, null, null, null, null, null, // -19 ... -10
      //     -9    -8    -7    -6    -5    -4    -3    -2    -1     0   //
            null, null,   0 ,  +4 ,  +1 ,  +4 ,   0 ,  +4 ,  +1 ,  +5 , //  -9 ...   0
      //     +1    +2    +3    +4    +5    +6    +7    +8    +9   +10   //
             +1 ,  +4 ,  +1 ,  +5 ,  +2 ,  +6 ,  +3 ,  +6 ,  +3 ,  +6 , //  +1 ... +10
      //    +11   +12   +13   +14   +15   +16   +17   +18   +19   +20   //
             +2 ,  +7 ,  +4 , null, null, null, null, null, null, null, // +11 ... +20
      //    +21   +22   +23   +24   +25   +26   +27   +28   +29   +30   //
            null, null, null, null, null, null, null, null, null, null, // +21 ... +30
      //    +31   +32   +33   +34   +35                                 //
            null, null, null, null, null,                               // +31 ... +35
      ]





      // OLD

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
            null, null, null, null, null, null, null, null, null, -100, null, +200, null, -100, +300, null, //  48 -  63
      //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            -100, null, +200, +100, null, +400, null, +100, null, +400, +100, null, +400, null, +200, +600, //  64 -  79
      //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, +300, null, +600, null, +200, +600, null, +400, null, null, null, null, null, null, null, //  80 -  95
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
            null, null, null, null, null, null, null, null, null, +400, null, +700, null, +200, +600, null, //  48 -  63
      //     64    65    66    67    68    69    70    71    72    73    74    75    76    77    78    79   //
            +300, null, +600, +300, null, +600, null, +200, null, +500, +100, null, +400, null, +100, +500, //  64 -  79
      //     80    81    82    83    84    85    86    87    88    89    90    91    92    93    94    95   //
            null, +100, null, +400, null, 0000, +400, null, +100, null, +400, 0000, null, null, null, null, //  80 -  95
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
                                    // do not advance cursor, requested by callback internally
                                    if(callback(cursor))
                                          continue;

                              cursor.next();
                        }
                  }
            }
      }

      function findNext(target_range, element_type) {

            var endTick = target_range.endTick;
            var fullScore = target_range.fullScore;
            var cursor = target_range.cursor;

            cursor.next();

            while (cursor.segment && (fullScore || cursor.tick < endTick)) {

                  if (cursor.element && cursor.element.type == element_type)
                        return true;

                  cursor.next();
            }

            return false;
      }

      function resetTuningOfNotes(){

            var range = getTargetRange();

            iterateSegments(range, function (cursor) {

                  if (cursor.element && cursor.element.type == Element.CHORD) {

                        handleChordNotes(cursor.element, undefined, function(note, push) {

                              note.tuning = 0;
                              note.pitchOffset = 0;
                        });
                  }
            });
      }

      function getDiatonicPush(segment){

            var push_lines = [];
            var anno = segment.annotations;

            for (var x = anno.length-1; x >= 0; --x) {
                  var anno_text = anno[x].text;
                  var only_underscore = anno_text.length > 0;

                  for (var y = 0; y < anno_text.length; ++y) {
                        if (anno_text[y] != '_') {
                              only_underscore = false;
                              break;
                        }
                  }

                  if (only_underscore)
                        push_lines.push(anno[x]);
            }

            return push_lines.length > 0 ? push_lines : null;
      }

      function applyDiatonicTuningToNotes(range){

            console.log("transpose");

            range = range || getTargetRange();

            iterateSegments(range, function (cursor){

                  if (cursor.element && cursor.element.type == Element.CHORD) {

                        var has_push = getDiatonicPush(cursor.segment) != null;

                        handleChordNotes(cursor.element, has_push, function(note, push) {

                              var tuning_table = null;

                              if (push) {
                                    // PUSH 3rd / 4th row
                                    if (note.accidental != null && note.accidental.accType === 3) {
                                          //tuning_table = note_transpose_push_3_4;
                                          tuning_table = note_pitch_push_3_4;
                                    }
                                    // PUSH 1st / 2nd row
                                    else {
                                          //tuning_table = note_transpose_push_1_2;
                                          tuning_table = note_pitch_push_1_2;
                                    }
                              }
                              else {
                                    // PULL 3rd / 4th row
                                    if (note.accidental != null && note.accidental.accType === 3) {
                                          //tuning_table = note_transpose_pull_3_4;
                                          tuning_table = note_pitch_pull_3_4;
                                    }
                                    // PULL 1st / 2nd row
                                    else {
                                          //tuning_table = note_transpose_pull_1_2;
                                          tuning_table = note_pitch_pull_1_2;
                                    }
                              }

                              if (!tuning_table)
                                    return;

                              //var tuning = tuning_table[note.pitch];
                              var pitch_offset = tuning_table[note.line + 29];

                              //console.log("line: " + note.line + " diatonic: " + (push ? "push" : "pull")  + " -> pitch-offset: " + JSON.stringify(pitch_offset));

                              //if (note.accidental)
                              //      console.log("acc: " + note.accidental.accType);

                              if (pitch_offset !== null)
                              {
                                    note.pitchOffset = pitch_offset;
                                    console.log("line: " + note.line + " diatonic: " + (push ? "push" : "pull")  + " -> pitch-offset: " + JSON.stringify(pitch_offset));
                              }
                              else
                              {
                                    console.log("unknown pitch for note-line: " + note.line + " diatonic: " + (push ? "push" : "pull") + " row: " + ((note.accidental) ? "3/4" : "1/2"));
                                    note.pitchOffset = 0;
                              }
                        });
                  }
            });
      }

      function handleChordNotes(chord, arg0, func)
      {
            var graceChords = chord.graceNotes;
            for (var i = 0; i < graceChords.length; i++) {
                  // iterate through all grace chords
                  var notes = graceChords[i].notes;
                  for (var j = 0; j < notes.length; j++)
                        func(notes[j], arg0);
            }
            var notes = chord.notes;
            for (var i = 0; i < notes.length; i++) {
                  var note = notes[i];
                  func(note, arg0);
            }
      }

      function cmdApplyDiatonicPush(){
            console.log("push");

            var range = getTargetRange();

            iterateSegments(range, function (cursor){

                  assertPushLine(cursor);
            });

            curScore.doLayout();

            applyDiatonicTuningToNotes(range);

            cleanDiatonicPush(range);
      }

      function assertPushLine(cursor) {

            var push_lines = getDiatonicPush(cursor.segment);

            // return null if no new line was added
            if (push_lines)
                  return null;

            // add a new push line and return
            return addPushLine(cursor);
      }

      function addPushLine(cursor) {

            if (cursor.element && cursor.element.type == Element.CHORD) {
                  var text = newElement(Element.STAFF_TEXT);
                  text.text = "_____";
                  text.userOff.x = -2.0;
                  text.userOff.y = 10.0;
                  cursor.add(text);
                  return text;
            }

            return null;
      }

      function removePushLine(cursor) {

            var push_lines = getDiatonicPush(cursor.segment);

            if (!push_lines)
                  return;

            for (var i = 0; i < push_lines.length; i++) {

                  var line = push_lines[i];
                  var parent = line.parent;

                  if (!line || !parent)
                        continue;

                  parent.remove(line);
            }
      }

      function cleanDiatonicPush(range){
            console.log("clean push");

            range = range || getTargetRange();

            iterateSegments(range, function (cursor) {

                  if (cursor.element && cursor.element.type == Element.CHORD) {

                        var push_lines = getDiatonicPush(cursor.segment);

                        if (!push_lines)
                              return;

                        // remove all lines except for the first
                        for (var i = 1; i < push_lines.length; i++) {

                              var line = push_lines[i];
                              var parent = line.parent;

                              if (!line || !parent)
                                    continue;

                              parent.remove(line);
                        }

                        if (push_lines.length > 1)
                              console.log("removed " + (push_lines.length - 1) + " duplicated diatonic push-lines");

                        for (var i = 0; i < push_lines.length; i++) {

                              var push_line = push_lines[i];

                              // TODO: need Text.textStyle QML property here
                              // push_line.type

                              if (!push_line)
                                    return;

                              if (push_line.userOff)
                                    push_line.userOff.y = 10.0;
                        }

                        var line1 = push_lines[0];

                        var ties_to_next_chord = false;
                        handleChordNotes(cursor.element, undefined, function(note, push) {

                              if (note.tieFor !== null) {
                                    ties_to_next_chord = true;
                              }
                        });

                        // fetch next chord
                        if (findNext(range, Element.CHORD)) {

                              if (ties_to_next_chord)
                                    if (assertPushLine(cursor))
                                          console.log("added new push line between tied chords");

                              var push_lines_next = getDiatonicPush(cursor.segment);

                              if (!push_lines_next)
                              {
                                    console.log("unable to find next push line");
                                    return;
                              }

                              var line2 = push_lines_next[0];

                              //console.log("line1: " + line1.pagePos + " > " + line1.bbox);
                              //console.log("line2: " + line2.pagePos + " > " + line2.bbox);

                              var t = 0;
                              while (t++ < 20) {

                                    var l1_right = line1.pagePos.x + line1.bbox.width;
                                    var l2_left = line2.pagePos.x;

                                    var padding = 1.0;
                                    var dist = l1_right - l2_left - padding;

                                    // lines touch
                                    if (dist > 0)
                                          break;

                                    //console.log("line-dist: " + dist);

                                    line1.text += "_";

                                    // TODO:
                                    // 1) use note.layout() for better performance
                                    // 2) correctly calculate the push line bbox & placement in relation to the chord
                                    //curScore.doLayout();
                                    line1.layout();
                              }

                              console.log("advanced line width by: " + t);

                              // tell iterateSegments() to not advance the cursor
                              return true;
                        }
                  }
            });

            curScore.doLayout();
      }

      function cmdApplyDiatonicPull(){
            console.log("pull");

            var range = getTargetRange();

            iterateSegments(range, function (cursor){

                  removePushLine(cursor);
            });

            curScore.doLayout();

            applyDiatonicTuningToNotes(range);
      }

      onRun: {

            if (typeof curScore === 'undefined')
                  Qt.quit();
         }
}
