local INFPLUS, C, L, _ = unpack(select(2, ...))

-----------------------------
-- Default Config
-----------------------------
local defaultTexture	= [[Interface\ChatFrame\ChatFrameBackground]]
local defaultFont		= [[Interface\AddOns\ThreatClassic2\media\NotoSans-SemiCondensedBold.ttf]] or _G.STANDARD_TEXT_FONT

INFPLUS.defaultConfig = {}

-- general
INFPLUS.defaultConfig.general = {
    welcome				= true
}

-- frame settings
INFPLUS.defaultConfig.frame = {
    test				= false,								-- toggle for test mode
    scale				= 1,									-- global scale
    width				= 217,									-- frame width
    height				= 161,									-- frame height
    locked				= false,								-- toggle for movable
    strata				= "3-MEDIUM",							-- frame strata
    position			= {"LEFT", "UIParent", "LEFT", 50, 0},	-- frame position
    color				= {0, 0, 0, 0.35},						-- frame background color
    headerShow			= true,									-- show frame header
    headerColor			= {0, 0, 0, 0.8},						-- frame header color
}

-- backdrop settings
INFPLUS.defaultConfig.backdrop = {
    bgFile				= defaultTexture,						-- backdrop file location
    bgColor				= {1, 1, 1, 0.1},						-- backdrop color
    edgeFile			= defaultTexture,						-- backdrop edge file location
    edgeColor			= {0, 0, 0, 1},							-- backdrop edge color
    tile				= false,								-- backdrop texture tiling
    tileSize			= 0,									-- backdrop tile size
    edgeSize			= 1,									-- backdrop edge size
    inset				= 0,									-- backdrop inset value
}

-- font settings
INFPLUS.defaultConfig.font = {
    family				= defaultFont,							-- font file location
    size				= 12,									-- font size
    style				= "OUTLINE",							-- font style
    color				= {1, 1, 1, 1},							-- font color
    shadow				= true,									-- font dropshadow
}

