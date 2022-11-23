MODULE = {}
doesFileExists = function(path)
    local F = io.open(path, 'r')
    if F ~= nil then F:close() end
    return F ~= nil
end

MODULE.__read = function(file)
    local Result, CurretSection = {}, 'NONE'
    for line in io.lines(file) do
        if line:match('%[(.+)%]') then
            CurretSection = line:match('%[(.+)%]')
            Result[CurretSection] = {}
        elseif line:match('(.+)=(.+)') then
            local key, value = line:match('(.+)=(.+)')
            if value == 'true' or value == 'false' then
                Result[CurretSection][key] = value == 'true' and true or false 
            else
                Result[CurretSection][key] = value:match('(%d+)') and tonumber(value) or value
            end
        end
    end
    return Result
end

MODULE.__save = function(file, t)
    local fileT = {}
    for section, items in pairs(t) do
        table.insert(fileT, '['..section..']')
        for key, value in pairs(items) do
            assert(type(value) ~= 'table', 'you can\'t save table in key, but you can save json encoded table')
            table.insert(fileT, key..'='..tostring(value))
        end
    end
    local F = io.open(file, 'w')
    F:write(table.concat(fileT, '\n'))
    F:close()
end


MODULE.Load = function(file, default)
    if not doesFileExists(file) then
        MODULE.Save(file, default)
    end
    local current = MODULE.__read(file)
    for section, items in pairs(default) do
        if current[section] == nil then
            current[section] = items
            MODULE.__save(file, current)
        end
    end

    return MODULE.__read(file)
end

MODULE.Save = function(file, t) 
    MODULE.__save(file, t) 
end

return MODULE