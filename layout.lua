local CurrentPage = PageNames[props["page_index"].Value]
if CurrentPage == "Control" then
  table.insert(graphics,{
    Type = "GroupBox",
    Text = "Control",
    Fill = {200,200,200},
    StrokeWidth = 1,
    Position = {5,5},
    Size = {200,100}
  })
  table.insert(graphics,{
    Type = "Text",
    Text = "Say Hello:",
    Position = {10,42},
    Size = {90,16},
    FontSize = 14,
    HTextAlign = "Right"
  })
  layout["SendButton"] = {
    PrettyName = "Buttons~Send The Command",
    Style = "Button",
    Position = {105,42},
    Size = {50,16},
    Color = {0,0,0}
  }
elseif CurrentPage == "Setup" then
  -- TBD
end