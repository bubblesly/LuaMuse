require('../note')
luaunit = require('luaunit')

TestNote = {}

function TestNote:setUp()
end

function TestNote:tearDown()
end

function TestNote:testClone()
  local note = Note(NotesNames.D, 1)
  local clone = note:clone()
  luaunit.assertEquals(clone, Note(NotesNames.D, 1))
  luaunit.assertNotIs(clone, note)
end

function TestNote:testToStringForSharp()
  local note = Note(NotesNames.D, 1)
  luaunit.assertEquals(note:tostring(), "D♯")
  luaunit.assertEquals(note:name_tostring(), "D")
  luaunit.assertEquals(note:alteration_tostring(), "♯")
end

function TestNote:testToStringForFlat()
  local note = Note(NotesNames.G, -1)
  luaunit.assertEquals(note:tostring(), "G♭")
  luaunit.assertEquals(note:name_tostring(), "G")
  luaunit.assertEquals(note:alteration_tostring(), "♭")
end



function TestNote:testFromSemitone()
  luaunit.assertEquals(Note.from_semitone(0), Note(NotesNames.C, 0))
  luaunit.assertEquals(Note.from_semitone(1), Note(NotesNames.C, 1))
  luaunit.assertEquals(Note.from_semitone(2), Note(NotesNames.D, 0))
  luaunit.assertEquals(Note.from_semitone(3), Note(NotesNames.D, 1))
  luaunit.assertEquals(Note.from_semitone(4), Note(NotesNames.E, 0))
  luaunit.assertEquals(Note.from_semitone(5), Note(NotesNames.F, 0))
  luaunit.assertEquals(Note.from_semitone(6), Note(NotesNames.F, 1))
  luaunit.assertEquals(Note.from_semitone(7), Note(NotesNames.G, 0))
  luaunit.assertEquals(Note.from_semitone(8), Note(NotesNames.G, 1))
  luaunit.assertEquals(Note.from_semitone(9), Note(NotesNames.A, 0))
  luaunit.assertEquals(Note.from_semitone(10), Note(NotesNames.A, 1))
  luaunit.assertEquals(Note.from_semitone(11), Note(NotesNames.B, 0))
end

function TestNote:testToSemitone()
  local note = Note(NotesNames.G, -1)
  luaunit.assertEquals(note:to_semitone(), 6)
end

function TestNote:testEnharmonics()
  luaunit.assertEquals(Note(NotesNames.A, -1):get_downward_enharmonic(), Note(NotesNames.G, 1))
  luaunit.assertEquals(Note(NotesNames.A, -1):get_upward_enharmonic(), Note(NotesNames.B, -3))
  luaunit.assertEquals(Note(NotesNames.B, 0):get_downward_enharmonic(), Note(NotesNames.A, 2))
  luaunit.assertEquals(Note(NotesNames.B, 0):get_upward_enharmonic(), Note(NotesNames.C, -1))
  luaunit.assertEquals(Note(NotesNames.F, 1):get_downward_enharmonic(), Note(NotesNames.E, 2))
  luaunit.assertEquals(Note(NotesNames.F, 1):get_upward_enharmonic(), Note(NotesNames.G, -1))
  luaunit.assertEquals(Note(NotesNames.C, 1):get_downward_enharmonic(), Note(NotesNames.B, 2))
  luaunit.assertEquals(Note(NotesNames.C, 1):get_upward_enharmonic(), Note(NotesNames.D, -1))
end
