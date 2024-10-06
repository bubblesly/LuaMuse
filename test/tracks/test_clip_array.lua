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
  luaunit.assertEquals(array.values[1].clips[1], clip)
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

function TestClipArray:testGetIntersectingClipsWithTwoAlignedClips()
  local t = 'some_type'
  local array = ClipArray(t)
  local clip1 = Clip(5, 23, t)
  local clip2 = Clip(5, 21, t)
  array:addClip(clip1)
  array:addClip(clip2)
  local intersecting = array:getIntersectingClips(20)
  luaunit.assertEquals(intersecting[1], clip1)
  luaunit.assertEquals(intersecting[2], clip2)
end