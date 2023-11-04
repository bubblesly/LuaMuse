
ChordEvent = {}
ChordEvent.__index = ChordEvent

setmetatable(ChordEvent, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ChordEvent.new(time, chord)
  local self = setmetatable({}, ChordEvent)
  self.time = time
  self.chord = chord
  return self
end

function ChordEvent:clone()
  return ChordEvent(self.time:clone(), self.chord:clone())
end

function ChordEvent:get_time_index()
  return self.time:to_time_index()
end