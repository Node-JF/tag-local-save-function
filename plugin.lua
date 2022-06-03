-- Information block for the plugin
--[[ #include "src/info.lua" ]]

--[[ #include "src/gstore.lua" ]]

-- Define the color of the plugin object in the design
function GetColor(props)
    return Colors.primary
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
    return string.format("TAG Local Save Function [%s]", PluginInfo.Version)
end

-- Optional function used if plugin has multiple pages
function GetPages(props)
    local pages = {}
    --[[ #include "src/pages.lua" ]]
    return pages
end

-- Define User configurable Properties of the plugin
function GetProperties()
    local props = {}
    return props
end

-- Defines the Controls used within the plugin
function GetControls(props)
    local ctls = {}
    --[[ #include "src/controls.lua" ]]
    return ctls
end

-- Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
    --[[ #include "src/layout.lua" ]]
    return layout, graphics
end

-- Start event based logic
if Controls then

    rapidjson = require('rapidjson')

    --[[ #include "src/runtime.lua" ]]

end
