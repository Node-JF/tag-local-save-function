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

-- Optional function to define model if plugin supports more than one model
function GetModel(props)
    local model = {}
    --[[ #include "src/model.lua" ]]
    return model
end

-- Define User configurable Properties of the plugin
function GetProperties()
    local props = {}
    --[[ #include "src/properties.lua" ]]
    return props
end

-- Optional function to define pins on the plugin that are not connected to a Control
function GetPins(props)
    local pins = {}
    --[[ #include "src/pins.lua" ]]
    return pins
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
    --[[ #include "src/rectify_properties.lua" ]]
    return props
end

-- Optional function to define components used within the plugin
function GetComponents(props)
    local components = {}
    --[[ #include "src/components.lua" ]]
    return components
end

-- Optional function to define wiring of components used within the plugin
function GetWiring(props)
    local wiring = {}
    --[[ #include "src/wiring.lua" ]]
    return wiring
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
