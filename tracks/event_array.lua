require('tracks/event')

EventArray = {}
EventArray.__index = EventArray

setmetatable(EventArray, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function EventArray.new(type)
  local self = {}
  setmetatable(self, EventArray)
  self.type = type
  self.values = {}
  return self
end

function EventArray:addEvent(event)
  if event.type ~= self.type then
    return
  else
    self.values[event.position] = event
    table.sort(self.values)
  end
end

function EventArray:getLastEventBefore(position)
  local current = nil
  for pos,event in pairs(self.values) do 
    if pos <= position then
      current = event
    else 
      break
    end
  end
  return current
end