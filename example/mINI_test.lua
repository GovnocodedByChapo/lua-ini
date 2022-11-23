local ini = require('mINI')

local settings = ini.Load('X:\\Lua\\MyConfigFile.ini', {
    FirstSection = {
        varBool = true,
        varString = 'hello world',
        varNumber = 8
    }
})

function main()
    while true do
        local input = io.read("*l")
        if input == 'ini.save' then
            ini.Save('X:\\Lua\\MyConfigFile.ini', settings)
            print('Ini saved!')
        elseif input == 'ini.print' then
            print('Ini:')
            for section, items in pairs(settings) do
                for key, value in pairs(items) do
                    print(section, '->', key, '=', value)
                end
            end
        else
            if input:find('ini.set (.+) (.+) (.+)') then
                local section, key, value = input:match('ini.add (.+) (.+) (.+)')
                if settings[section] == nil then
                    settings[section] = {}
                end
                settings[section][key] = value
                print('Added, use ini.save to save config')
            elseif input:find('ini.get (.+) (.+)') then
                local section, key = input:match('ini.get (.+) (.+)')
                if settings[section] then
                    if settings[section][key] then
                        print(section..'->'..key..' = ', settings[section][key])
                    else
                        print('Key "'..key..'" not found in section "'..section..'"!')
                    end
                else
                    print('Section "'..section..'" not found!')
                end
            end
        end
    end
end
main()
