require('../array')
luaunit = require('luaunit')

TestArray = {}

function TestArray:setUp()
end

function TestArray:tearDown()
end

function TestArray:testMap()
  local a = Array{1, 2, 3, 4}
  local f = function(elt) return elt + 1 end
  luaunit.assertEquals(a:map(f), {2, 3, 4, 5})
end

function TestArray:testZip()
  local a = Array{1, 2, 3, 4}
  local b = Array{2, 3, 4, 5}
  luaunit.assertEquals(a:zip(b), {{1, 2}, {2, 3}, {3, 4}, {4, 5}})
end

function TestArray:testAddToValues()
  local a = Array{1, 2, 3, 4}
  luaunit.assertEquals(a:add_to_values(1), {2, 3, 4, 5})
end

function TestArray:testRotateValues()
  local a = Array{1, 2, 3, 4}
  luaunit.assertEquals(a:rotate_values(0), {1, 2, 3, 4})
  luaunit.assertEquals(a:rotate_values(1), {2, 3, 4, 1})
  luaunit.assertEquals(a:rotate_values(2), {3, 4, 1, 2})
  luaunit.assertEquals(a:rotate_values(3), {4, 1, 2, 3})
  luaunit.assertEquals(a:rotate_values(4), {1, 2, 3, 4})
end

function TestArray:testDiffValues()
  local a = Array{1, 2, 3, 4}
  local b = Array{4, 3, 2, 1}
  luaunit.assertEquals(a:diff_values(b), {-3, -1, 1, 3})
end

function TestArray:testFoldLeft()
  local a = Array{1, 2, 3, 4}
  luaunit.assertEquals(a:fold_left(0, function(acc, e) return acc + e end), 10)
end

function TestArray:testFoldLeft2()
  local a = Array{1, 2, 3, 4}
  local f = function(acc, e) return acc + e end
  luaunit.assertEquals(a:fold_left(0, f), 10)
end

function TestArray:testAccTableValues()
  local a = Array{1, 2, 3, 4}
  luaunit.assertEquals(a:acc_table_values(), {1, 3, 6, 10})
end
