local IF = { 
  variables = {
    true,
    {EQUAL_TO = "==" , NOT_EQUAL_TO = "~=" , LESS_THAN = "<" , LESS_THAN_OR_EQUAL_TO = "<=" , GREATER_THAN = ">" , GREATER_THAN_OR_EQUAL_TO = ">="},
    true,
    true,
  },
  words = {
    "IF",
    "variable1",
    "variable2",
    "variable3",
    "variable4",
  },
  lua = "if variable1 variable2 variable3 then variable4 end"
}

local SETVAR = {
  variables = {
    "f_VARIABLES_ONLY",
    true,
  },
  words = {
    "SETVAR",
    "variable1",
    "TO",
    "variable2",
  },
  lua = "self.Variables:SetVar[variable1,variable2]"
}

local GETVAR = {
  variables = {
    "string",
  },
  words = {
    "GETVAR",
    "variable1",
  },
  lua="self.Variables:GetVar[variable1]"
}

local GET_CHUNKS = {
  variables = {
    "integer",
  },
  words = {
    "GET_CHUNKS",
    "variable1",
  },
  lua="GetNearestChunkToPosition[variable1]"
}

local GET_ITEM_IN_TBL = {
  variables = {
    "integer",
  },
  words = {
    "GET",
    "variable2",
    "nth ITEM IN",
    "variable1",
  },
  lua="variable1[[variable2]]"
}

local POSITION_OF = {
  variables = {
    {CELL = "self.Cell"},
  },
  words = {
    "GET_CHUNKS",
    "variable1",
  },
  lua="variable1:GetPosition[]"
}
--GetNearestChunkToPosition(position,filter)

return {
  IF =                    IF,
  SETVAR =                SETVAR,
  GETVAR =                GETVAR,
  GET_CHUNKS =            GET_CHUNKS,
  GET_ITEM_IN_TBL =       GET_ITEM_IN_TBL,
  POSITION_OF =           POSITION_OF,
}
