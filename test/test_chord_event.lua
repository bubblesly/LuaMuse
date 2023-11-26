require('../chord_event')
require('../time')
require('../chord')
require('../note')
luaunit = require('luaunit')

TestChordEvent = {}

function TestChordEvent:setUp()
end

function TestChordEvent:tearDown()
end

function TestChordEvent:testClone()
  local evt = ChordEvent(Time(1, 1, 8), Chord(Note(NotesNames.A, 0), ChordTones.minor()))
  local clone = evt:clone()
  luaunit.assertEquals(clone, evt)
  luaunit.assertNotIs(clone, evt)
end

function TestChordEvent:testGetTimeIndex()
  local evt = ChordEvent(Time(2, 3, 8), Chord(Note(NotesNames.A, 0), ChordTones.minor()))
  luaunit.assertEquals(evt:get_time_index(), math.floor(BAR_DIVISION + 3 * BAR_DIVISION / 8.0))
end