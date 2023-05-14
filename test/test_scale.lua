require('../scale')
luaunit = require('luaunit')

TestScale = {}

function TestScale:setUp()
end

function TestScale:tearDown()
end

function TestScale:testCMajor()
  luaunit.assertEquals(Scale.c_major().notes, {
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  })
end

function TestScale:testTranspose()
  local c_major = Scale({
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  })
  luaunit.assertEquals(c_major:transpose(Note(NotesNames.C, 0)), Scale({
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  }))
  luaunit.assertEquals(c_major:transpose(Note(NotesNames.D, 0)), Scale({
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1)
  }))
  luaunit.assertEquals(c_major:transpose(Note(NotesNames.E, -1)), Scale({
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, -1),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0)
  }))

  local g_minor = Scale({
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0)
  })
  luaunit.assertEquals(g_minor:transpose(Note(NotesNames.A, 0)), Scale({
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0)
  }))
end

function TestScale:testGetMajor()
  luaunit.assertEquals(Scale.get_major(Note(NotesNames.C, 0)), Scale({
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  }))

  luaunit.assertEquals(Scale.get_major(Note(NotesNames.G, 0)), Scale({
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 1)
  }))

  luaunit.assertEquals(Scale.get_major(Note(NotesNames.G, 1)), Scale({
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 1),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1),
    Note(NotesNames.F, 2)
  }))

  luaunit.assertEquals(Scale.get_major(Note(NotesNames.F, 1)), Scale({
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1)
  }))

  luaunit.assertEquals(Scale.get_major(Note(NotesNames.B, -1)), Scale({
    Note(NotesNames.B, -1),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0)
  }))
end

function TestScale:testClone()
  local c_major = Scale.c_major()
  local clone = c_major:clone()
  luaunit.assertEquals(c_major, clone)
  luaunit.assertNotIs(c_major, clone)
end

function TestScale:testRotate()
  local c_major = Scale.c_major()
  luaunit.assertEquals(c_major:rotate(1), Scale.c_major())
  luaunit.assertEquals(c_major:rotate(2), Scale({
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0),
  }))
  luaunit.assertEquals(c_major:rotate(7), Scale({
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
  }))
end

function TestScale:testAddAlteration()
  luaunit.assertEquals(Scale.c_major():add_alteration(2, -1), Scale({
    Note(NotesNames.C, 0),
    Note(NotesNames.D, -1),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 0),
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0)
  }))
end

function TestScale:testAddAlterations()
  local scale = Scale.c_major()
    :add_alteration(2, -1)
    :add_alterations({-1, 0, 1, -1, 0, -1, 0})
  luaunit.assertEquals(scale, Scale({
    Note(NotesNames.C, -1),
    Note(NotesNames.D, -1),
    Note(NotesNames.E,  1),
    Note(NotesNames.F, -1),
    Note(NotesNames.G,  0),
    Note(NotesNames.A, -1),
    Note(NotesNames.B,  0)
  }))
end

function TestScale:testToSemitones()
  local g_scale = Scale({
    Note(NotesNames.G, 0),
    Note(NotesNames.A, 0),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0),
    Note(NotesNames.D, 0),
    Note(NotesNames.E, 0),
    Note(NotesNames.F, 1)
  })
  luaunit.assertEquals(g_scale:to_semitones(), {
    7,
    9,
    11,
    12,
    14,
    16,
    18
  })
end

luaunit.LuaUnit:run()