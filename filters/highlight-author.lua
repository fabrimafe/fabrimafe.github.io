local name = "Mafessoni"

local function bold_name_in_inlines(inlines)
  local result = {}
  for _, inline in ipairs(inlines) do
    if inline.t == "Str" and inline.text:find(name, 1, true) then
      table.insert(result, pandoc.Strong({inline}))
    elseif inline.t == "Span" and inline.content then
      -- recurse into spans
      inline.content = bold_name_in_inlines(inline.content)
      table.insert(result, inline)
    else
      table.insert(result, inline)
    end
  end
  return result
end

function Div(div)
  if div.identifier:find("^ref%-") then
    return div:walk({
      Para = function(para)
        para.content = bold_name_in_inlines(para.content)
        return para
      end
    })
  end
end
