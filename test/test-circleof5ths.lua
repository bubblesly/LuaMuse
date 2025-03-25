require('../scale')
require('../note')
require('../mode')
luaunit = require('luaunit')

TestCircleOf5ths = {}

function TestCircleOf5ths:setUp()
end

function TestCircleOf5ths:tearDown()
end

function TestCircleOf5ths:test_totheleft()
    local c_major = Scale.c_major()
    local next = c_major:to_the_left_on_circle_of_5ths(1)
    -- print(next:tostring())
    for i=1,11 do
        print(i+1)
        next = next:to_the_left_on_circle_of_5ths(1)
        -- print(next:tostring())
    end
    luaunit.assertEquals(next, Scale.c_major())
end

function TestCircleOf5ths:test_totheright()
    local c_major = Scale.c_major()
    local next = c_major:to_the_right_on_circle_of_5ths(1)
    -- print(next:tostring())
    for i=1,11 do
        print(i+1)
        next = next:to_the_right_on_circle_of_5ths(1)
        -- print(next:tostring())
    end
    luaunit.assertEquals(next, Scale.c_major())
end
