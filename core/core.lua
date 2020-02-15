local INFPLUS, C, L, _ = unpack(select(2, ...))

-----------------------------
-- VARIABLES
-----------------------------
-- upvalues
local _G		= _G
local select	= _G.select
local unpack	= _G.unpack
local tonumber	= _G.tonumber
local type		= _G.type
local floor		= _G.math.floor
local strbyte	= _G.string.byte
local format	= _G.string.format
local strlen	= _G.string.len
local strsub	= _G.string.sub

local ipairs	= _G.ipairs
local pairs		= _G.pairs
local tinsert	= _G.table.insert
local tremove	= _G.table.remove
local sort		= _G.table.sort
local wipe		= _G.table.wipe