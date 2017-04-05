local codeDesignationKeywords = require("code designations")

CSP = {}

function CSP.ParseSheetText(sheetText)
  local leftMostIndex = 0
  local untouchedSheetText = sheetText
  for i = 1,6 do print("") end
  local function GetPartnerBracket(ix)
    local Count = 1
    while(true) do
      ix = ix + 1
      if string.sub(sheetText,ix,ix+1) == "(" then
        Count = Count + 1
      end
      if string.sub(sheetText,ix,ix) == ")" then
        Count = Count - 1
        if Count == 0 then
          return ix
        end
      end
    end
  end
  
  local function ContainsKeyword(strIn)
    for k,v in pairs(codeDesignationKeywords) do
      if string.find(strIn,k) then
        return true
      end
    end
    return false
  end
  
  local function GetHighestScopeKeywordIn(strIn)
    local scopes = {}
    local pair = {}
    local scope = 0
    local index = 0
    local openB = 0
    local closeB = 0
    while index <= #strIn do
      if string.sub(strIn,index,index) == "(" then
        scope = scope + 1
        openB = index
      end
      if string.sub(strIn,index,index) == ")" then
        closeB = index
        table.insert(scopes,{open=openB,close=closeB,scope=scope})
        scope = scope-1
      end
      index = index + 1
    end
    table.sort(scopes,function (a,b) if a.scope == b.scope then return a.close > b.close else return a.scope > b.scope end end)
    local index = scopes[1].open-1
    local ends = index
    local buffer = ""
    while true do
      local char = string.sub(strIn,index,index)
      if char ~= " " then
        if char ~= "(" then
          buffer = char .. buffer
        else
          if codeDesignationKeywords[buffer] then
            break
          end
        end
      else
        buffer = ""
      end
      if index == 1 then index = index - 1 ; break end
      index = index - 1
    end
    return scopes[1].open,scopes[1].close,buffer,index+1,ends
  end
  local var_start = true
  while(ContainsKeyword(sheetText) == true) do
    local var_start,var_end,Keyword,k_start,k_end = GetHighestScopeKeywordIn(sheetText)
    --now we convert to lua code :
    local segmentLua = CSP.ParseCodeSheetSegment(string.sub(sheetText,k_start,var_end),codeDesignationKeywords[Keyword])
    
    sheetText = string.sub(sheetText,0,k_start-1,var_end+1) .. segmentLua .. string.sub(sheetText,var_end+1,#sheetText)
  end
  return sheetText
end

function CSP.ParseCodeSheetSegment(segment,keyword)
  --parses a segment into lua code using the supplied keyword
  local luaCode = keyword.lua
  local varCount = 0
  local numVars = #keyword.variables
  local index = 0
  repeat
    local index_opening = string.find(segment,"(",index,true)
    local index_closing = string.find(segment,")",index,true)
    local varstart,varend = string.find(luaCode,"variable" .. tostring(varCount + 1))
    local replacementString = string.sub(segment,index_opening+1,index_closing-1)
    if type(keyword.variables[varCount+1]) == "table" then
      replacementString = keyword.variables[varCount+1][replacementString]
    end
    luaCode = string.sub(luaCode,0,varstart-1) .. replacementString .. string.sub(luaCode,varend+1,#luaCode)
    varCount = varCount + 1
    index = index_closing + 1
  until(varCount == numVars)
  return luaCode
end



