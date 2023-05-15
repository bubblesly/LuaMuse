local lu = require('luaunit')

require('test/test_array')
require('test/test_degree')
require('test/test_mode')
require('test/test_note')
require('test/test_scale')

os.exit( lu.LuaUnit.run() )