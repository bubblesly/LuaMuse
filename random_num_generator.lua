RandomNumGenerator = {}
RandomNumGenerator.__index = RandomNumGenerator

setmetatable(RandomNumGenerator, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

-- Pseudo random numbers generator based on the multiply with carry algorithm
function RandomNumGenerator.new(seed, carry)
  local self = setmetatable({}, RandomNumGenerator)
  -- constants
  self.a = 1103515245 --from Ansi C
  self.base = 0x10000  --from Ansi C
  self.carry = carry or 12345 --from Ansi C
  self.x = seed % self.base
  return self
end

function RandomNumGenerator:clone()
  return RandomNumGenerator(self.x, self.carry)
end

-- :gen() returns a random float between 0 and 1. 
function RandomNumGenerator:gen()
	local t = self.a * self.x + self.carry
	self.x = t % self.base
	self.carry = math.floor(t / self.base)
	return self.x / self.base
end