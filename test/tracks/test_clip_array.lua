require('../tracks/clip_array')
require('../tracks/clip')

luaunit = require('luaunit')

TestClipArray = {}

function TestClipArray:setUp()
end

function TestClipArray:tearDown()
end

function TestClipArray:testNew()
  local t = 'some_type'
  local array = ClipArray(t)
  luaunit.assertEquals(array.type, t)
end

function TestClipArray:testAddClipWithSameType()
  local t = 'some_type'
  local array = ClipArray(t)
  local clip = Clip(1, 23, t)
  array:addClip(clip)
  luaunit.assertEquals(array.values[1], clip)
end

function TestClipArray:testAddClipWithDifferentType()
  local t = 'some_type'
  local array = ClipArray(t)
  local clip = Clip(1, 23, 'other_type')
  array:addClip(clip)
  luaunit.assertEquals(array.values[1], nil)
end


function TestClipArray:testGetIntersectingClips()
  local t = 'some_type'
  local array = ClipArray(t)
  local clip = Clip(5, 23, t)
  array:addClip(clip)
  luaunit.assertEquals(array:getIntersectingClips(20)[1], clip)
  luaunit.assertEquals(#array:getIntersectingClips(4), 0)
end