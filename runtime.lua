directory = "media/PageArchives/Configuration Files"

-- and utf8.char(1068sync"7) or utf8.char(9675)

function SetStatus(code, message, name)

    Controls[string.format("status.%s", name)].Value = code
    Controls[string.format("status.%s", name)].String = message

end; SetStatus(0, "", "sync"); SetStatus(0, "", "save")

function GetFilename()

    local name = Controls["config.filename"].String
    if not name:match("%w+") then name = "default-config" end
    
    return string.format("%s/%s.json", directory, name)
end

function GetComponents()
    
    ResetControlsList()
    ComponentList = {}
    Components = Component.GetComponents()
    
    for i, component in ipairs(Components) do
       
       if component.Name:find(Controls['components.filter'].String) then
        
        table.insert(ComponentList, {
            Text = component.Name,
            Icon = utf8.char(9675),
        })
        
        end
        
        
    end
    
    Controls["components.list"].Choices = ComponentList
    
    Sync()
end

function ComponentIsValid(component)

    for i, choice in ipairs(ComponentList) do
    
        if (choice.Text == component) then; return true; end
    
    end
    
    return false
end

function ResetControlsList()
    Controls["controls.list"].Choices = {}
    Controls["controls.list"].String = ""
end

function Sync()
    
    -- check for directory
    if (not dir.get(directory)) then SetStatus(1, "Directory Doesn't Exist", "sync") return print("Could not Sync - Directory Does not Exist") end
    
    local filename = GetFilename()
    local file = io.open( filename, "r+" )
    
    -- check for file
    if (not file) then SetStatus(1, "File Doesn't Exist", "sync") return print("Could not Sync - File Does not Exist") end
    
    -- fetch file data
    local data = file:read("*a")
    file:close()
    
    data = rapidjson.decode(data)
    
    UpdateList(data)
    
    -- update the list box
    Controls["components.list"].Choices = ComponentList
    
end

function UpdateList(data)
    
    -- reset the string, so there's no weird interactions with the list box
    Controls["components.list"].String = ""
    
    -- reset the selections
    for i, choice in ipairs(ComponentList) do
        --ComponentList[i].Selected = false
        ComponentList[i].Color = nil
    end
    
    local Errors = {}
    
    local function PushValues(component, props)
        Component.New(component)[props.Control].String = props.String
    end
    
    -- error check that the JSON data is valid
    if (not data) then
        
        SetStatus(2, "Invalid JSON Data", "sync")
        print("Invalid JSON")     
        table.insert(Errors, {Color = "Red", Text = "Invalid JSON - Check Formatting"})
        Controls["errors.list"].Choices = Errors
        return
        
    end
    
    SetStatus(0, "Sync Successful", "sync")
    
    -- iterate through the components in the JSON data
    for component, json_tbl in pairs(data) do
        
        -- error check that the component exists in the design file
        if ComponentIsValid(component) then
        
            -- update the component control values in the design from the file
            for i, props in pairs(json_tbl) do
                
                result, err = pcall(PushValues, component, props)
                
                -- error check that the control update was successful
                if err then
                    
                    -- filter the error
                    if err:match("Control is read%-only") then
                        msg = "is a read-only control"
                    else
                        msg = "does not exist"
                        SetStatus(1, "Errors Found", "sync")
                        print(string.format("Invalid Control '%s' for Component '%s'", props.Control, component))
                    end
                    
                    table.insert(Errors, {
                        Color = err:match("Control is read%-only") and "Green" or "Orange",
                        Text = string.format("'%s' %s on Component '%s'", props.Control, msg, component)
                    })
                    
                    for i, choice in ipairs(ComponentList) do
                        if (choice.Text == component) then ComponentList[i]["Color"] = err:match("Control is read%-only") and "" or "Orange" end
                    end
        
                end
            
            end
        
        -- report any components that were not found in the design file
        else
            
            SetStatus(1, "Errors Found", "sync")
            
            print(string.format("Missing Component: '%s'", component))
                    
            table.insert(Errors, {Color = "Red", Text = string.format("Missing Component: '%s'", component)})
        
        end
        
        -- check the components list for the incoming component
        for i, choice in ipairs(ComponentList) do
            
            if (choice.Text == component) then
            
                --ComponentList[i].Selected = true
                
            end
            
            -- update the icon for this component to reflect it's 'selected' state
            ComponentList[i].Icon = ComponentList[i].Selected and utf8.char(10687) or utf8.char(9675)
        end
        
    end
    
    --print(rapidjson.encode(ComponentList, {pretty = true}))
    
    Controls["errors.list"].Choices = Errors
    Controls["errors.list"].String = ""

end

function GetControlsOnComponent(component, i, options)
    
    ComponentList[i].Controls = {}
    
    local controls = Component.GetControls(Component.New(component))
    
    for _, control in ipairs(controls) do
      
        if (control.Direction ~= "Read Only") then
            table.insert(ComponentList[i].Controls, {
                Text = control.Name,
                Selected = (options and options.selectAll),
                Icon = utf8.char(9675),
                ParentComponent = component,
                String = control.String
            })
        end
      
    end
    
    if (not options) then
      Controls["controls.list"].Choices = ComponentList[i].Controls
      
      Controls["controls.list"].String = ""
    end
    
end

function Save()
    
    -- create directory
    if (not dir.get(directory)) then
        dir.create(directory)
        print( string.format("Creating Directory: %s", directory) )
    end
    
    local Data = {}
    
    for i, choice in pairs(ComponentList) do
        
        Data = AddSelectedControls(i, choice, Data)
    
    end
    
    local filename = GetFilename()
    file = io.open(filename, "w+" )
    
    if (not Data) then Data = {} end
    
    if (not file) then SetStatus(1, "File Doesn't Exist", "save") return print("File Doesn't Exist - Can't Save") end
    
    print(string.format("Saving Configuration:\n\n%s", rapidjson.encode(Data, {pretty = true})))
    
    file:write(rapidjson.encode(Data, {pretty = true}))
    file:close()
    
    SetStatus(0, "Save Successful", "save")
    
end

function AddSelectedControls(i, choice, tbl)
    
    -- if component isn't selected, return here before doing anything
    if (not choice.Selected) then return tbl end
    
    -- create the entry with this component as the key, but don't overwrite it if it exists
    if (not tbl[choice.Text]) then tbl[choice.Text] = {} end
    
    local ctrls = ComponentList[i].Controls
    
    -- error check to see if Controls have been selected on this component
    if (not ComponentList[i].Controls) then return print(string.format("[No Controls Selected for Component '%s']", choice.Text)) end
    
    for _, control in ipairs(ctrls) do
        if (control.Selected) then
            table.insert(tbl[choice.Text], {Control = control.Text, String = control.String})
        end
    end
    
    return tbl
end

function SelectAll(bool)
    
    for i, choice in ipairs(ComponentList) do
    
        ComponentList[i].Selected = bool
        ComponentList[i].Icon = ComponentList[i].Selected and utf8.char(10687) or utf8.char(9675)
        GetControlsOnComponent(choice.Text, i, {selectAll = bool})
    
    end
    
    Controls["components.list"].Choices = ComponentList
    ResetControlsList()
    
end

function SelectAllControlsOnly(bool)
    
    
    local this_control = rapidjson.decode(Controls["components.list"].String)
    
    local parent_component = this_control.Text
    
    for i, choice in ipairs(ComponentList) do
    
        if (parent_component == choice.Text) then
        
            for id, control in ipairs(choice.Controls) do
                
                ComponentList[i].Controls[id].Selected = bool
                ComponentList[i].Controls[id].Icon = ComponentList[i].Controls[id].Selected and utf8.char(10687) or utf8.char(9675)
                    
            end
            
            Controls["controls.list"].Choices = ComponentList[i].Controls
            
        end
    
    end
    
    --Controls["controls.list"].String = ""
    
end

Controls["config.filename"].EventHandler = SetFilename
Controls["config.save"].EventHandler = Save
Controls["config.sync"].EventHandler = Sync

Controls["components.list"].EventHandler = function(c)

    local component = rapidjson.decode(c.String).Text
    
    for i, choice in ipairs(ComponentList) do
    
        if (component == choice.Text) then
            ComponentList[i].Selected = (not ComponentList[i].Selected)
            ComponentList[i].Icon = ComponentList[i].Selected and utf8.char(10687) or utf8.char(9675)
            if (ComponentList[i].Selected) then GetControlsOnComponent(component, i) else ResetControlsList() end
        end
    
    end
    
    Controls["components.list"].Choices = ComponentList
    
    --Controls["components.list"].String = ""
    
end

Controls["components.selectall"].EventHandler = function() SelectAll(true) end
Controls['components.deselectall'].EventHandler = function() SelectAll(false) end
Controls['controls.selectall'].EventHandler = function() SelectAllControlsOnly(true) end
Controls['controls.deselectall'].EventHandler = function() SelectAllControlsOnly(false) end

Controls["controls.list"].EventHandler = function(c)
    
    local this_control = rapidjson.decode(c.String)
    
    local parent_component = this_control.ParentComponent
    
    for i, choice in ipairs(ComponentList) do
    
        if (parent_component == choice.Text) then
        
            for id, control in ipairs(choice.Controls) do
                if (control.Text == this_control.Text) then
                    
                    ComponentList[i].Controls[id].Selected = (not ComponentList[i].Controls[id].Selected)
                    ComponentList[i].Controls[id].Icon = ComponentList[i].Controls[id].Selected and utf8.char(10687) or utf8.char(9675)
                    
                end
            end
            
            Controls["controls.list"].Choices = ComponentList[i].Controls
            
        end
    
    end
    --print(rapidjson.encode(ComponentList, {pretty = true}))
    --Controls["controls.list"].String = ""
    
end

Controls['components.filter'].EventHandler = GetComponents

GetComponents()