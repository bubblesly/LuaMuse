require('../tracks/event_array')
require('../tracks/event')

luaunit = require('luaunit')

TestEventArray = {}

function TestEventArray:setUp()
end

function TestEventArray:tearDown()
end

function TestEventArray:testNew()
  local t = 'some_type'
  local array = EventArray(t)
  luaunit.assertEquals(array.type, t)
end

function TestEventArray:testAddEventWithSameType()
  local t = 'some_type'
  local array = EventArray(t)
  local event = Event(1, t)
  array:addEvent(event)
  luaunit.assertEquals(array.values[1], event)
end

function TestEventArray:testAddEventWithDifferentType()
  local t = 'some_type'
  local array = EventArray(t)
  local event = Event(1, 'other_type')
  array:addEvent(event)
  luaunit.assertEquals(array.values[1], nil)
end


function TestEventArray:testGetLastEventBefore()
  local t = 'some_type'
  local array = EventArray(t)
  local event1 = Event(5, t)
  local event2 = Event(12, t)
  array:addEvent(event1)
  array:addEvent(event2)
  luaunit.assertEquals(array:getLastEventBefore(7), event1)
  luaunit.assertEquals(array:getLastEventBefore(20), event2)
  luaunit.assertEquals(array:getLastEventBefore(4), nil)
end