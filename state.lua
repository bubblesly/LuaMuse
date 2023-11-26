require("scale")
require("mode")
require("part")
require("array")
require("time")
require("chord_event")
require("time_signature")

State = {}
State.__index = State

setmetatable(State, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function State.new(scale, part)
  local self = setmetatable({}, State)
  self.scale = scale
  self.part = part
  return self
end

function State:clone()
  return State(self.scale, self.part)
end

StateGenerator = {}
StateGenerator.__index = StateGenerator

setmetatable(StateGenerator, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function StateGenerator.new()
  local self = setmetatable({}, StateGenerator)
  return self
end

function StateGenerator:clone()
  return StateGenerator()
end

function StateGenerator:generate(last_state)
  local last_scale = nil
  local last_part = nil
  if last_state ~=nil then
    last_scale = last_state.scale
    last_part = last_part.part
  end
  local scale = StateGenerator._choose_scale(last_scale)
  local part = StateGenerator._generate_part(last_part, scale)
  return State()
end



function StateGenerator._choose_scale(last_scale)
  math.randomseed(os.time())
  if last_scale ~= nil then
    local rnd = math.random(0, 2)
    if rnd == 1 then
      return last_scale:to_the_left_on_circle_of_5ths(1)
    elseif rnd == 2 then
      return last_scale:to_the_right_on_circle_of_5ths(1)
    else
      return last_scale
    end
  else
    local tonic = Note.from_semitone(math.random(0, 11))
    local mode = Mode.IONIAN
    return Scale.from_tonic_and_mode(tonic, mode)
  end
end

function StateGenerator._generate_part(last_part, scale)
  math.randomseed(os.time())
  local last_nb_bars = nil
  local last_time_signature = nil
  if last_part ~=nil then
    last_nb_bars = last_part.nb_bars
    last_time_signature = last_part.time_signature
  end
  local nb_bars = State._choose_nb_bars(last_nb_bars)
  local time_signature = State._choose_time_signature(last_time_signature)
  local chord_events = State._generate_chord_events(time_signature, nb_bars, scale)
  return Part(time_signature, nb_bars, chord_evts)
end

function StateGenerator._choose_nb_bars(last_nb_bars)
  if last_nb_bars ~= nil then
    return last_nb_bars
  else
    return math.random(4, 16)
  end
end

function StateGenerator._choose_time_signature(last_time_signature)
  local time_signature = nil
  if last_time_signature ~= nil then
    return last_time_signature
  else
    local lower = nil
    local upper = nil
    local rnd1 = math.random(0, 3)
    if rnd1 < 2 then
      lower = 4
    elseif rnd1 == 2 then
      lower = 8
    else
      lower = 16
    end
    local rnd2 = math.random(0, 5)
    if rnd2 < 3 then
      upper = lower
    elseif rnd2 == 3 then
      upper = lower - 2
    elseif rnd2 == 4
      upper = lower - 1
    else
      upper = lower + 1
    end
    return TimeSignature(upper, lower)
  end
end

function StateGenerator._generate_chord_events(time_signature, nb_bars, scale)
  local chord_evts = {}
  for b = 1, nb_bars, 1
  do
    local add_at_beginning_of_bar = false
    local rnd1 = math.random()
    if b == 1 then
      add_at_beginning_of_bar = true
    elseif b % 2 == 1 and rnd1 < .75 then
      add_at_beginning_of_bar = true
    elseif b % 2 == 0 and rnd1 < .5 then
      add_at_beginning_of_bar = true
    end
    if add_at_beginning_of_bar then
      local time = Time(b, 1, time_signature.lower)
      local chord_evt = ChordEvent(time, State._generate_random_chord(scale))
      table.insert(chord_evts, chord_evt)
    end
    local add_at_middle_of_bar = false
    local rnd2 = math.random()
    if rnd2 < .25 then
      add_at_middle_of_bar = true
    end
    if add_at_beginning_of_bar then
      local time = Time(b, math.floor(time_signature.upper / 2) + 1, time_signature.lower)
      local chord_evt = ChordEvent(time, State._generate_random_chord(scale))
      table.insert(chord_evts, chord_evt)
    end
  end
  return chord_events
end

function StateGenerator._generate_random_chord(scale)
  local deg_number = math.random(1, 7)
  local degree = Degree(deg_number, 0)
  local chord = nil
  if deg_number == 5 then
    return ChordBuilder(scale, degree)
      :withSeventh()
      :build()
  else
    return ChordBuilder(scale, degree)
      :build()
  end
end