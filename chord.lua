require("note")
require("array")

local SHARP <const> = "♯"
local FLAT <const> = "♭"

ChordToneNames = {
  THIRD      = 1,
  FIFTH      = 2,
  SEVENTH    = 3,
  NINTH      = 4,
  ELEVENTH   = 5,
  THIRTEENTH = 6
}

ToneAlterations = {
  NONE       = 1,
  SHARP      = 2,
  FLAT       = 3,
  MINOR      = 4,
  MAJOR      = 5,
  SUS2       = 6,
  SUS4       = 7,
  PERFECT    = 8,
  AUGMENTED  = 9,
  DIMINISHED = 10
}

ChordTones = {}
ChordTones.__index = ChordTones

setmetatable(ChordTones, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ChordTones.new(tones)
  local self = setmetatable({}, ChordTones)
  self.tones = Array(tones)
  return self
end

function ChordTones.major()
  local t = {
    [ChordToneNames.THIRD] = ToneAlterations.MAJOR,
    [ChordToneNames.FIFTH] = ToneAlterations.PERFECT
  }
  return ChordTones(t)
end

function ChordTones.minor()
  return ChordTones({
    [ChordToneNames.THIRD] = ToneAlterations.MINOR,
    [ChordToneNames.FIFTH] = ToneAlterations.PERFECT
  })
end

function ChordTones.sus2()
  return ChordTones({
    [ChordToneNames.THIRD] = ToneAlterations.SUS2,
    [ChordToneNames.FIFTH] = ToneAlterations.PERFECT
  })
end

function ChordTones.sus4()
  return ChordTones({
    [ChordToneNames.THIRD] = ToneAlterations.SUS4,
    [ChordToneNames.FIFTH] = ToneAlterations.PERFECT
  })
end

function ChordTones.diminished()
  return ChordTones({
    [ChordToneNames.THIRD] = ToneAlterations.MINOR,
    [ChordToneNames.FIFTH] = ToneAlterations.DIMINISHED
  })
end

function ChordTones.augmented()
  return ChordTones({
    [ChordToneNames.THIRD] = ToneAlterations.MAJOR,
    [ChordToneNames.FIFTH] = ToneAlterations.AUGMENTED
  })
end

function ChordTones:clone()
  return ChordTones(self.tones:clone())
end

function ChordTones:add_seventh(alteration)
  local tones = self.tones:clone()
  tones[ChordToneNames.SEVENTH] = alteration
  return ChordTones(tones)
end

function ChordTones:add_extension(name, alteration)
  local tones = self.tones:clone()
  tones[name] = alteration
  return ChordTones(tones)
end

function ChordTones:tostring()
  function chordal_tones_tostring(tones)
    if tones[ChordToneNames.SEVENTH] == nil then
      if self.fifthSpec == ToneAlterations.DIMINISHED then
        return "dim"
      elseif tones[ChordToneNames.FIFTH] == ToneAlterations.AUGMENTED then
        return "+"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MAJOR then
        return "maj"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MINOR then
        return "min"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS2 then
        return "sus2"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS4 then
        return "sus4"
      elseif tones[ChordToneNames.FIFTH] == ToneAlterations.PERFECT then
          return "5"
      else
        return ""
      end
    elseif tones[ChordToneNames.SEVENTH] == ToneAlterations.MINOR then
      if tones[ChordToneNames.FIFTH] == ToneAlterations.DIMINISHED then
        return "ø7"
      elseif tones[ChordToneNames.FIFTH] == ToneAlterations.AUGMENTED then
        return "+7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MAJOR then
        return "7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MINOR then
        return "min7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS2 then
        return "7sus2"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS4 then
        return "7sus4"
      else
        -- no third, we arbitrarily write it as dominant
        return "7"
      end
    elseif tones[ChordToneNames.SEVENTH] == ToneAlterations.MAJOR then
      if tones[ChordToneNames.FIFTH] == ToneAlterations.AUGMENTED then
        return "+7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MAJOR then
        return "Δ7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.MINOR then
        return "minM7"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS2 then
        return "M7sus2"
      elseif tones[ChordToneNames.THIRD] == ToneAlterations.SUS4 then
        return "M7sus4"
      else
        -- no third, we arbitrarily write it as major
        return "Δ7"
      end
    elseif tones[ChordToneNames.SEVENTH] == ToneAlterations.DIMINISHED then
      return "°"
    end
    return ""
  end
  function extensions_tostring(tones)
    local ext = ""
    if tones[ChordToneNames.NINTH] == ToneAlterations.NONE then
      ext = ext .. "add9"
    elseif tones[ChordToneNames.NINTH] == ToneAlterations.SHARP then
      ext = ext .. "add" .. SHARP .. "9"
    elseif tones[ChordToneNames.NINTH] == ToneAlterations.FLAT then
      ext = ext .. "add" .. FLAT .. "9"
    end
    if tones[ChordToneNames.ELEVENTH] == ToneAlterations.NONE then
      ext = ext .. "add11"
    elseif tones[ChordToneNames.ELEVENTH] == ToneAlterations.SHARP then
      ext = ext .. "add" .. SHARP .. "11"
    elseif tones[ChordToneNames.ELEVENTH] == ToneAlterations.FLAT then
      ext = ext .. "add" .. FLAT .. "11"
    end
    if tones[ChordToneNames.THIRTEENTH] == ToneAlterations.NONE then
      ext = ext .. "add13"
    elseif tones[ChordToneNames.THIRTEENTH] == ToneAlterations.SHARP then
      ext = ext .. "add" .. SHARP .. "13"
    elseif tones[ChordToneNames.THIRTEENTH] == ToneAlterations.FLAT then
      ext = ext .. "add" .. FLAT .. "13"
    end
    return ext
  end
  return chordal_tones_tostring(self.tones) .. extensions_tostring(self.tones)
end

Chord = {}
Chord.__index = Chord

setmetatable(Chord, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Chord.new(tonic, tones)
  local self = setmetatable({}, Chord)
  self.tonic = tonic
  self.tones = tones
  return self
end

function Chord:clone()
  return Chord(self.tonic:clone(), self.tones:clone())
end

function Chord:tostring()
  return self.tonic:tostring() .. self.tones:tostring()
end

ChordBuilder = {}
ChordBuilder.__index = ChordBuilder

setmetatable(ChordBuilder, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function ChordBuilder.new(scale, degree)
  local self = setmetatable({}, ChordBuilder)
  self.scale = scale
  self.degree = degree
  self.seventh = false
  self.ninth = false
  self.eleventh = false
  self.thirteenth = false
  return self
end

function ChordBuilder:clone()
  local b = ChordBuilder(self.scale, self.degree)
  b.seventh = self.seventh
  b.ninth = self.ninth
  b.eleventh = self.eleventh
  b.thirteenth = self.thirteenth
  return b
end

function ChordBuilder:withSeventh()
  local b = self:clone()
  b.seventh = true
  return b
end

function ChordBuilder:withNinth()
  local b = self:clone()
  b.ninth = true
  return b
end

function ChordBuilder:withEleventh()
  local b = self:clone()
  b.eleventh = true
  return b
end

function ChordBuilder:withThirteenth()
  local b = self:clone()
  b.thirteenth = true
  return b
end

function ChordBuilder:build()
  function get_interval(from, to)
    return (to:to_semitone() - from:to_semitone() + 12) % 12
  end

  function get_third(tonic_note, scale, degree)
    local third_note = scale:get_note_from_degree(degree:offset(2))
    local semi_tones = get_interval(tonic_note, third_note)
    local alt = ToneAlterations.MAJOR
    if semi_tones == 3 then
      alt = ToneAlterations.MINOR
    end
    return alt
  end

  function get_fifth(tonic_note, scale, degree)
    local fifth_note = scale:get_note_from_degree(degree:offset(4))
    local semi_tones = get_interval(tonic_note, fifth_note)
    local alt = ToneAlterations.PERFECT
    if semi_tones == 6 then
      alt = ToneAlterations.DIMINISHED
    elseif semi_tones == 8 then
      alt = ToneAlterations.AUGMENTED
    end
    return alt
  end

  function get_seventh(tonic_note, scale, degree)
    local seventh_note = scale:get_note_from_degree(degree:offset(6))
    local semi_tones = get_interval(tonic_note, seventh_note)
    local alt = ToneAlterations.MAJOR
    if semi_tones == 10 then
      alt = ToneAlterations.MINOR
    elseif semi_tones == 9 then
      alt = ToneAlterations.DIMINISHED
    end
    return alt
  end

  function get_ninth(tonic_note, scale, degree)
    local ninth_note = scale:get_note_from_degree(degree:offset(1))
    local semi_tones = get_interval(tonic_note, ninth_note)
    local alt = ToneAlterations.NONE
    if semi_tones == 1 then
      alt = ToneAlterations.FLAT
    end
    return alt
  end

  function get_eleventh(tonic_note, scale, degree)
    local eleventh_note = scale:get_note_from_degree(degree:offset(3))
    local semi_tones = get_interval(tonic_note, eleventh_note)
    local alt = ToneAlterations.NONE
    if semi_tones == 6 then
      alt = ToneAlterations.SHARP
    end
    return alt
  end

  function get_thirteenth(tonic_note, scale, degree)
    local thirteenth_note = scale:get_note_from_degree(degree:offset(5))
    local semi_tones = get_interval(tonic_note, thirteenth_note)
    local alt = ToneAlterations.NONE
    if semi_tones == 8 then
      alt = ToneAlterations.FLAT
    end
    return alt
  end

  function get_triad(tonic, scale, degree)
    local fifth = get_fifth(tonic, scale, degree)
    if fifth == ToneAlterations.PERFECT then
      local third = get_third(tonic, scale, degree)
      if third == ToneAlterations.SUS2 then
        return Chord(tonic, ChordTones.sus2())
      elseif third == ToneAlterations.SUS4 then
        return Chord(tonic, ChordTones.sus4())
      elseif third == ToneAlterations.MINOR then
        return Chord(tonic, ChordTones.minor())
      elseif third == ToneAlterations.MAJOR then
        return Chord(tonic, ChordTones.major())
      else
        return nil
      end
    elseif fifth == ToneAlterations.DIMINISHED then
      return Chord(tonic, ChordTones.diminished())
    elseif fifth == ToneAlterations.AUGMENTED then
      return Chord(tonic, ChordTones.augmented())
    end
  end

  function add_extensions(triad, tonic, scale, degree)
    local chord = triad:clone()
    if self.seventh then
      local seventh = get_seventh(tonic, scale, degree)
      chord = Chord(chord.tonic:clone(), chord.tones:add_seventh(seventh))
    end
    if self.ninth then
      local ninth = get_ninth(tonic, scale, degree)
      chord = Chord(chord.tonic:clone(), chord.tones:add_extension(ChordToneNames.NINTH, ninth))
    end
    if self.eleventh then
      local eleventh = get_eleventh(tonic, scale, degree)
      chord = Chord(chord.tonic:clone(), chord.tones:add_extension(ChordToneNames.ELEVENTH, eleventh))
    end
    if self.thirteenth then
      local thirteenth = get_thirteenth(tonic, scale, degree)
      chord = Chord(chord.tonic:clone(), chord.tones:add_extension(ChordToneNames.THIRTEENTH, thirteenth))
    end
    return chord
  end
  local tonic = self.scale:get_note_from_degree(self.degree)
  local chord = get_triad(tonic, self.scale, self.degree)
  return add_extensions(chord, tonic, self.scale, self.degree)
end