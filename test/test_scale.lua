require('../scale')
require('../note')
require('../mode')
luaunit = require('luaunit')

TestScale = {}

function TestScale:setUp()
end

function TestScale:tearDown()
end

function TestScale:testFromTonicAndMode()
  local esharp = Note(NotesNames.E, 1)
  local esharp_locrian = Scale.from_tonic_and_mode(esharp, Mode.LOCRIAN)
  luaunit.assertEquals(esharp_locrian.notes, {
    Note(NotesNames.E, 1),
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1)
  })
end

function TestScale:testGetTonic()
  local esharp = Note(NotesNames.E, 1)
  local esharp_locrian = Scale.from_tonic_and_mode(esharp, Mode.LOCRIAN)
  luaunit.assertEquals(esharp_locrian:get_tonic(), esharp)
end

function TestScale:testGetMode()
  local esharp = Note(NotesNames.E, 1)
  local esharp_locrian = Scale.from_tonic_and_mode(esharp, Mode.LOCRIAN)
  luaunit.assertEquals(esharp_locrian:get_mode(), Mode.LOCRIAN)
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

function TestScale:testGetDownwardEnharmonics()
  local g_flat_scale = Scale({
    Note(NotesNames.G, -1),
    Note(NotesNames.A, -1),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, -1),
    Note(NotesNames.D, -1),
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0)
  })
  luaunit.assertEquals(g_flat_scale:get_downward_enharmonic(), Scale({
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1)
  }))
end

function TestScale:testGetUpwardEnharmonics()
  local f_sharp_scale = Scale({
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1)
  })
  luaunit.assertEquals(f_sharp_scale:get_upward_enharmonic(), Scale({
    Note(NotesNames.G, -1),
    Note(NotesNames.A, -1),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, -1),
    Note(NotesNames.D, -1),
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0)
  }))
end

function TestScale:testGetDistance()
  local f_sharp_maj = Scale({
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1),
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1)
  })
  local g_flat_maj = Scale({
    Note(NotesNames.G, -1),
    Note(NotesNames.A, -1),
    Note(NotesNames.B, -1),
    Note(NotesNames.C, -1),
    Note(NotesNames.D, -1),
    Note(NotesNames.E, -1),
    Note(NotesNames.F, 0)
  })
  local g_flat_min = Scale({
    Note(NotesNames.G, -1),
    Note(NotesNames.A, -1),
    Note(NotesNames.B, -2),
    Note(NotesNames.C, -1),
    Note(NotesNames.D, -1),
    Note(NotesNames.E, -2),
    Note(NotesNames.F, 0)
  })
  local d_sharp_min = Scale({
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1),
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 1)
  })
  local d_sharp_min_harm = Scale({
    Note(NotesNames.D, 1),
    Note(NotesNames.E, 1),
    Note(NotesNames.F, 1),
    Note(NotesNames.G, 1),
    Note(NotesNames.A, 1),
    Note(NotesNames.B, 0),
    Note(NotesNames.C, 0)
  })
  luaunit.assertEquals(f_sharp_maj:get_distance(g_flat_maj), 0)
  luaunit.assertEquals(f_sharp_maj:get_distance(g_flat_min), 2)
  luaunit.assertEquals(f_sharp_maj:get_distance(d_sharp_min), 0)
  luaunit.assertEquals(f_sharp_maj:get_distance(d_sharp_min_harm), 1)
end