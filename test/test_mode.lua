require('../mode')
luaunit = require('luaunit')

TestMode = {}

function TestMode:setUp()
end

function TestMode:tearDown()
end

function TestMode:testNaturalModes()
  luaunit.assertEquals(Mode.IONIAN.intervals,     {2, 2, 1, 2, 2, 2, 1})
  luaunit.assertEquals(Mode.DORIAN.intervals,     {2, 1, 2, 2, 2, 1, 2})
  luaunit.assertEquals(Mode.PHRYGIAN.intervals,   {1, 2, 2, 2, 1, 2, 2})
  luaunit.assertEquals(Mode.LYDIAN.intervals,     {2, 2, 2, 1, 2, 2, 1})
  luaunit.assertEquals(Mode.MIXOLYDIAN.intervals, {2, 2, 1, 2, 2, 1, 2})
  luaunit.assertEquals(Mode.AEOLIAN.intervals,    {2, 1, 2, 2, 1, 2, 2})
  luaunit.assertEquals(Mode.LOCRIAN.intervals,    {1, 2, 2, 1, 2, 2, 2})
end

function TestMode:testHarmonicMinorModes()
  luaunit.assertEquals(Mode.HARM_MINOR.intervals,        {2, 1, 2, 2, 1, 3, 1})
  luaunit.assertEquals(Mode.LOCRIAN_NAT6.intervals,      {1, 2, 2, 1, 3, 1, 2})
  luaunit.assertEquals(Mode.IONIAN_SHARP5.intervals,     {2, 2, 1, 3, 1, 2, 1})
  luaunit.assertEquals(Mode.DORIAN_SHARP11.intervals,    {2, 1, 3, 1, 2, 1, 2})
  luaunit.assertEquals(Mode.PHRYGIAN_DOM.intervals,      {1, 3, 1, 2, 1, 2, 2})
  luaunit.assertEquals(Mode.LYDIAN_SHARP2.intervals,     {3, 1, 2, 1, 2, 2, 1})
  luaunit.assertEquals(Mode.SUPER_LOCRIAN_BB7.intervals, {1, 2, 1, 2, 2, 1, 3})
end

function TestMode:testMelodicMinorModes()
  luaunit.assertEquals(Mode.MEL_MINOR.intervals,     {2, 1, 2, 2, 2, 2, 1})
  luaunit.assertEquals(Mode.DORIAN_B2.intervals,     {1, 2, 2, 2, 2, 1, 2})
  luaunit.assertEquals(Mode.LYDIAN_AUG.intervals,    {2, 2, 2, 2, 1, 2, 1})
  luaunit.assertEquals(Mode.LYDIAN_DOM.intervals,    {2, 2, 2, 1, 2, 1, 2})
  luaunit.assertEquals(Mode.MIXOLYDIAN_B6.intervals, {2, 2, 1, 2, 1, 2, 2})
  luaunit.assertEquals(Mode.AEOLIAN_B5.intervals,    {2, 1, 2, 1, 2, 2, 2})
  luaunit.assertEquals(Mode.ALTERED_SCALE.intervals, {1, 2, 1, 2, 2, 2, 2})
end

luaunit.LuaUnit:run()