dependencies = {'libs/Dep2.lua', 'libs/Dep3.lua'}

test_echo1 = function ()
    print('### DEP 1')
    test_echo2()
    test_echo3()
    test_echo4()
end
