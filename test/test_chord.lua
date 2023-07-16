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

function TestChord:test_to_notes()
  local tones = ChordTones
    :minor()
    :add_seventh(ToneAlterations.MINOR)
    :add_extension(ChordToneNames.ELEVENTH, ToneAlterations.NONE)
  local c = Chord(Note(NotesNames.D, 1), tones)
  local expected = {Note(NotesNames.D, 1), Note(NotesNames.F, 1), Note(NotesNames.A, 1), Note(NotesNames.C, 1), Note(NotesNames.G, 1)}
  luaunit.assertEquals(c:to_notes(), expected)
end

function TestChord:test_to_asc_semitones()
  local tones = ChordTones
    :minor()
    :add_seventh(ToneAlterations.MINOR)
    :add_extension(ChordToneNames.ELEVENTH, ToneAlterations.NONE)
  local c = Chord(Note(NotesNames.D, 1), tones)
  local expected = {3, 6, 10, 13, 20}
  luaunit.assertEquals(c:to_ascending_semitones(), expected)
end