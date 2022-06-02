width = 250 -- scalable plugin width
control_depth = 16 -- scalable control depth
control_gap = 3 -- vertical space between controls

Colors = {
    none = {0, 0, 0, 0},
    primary = {212, 202, 226},
    secondary = {51, 51, 51},
    heading = {50, 50, 50},
    label = {50, 50, 50},
    stroke = {51, 51, 51},
    black = {51, 51, 51}
}

Sizes = {
    ["Button"] = {36, control_depth},
    ["Text"] = {(width - 30) / 2, control_depth},
    ["Status"] = {width - 30, (control_depth * 2) + (control_gap * 1)},
    ["LED"] = {16, control_depth},
    ["ListBox"] = {width - 30, (control_depth * 10) + (control_gap * 9)},
    ["Image"] = {width - 30, (control_depth * 6) + (control_gap * 5)}
}

Master_Object = {{

    ["PageName"] = "Dashboard",

    ["Groupings"] = {{
        ["Name"] = "Sync/Save",
        ["Depth"] = 3,
        ["Controls"] = {{
            Name = "config_filename",
            PrettyName = "Configuration~Filename",
            Label = "Filename",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = "config_sync",
            PrettyName = "Configuration~Sync",
            ControlType = "Button",
            ButtonType = "Trigger",
            Legend = "Sync",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            Position = (width - 15) - Sizes.Button[1] - Sizes.Text[1],
            GridPos = 2
        }, {
            Name = "status_sync",
            PrettyName = "Configuration~Status~Sync",
            Label = "Sync",
            ControlType = "Indicator",
            IndicatorType = "Status",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 2
        }, {
            Name = "config_save",
            PrettyName = "Configuration~Save",
            ControlType = "Button",
            ButtonType = "Trigger",
            Legend = "Save",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            Position = (width - 15) - Sizes.Button[1] - Sizes.Text[1],
            GridPos = 3
        }, {
            Name = "status_save",
            PrettyName = "Configuration~Status~Save",
            Label = "Save",
            ControlType = "Indicator",
            IndicatorType = "Status",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 3
        },
    }

    }, {
        ["Name"] = "Components",
        ["Depth"] = 14,
        ["Controls"] = {{
            Name = "components_filter",
            PrettyName = "Select Components~Filter",
            Label = "Filter",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = "components_selectall",
            PrettyName = "Select Components~Select All",
            Label = "Select All",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 2
        }, {
            Name = "components_deselectall",
            PrettyName = "Select Components~Deselect All",
            Label = "Deselect All",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 3
        }, {
            Name = "components_list",
            PrettyName = "Select Components~List",
            Label = "Components",
            ControlType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Style = "ListBox",
            Width = "Full",
            Size = Sizes.ListBox,
            GridPos = 4
        }}
    }, {
        ["Name"] = "Controls",
        ["Depth"] = 13,
        ["Controls"] = {{
            Name = "controls_selectall",
            PrettyName = "Select Controls~Select All",
            Label = "Select All",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 1
        }, {
            Name = "controls_deselectall",
            PrettyName = "Select Controls~Deselect All",
            Label = "Deselect All",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 2
        }, {
            Name = "controls_list",
            PrettyName = "Select Controls~List",
            Label = "Controls",
            ControlType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Style = "ListBox",
            Width = "Full",
            Size = Sizes.ListBox,
            GridPos = 3
        }}
    }, {
        ["Name"] = "Errors",
        ["Depth"] = 11,
        ["Controls"] = {{
            Name = "errors_list",
            PrettyName = "Error List",
            Label = "Errors",
            ControlType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Style = "ListBox",
            Width = "Full",
            Size = Sizes.ListBox,
            GridPos = 1
        }}
    }}
}}
