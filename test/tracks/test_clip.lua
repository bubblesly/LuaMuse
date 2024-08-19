require('../tracks/clip')
luaunit = require('luaunit')

TestClip = {}

function TestClip:setUp()
end

function TestClip:tearDown()
end

function TestClip:testNew()
  local p = 2
  local d = 23
  local t = 'some_type'
  local clip = Clip(p, d, t)
  luaunit.assertEquals(clip.position, p)
  luaunit.assertEquals(clip.duration, d)
  luaunit.assertEquals(clip.type, t)
end