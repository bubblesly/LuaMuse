Time = {}
Time.__index = Time

BAR_DIVISION = 256

setmetatable(Time, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Time.new(bar, offset, bar_subdiv)
  local self = setmetatable({}, Time)
  self.bar = bar
  self.offset = offset
  self.bar_subdiv = bar_subdiv
  return self
end

function Time:clone()
  return Time(self.bar, self.offset, self.bar_subdiv)
end

function Time:to_time_index()
  return math.floor(BAR_DIVISION * (self.bar - 1 + self.offset / self.bar_subdiv))
end