require('../note')
require('../chord')
require('../degree')
require('../scale')
luaunit = require('luaunit')

TestChord = {}

function TestChord:setUp()
end

function TestChord:tearDown()
end

function TestChord:testToString()
  local c = Chord(Note(NotesNames.D, 1), ChordTones.minor())
  luaunit.assertEquals(c:tostring(), "D♯min")
end

function TestChord:testChordBuilder()
  local d_minor_scale = Scale({
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, 0)
  })
  local degree = Degree(DegreeNames.III, 0)
  local chord = ChordBuilder(d_minor_scale, degree)
    :withSeventh()
    :withThirteenth()
    :build()
  luaunit.assertEquals(chord:tostring(), "FΔ7add13")
end