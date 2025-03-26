Array = {}
Array.__index = Array

setmetatable(Array, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Array.new(a)
  a = a or {}
  local self = setmetatable(a, Array)
  return self
end

local function cloneElt(elt)
  if type(elt) == "table" and elt.clone ~= nil then
    return elt:clone()
  else
    return elt
  end
end

function Array:clone()
  local a = {}
  for _, elt in ipairs(self) do
    table.insert(a, cloneElt(elt))
  end
  return Array(a)
end

function Array:tostring()
  function dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end
  return dump(self)
end

function Array:push_head(elt)
  local res = self:clone()
  table.insert(res, 1, elt)
  return res
end

function Array:pop_head(elt)
  local a = self:clone()
  local head = table.remove(a, 1)
  return head, a
end

function Array:push_tail(elt)
  local res = self:clone()
  table.insert(res, elt)
  return res
end

function Array:pop_tail(elt)
  local a = self:clone()
  local tail = table.remove(a)
  return a, tail
end

function Array:map(f)
  local a = {}
  for k,v in pairs(self) do
      a[k] = f(v)
  end
  return Array(a)
end

function Array:find(f)
  for i, v in ipairs(self) do
    if f(v) then
      return v
    end
  end
  return nil
end

function Array:sort(f)
  local sorted = self:clone()
  table.sort(sorted, f)
  return sorted
end

function Array:zip(tbl)
  local new_tbl = {}
  local size = math.max(#self, #tbl)
  for i=1, size do
    local one = cloneElt(self[i])
    local two = cloneElt(tbl[i])
    new_tbl[i] = {one, two}
  end
  return Array(new_tbl)
end

function Array:add_to_values(value)
  return self:map(function(item) return item + value end)
end

function Array:rotate_values(rotation)
  local new_table = {}
  local size = #self
  for i=1, size do
    local pos = (i - 1 + rotation) % size + 1
    local elt = cloneElt(self[pos])
    table.insert(new_table, elt)
  end
  return Array(new_table)
end

function Array:diff_values(table)
  return self
    :zip(table)
    :map(function(e) return e[1] - e[2] end)
end

function Array:fold_left(acc, f)
  function do_fold(acc, f, i, size)
    if i > size then
      return acc
    else
      return do_fold(f(acc, self[i]), f, i + 1, size)
    end
  end
  return do_fold(acc, f, 1, #self)
end

function Array:acc_table_values()
  local f = function(acc, elt)
    local size = #acc
    local val = elt
    if size ~= 0 then
      val = val + acc[size]
    end
    table.insert(acc, val)
    return acc
  end
  return self:fold_left(Array{}, f)
end

function Array:equals(array)
  local equal_values = self:zip(array):fold_left(true, function(acc, e) return acc and (e[1] == e[2]) end)
  return getmetatable(array) == Array 
    and #self == #array
    and equal_values 
end

function Array:sum()
  local total = 0
  for _, value in ipairs(self) do
    total = total + value
  end
  return total
end