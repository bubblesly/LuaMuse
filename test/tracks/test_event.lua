require('../tracks/event')
luaunit = require('luaunit')

TestEvent = {}

function TestEvent:setUp()
end

function TestEvent:tearDown()
end

function TestEvent:testNew()
  local p = 2
  local t = 'some_type'
  local event = Event(p, t)
  luaunit.assertEquals(event.position, p)
  luaunit.assertEquals(event.type, t)
end