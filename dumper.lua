local dumper = {
    dumpVariable = {},
    blackList = {
        '["love"]["_modules"]["timer"]',
        '["love"]["_modules"]["event"]',
        '["love"]["_modules"]["window"]',
        '["love"]["event"]["pump"]',
        '["love"]["event"]["poll_i"]',
        '["love"]["joystick"]["loadGamepadMappings"]',
        '["love"]["timer"]["step"]',
        '["love"]["timer"]["sleep"]',
        '["love"]["graphics"]["present"]',
        '["love"]["graphics"]["newImageFont"]',
        '["love"]["graphics"]["origin"]',
        '["love"]["graphics"]["clear"]',
        '["love"]["graphics"]["rectangle"]',
        '["love"]["graphics"]["setColor"]',
        '["love"]["graphics"]["isActive"]',
        '["love"]["graphics"]["getBackgroundColor"]',
        '["love"]["handlers"]["gamepadreleased"]',
        '["love"]["handlers"]["focus"]',
        '["love"]["handlers"]["displayrotated"]',
        '["love"]["handlers"]["touchpressed"]',
        '["love"]["handlers"]["lowmemory"]',
        '["love"]["handlers"]["quit"]',
        '["love"]["handlers"]["textinput"]',
        '["love"]["handlers"]["wheelmoved"]',
        '["love"]["handlers"]["resize"]',
        '["love"]["handlers"]["directorydropped"]',
        '["love"]["handlers"]["touchreleased"]',
        '["love"]["handlers"]["joystickhat"]',
        '["love"]["handlers"]["joystickaxis"]',
        '["love"]["handlers"]["joystickpressed"]',
        '["love"]["handlers"]["threaderror"]',
        '["love"]["handlers"]["gamepadpressed"]',
        '["love"]["handlers"]["visible"]',
        '["love"]["handlers"]["joystickreleased"]',
        '["love"]["handlers"]["joystickremoved"]',
        '["love"]["handlers"]["gamepadaxis"]',
        '["love"]["handlers"]["textedited"]',
        '["love"]["handlers"]["mousefocus"]',
        '["love"]["handlers"]["filedropped"]',
        '["love"]["handlers"]["mousepressed"]',
        '["love"]["handlers"]["keyreleased"]',
        '["love"]["handlers"]["touchmoved"]',
        '["love"]["handlers"]["mousemoved"]',
        '["love"]["handlers"]["joystickadded"]',
        '["love"]["handlers"]["mousereleased"]',
        '["love"]["handlers"]["keypressed"]',
        '["serpent"]["dump"]',
    }
}

function dumper.deepCopy(var)
    local c = loadstring("return _G" .. var)
    setfenv(c, getfenv())
    local b = c()

    if type(b) == "table" then
        for k,v in pairs(b) do
            dumper.deepCopy(var .. '["' .. k .. '"]')
        end
    else
        table.insert(dumper.dumpVariable, var)
    end
end

function dumper.dumpVariables()
    for k,v in pairs(_G) do
        if k ~= "_G" and k ~= "package" and k ~= "dumper" then
            dumper.deepCopy('["' .. k .. '"]')
        end
    end
end

function dumper.dumpCurrentLuaStatus()
    dumper.dumpVariables()
    ___temp = serpent.dump(_G)
end

function dumper.isBlackListed(var)
    for k,v in pairs(dumper.blackList) do
        if v == var then
            return true
        end
    end
    return false
end

function dumper.loadDumpedLuaState()
    if ___temp then
        ___temp = loadstring(___temp)()

        for k,v in pairs(dumper.dumpVariable) do
            if not dumper.isBlackListed(v) then
                local a = loadstring("_G" .. v .. " = ___temp" .. v)
                setfenv(a, getfenv())
                a()
            end
        end

        _G["___temp"] = nil
        collectgarbage()
    end
end

return dumper