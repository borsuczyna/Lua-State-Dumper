# Lua-State-Dumper
Allows to dump all current variables and load previously dumped state. Designed for LÖVE

**Requires serpent https://github.com/pkulchenko/serpent**

# Examples

```lua
serpent = require("serpent")
dumper = require("dumper")

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 512, 512)
end

function love.keypressed(key)
    if key == "a" then
        dumper.dumpCurrentLuaStatus()
        love.draw = function()
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", 0, 0, 512, 512)
        end
    elseif key == "d" then
        dumper.loadDumpedLuaState()
    end
end
```
