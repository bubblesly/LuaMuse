NotesNames = {
  C = 1,
  D = 2,
  E = 3,
  F = 4,
  G = 5,
  A = 6, 
  B = 7
}

local SHARP <const> = "♯"
local FLAT <const> = "♭"

Note = {}
Note.__index = Note

setmetatable(Note, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Note.new(name, alteration)
  local self = setmetatable({}, Note)
  self.name = name
  self.alteration = alteration
  return self
end

function Note:clone()
  return Note(self.name, self.alteration)
end

function Note.from_semitone(st, prec)
  mod_st = st % 12
  if prec ~= nil then
    local new_note_name = (prec.name % 7) + 1
    local alteration = mod_st - Note(new_note_name, 0):to_semitone()
    return Note(new_note_name, alteration)
  else
    if mod_st == 0 then
      return Note(NotesNames.C, 0)
    elseif mod_st == 1 then 
      return Note(NotesNames.C, 1)
    elseif mod_st == 2 then 
      return Note(NotesNames.D, 0)
    elseif mod_st == 3 then 
      return Note(NotesNames.D, 1)
    elseif mod_st == 4 then 
      return Note(NotesNames.E, 0)
    elseif mod_st == 5 then 
      return Note(NotesNames.F, 0)
    elseif mod_st == 6 then 
      return Note(NotesNames.F, 1)
    elseif mod_st == 7 then 
      return Note(NotesNames.G, 0)
    elseif mod_st == 8 then 
      return Note(NotesNames.G, 1)
    elseif mod_st == 9 then 
      return Note(NotesNames.A, 0)
    elseif mod_st == 10 then 
      return Note(NotesNames.A, 1)
    elseif mod_st == 11 then 
      return Note(NotesNames.B, 0)
    end
  end
end

function Note:to_semitone()
  if self.name == NotesNames.C then
    return 0 + self.alteration
  elseif self.name == NotesNames.D then
    return 2 + self.alteration
  elseif self.name == NotesNames.E then
    return 4 + self.alteration
  elseif self.name == NotesNames.F then
    return 5 + self.alteration
  elseif self.name == NotesNames.G then
    return 7 + self.alteration
  elseif self.name == NotesNames.A then
    return 9 + self.alteration
  elseif self.name == NotesNames.B then
    return 11 + self.alteration
  else
    return math.mininteger
  end
end

function Note:name_tostring()
  if self.name == NotesNames.C then
    return "C"
  elseif self.name == NotesNames.D then
    return "D"
  elseif self.name == NotesNames.E then
    return "E"
  elseif self.name == NotesNames.F then
    return "F"
  elseif self.name == NotesNames.G then
    return "G"
  elseif self.name == NotesNames.A then
    return "A"
  elseif self.name == NotesNames.B then
    return "B"
  else
    return "ERROR"
  end
end

function Note:alteration_tostring()
  if self.alteration == -2 then
    return FLAT .. FLAT
  elseif self.alteration == -1 then
    return FLAT
  elseif self.alteration == 0 then
    return ""
  elseif self.alteration == 1 then
    return SHARP
  elseif self.alteration == 2 then
    return SHARP .. SHARP
  else
    return "ERROR"
  end
end

function Note:tostring()
  return self:name_tostring() .. self:alteration_tostring()
end