for i, page in ipairs(Master_Object) do
  for i, grouping in ipairs(page.Groupings) do
      for i, control in ipairs(grouping.Controls) do
          table.insert(ctls, control)
      end
  end
end