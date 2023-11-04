require('../part')
require('../time_signature')
require('../chord_event')
require('../time')
require('../chord')
require('../note')
luaunit = require('luaunit')

TestPart = {}

function TestPart:setUp()
end

function TestPart:tearDown()
end

function TestPart:testClone()
  local time_signature = TimeSignature(4, 4)
  local chords = {
    ChordEvent(Time(1, 1, 8), Chord(Note(NotesNames.A, 0), ChordTones.minor())),
    ChordEvent(Time(3, 1, 8), Chord(Note(NotesNames.E, 0), ChordTones.minor()))
  }
  local part = Part(time_signature, 4, chords)
  local clone = part:clone()
  luaunit.assertEquals(clone, part)
  luaunit.assertNotIs(clone, part)
end

function TestPart:testGetCurrentChord()
  local time_signature = TimeSignature(4, 4)
  local a = Chord(Note(NotesNames.A, 0), ChordTones.minor())
  local e = Chord(Note(NotesNames.E, 0), ChordTones.major())
  local chords = {
    ChordEvent(Time(1, 1, 8), a),
    ChordEvent(Time(3, 1, 8), e)
  }
  local part = Part(time_signature, 4, chords)
  local t1 = Time(1, 1, 8)
  local t2 = Time(2, 2, 8)
  local t3 = Time(3, 3, 8)
  luaunit.assertEquals(part:get_current_chord(t1), a)
  luaunit.assertEquals(part:get_current_chord(t2), a)
  luaunit.assertEquals(part:get_current_chord(t3), e)
end
