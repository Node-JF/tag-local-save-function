local graphics, layout, control_slots = {}, {}, {}

local page_index = props["page_index"].Value

-- starting depth
local total_depth = 0

-- dynamically create graphics boxes
for i, grouping in ipairs(Master_Object[page_index].Groupings) do

    total_depth = total_depth + control_depth

    depth = grouping.Depth

    len = string.len(grouping.Name)

    table.insert(graphics, {
        Type = "GroupBox",
        Fill = Colors.primary,
        StrokeColor = Colors.stroke,
        StrokeWidth = 2,
        CornerRadius = 8,
        HTextAlign = "Left",
        Position = {
            0,
            total_depth
        },
        Size = {
            width,
            40 + (depth * control_depth) + ((depth - 1) * control_gap)
        }
    })

    -- generate control slots per group box depth and control_depth requirement

    grouping["Control_Slots"] = {}

    for n = 1, grouping.Depth do

        grouping["Control_Slots"][n] = ((total_depth + 25) + (control_depth * (n - 1)) + ((n - 1) * control_gap))

    end

    -- dynamically create groupbox labels
    table.insert(graphics, {
        Type = "Label",
        Text = Master_Object[page_index].Groupings[i].Name,
        -- Size = 11,
        Color = {
            255,
            255,
            255
        },
        Fill = Colors.heading,
        StrokeWidth = 0,
        CornerRadius = 4,
        Position = {
            15,
            total_depth - 8
        },
        Size = {
            len <= 12 and 90 or len <= 20 and 140 or len <= 30 and 170,
            18
        },
        Font = "Montserrat",
        FontStyle = "Medium"
    })

    total_depth = total_depth + 40 + ((depth * control_depth) + ((depth - 1) * control_gap))

end

-- width of the group box minus borders
local box_width = (width - 60)

for i, grouping in ipairs(Master_Object[page_index].Groupings) do

    local Slots = grouping.Control_Slots

    for _, ctl in ipairs(grouping.Controls) do

        local pos_x = nil
        local pos_y = nil

        if (ctl.Width and (ctl.Width == "Full")) then
            pos_x = 15
            pos_y = (Slots[ctl.GridPos] + control_depth + control_gap)
        else
            if (ctl.Position) then
                pos_x = ctl.Position
            else
                pos_x = (width - 15) - ctl.Size[1]
            end
            pos_y = Slots[ctl.GridPos]
        end

        layout[ctl.Name] = {
            PrettyName = ctl.PrettyName,
            Legend = ctl.Legend,
            Style = ctl.Style,
            Position = {
                pos_x,
                pos_y
            },
            Size = ctl.Size,
            Font = "Droid Sans",
            FontSize = 8
        }

        if ctl.Label then
            table.insert(graphics, {
                Type = "Label",
                Text = ctl.Label,
                HTextAlign = "Left",
                Color = Colors.label,
                Font = "Droid Sans",
                Position = {
                    15,
                    (Slots[ctl.GridPos] ~= nil) and Slots[ctl.GridPos] or Slots[#Slots]
                },
                Size = {
                    (ctl.Width == "Full") and (width - 30) or (width - 30) - ctl.Size[1],
                    control_depth
                }
            })
        end

    end

end
