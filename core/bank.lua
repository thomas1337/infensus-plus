INFBANK = LibStub("AceAddon-3.0"):NewAddon("InfensusBank", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
-- CHAT COMMANDS
local options = {
    name = 'InfensusBank',
    type = 'group',
    args = {
        export = {
            type = 'execute',
            name = 'Bank export',
            desc = 'Bank export',
            func = function() doScan() end
        }
    }
}
LibStub("AceConfig-3.0"):RegisterOptionsTable("InfensusBank", options, {"infbank", "bank"})


-- Container helper function
function getSlotInfo(bag, slot)
    local item = {
        itemCount,
        id
    };
    local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bag, slot);
    item.itemCount = itemCount;
    item.id = GetContainerItemID(bag, slot);
    item.link = itemLink;
    item.quality = quality;
    return item;
end

-- Inventory representation
function getInventoryBagsSlots()
    local bags = {};
    for i = 0, 4 do
        bags[i] = { slotsCount = GetContainerNumSlots(i), items = {} };
    end
    return bags;
end

function mapBagsSlots()
    local bags = getInventoryBagsSlots();
    for i = 0, 4 do
        for k = 1, bags[i].slotsCount do
            bags[i].items[k] = getSlotInfo(i, k);
        end
    end
    return bags;
end

-- Bank Representation
function getBankSlots()
    local bank = {};
    bank["1"] = { slotsCount = GetContainerNumSlots(-1), items = {} };
    for i = 5, 10 do
        bank[i] = { slotsCount = GetContainerNumSlots(i), items = {} };
    end
    return bank;
end

function mapBankSlots()
    local bank = getBankSlots();
    for i = 1, 24 do
        bank["1"].items[i] = getSlotInfo(-1, i);
    end
    for i = 5, 10 do
        for k = 1, bank[i].slotsCount do
            bank[i].items[k] = getSlotInfo(i, k);
        end
    end
    return bank;
end
-- XML conversion, GUI
function toggleXML(text)
    if not KethoEditBox then
        local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(400, 150)

        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue

        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)

        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)

        -- EditBox
        local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)

        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)

        local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)

        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end

    if text then
        KethoEditBoxEditBox:SetText(text)
    end
    KethoEditBox:Show()
end

function doScan()
    local bags = mapBagsSlots();
    local bank = mapBankSlots();
    local result = "<character><bags>";

    for i = 0, 4 do
        if (bags[i].slotsCount == nil) then
            bags[i].slotsCount = 0;
        end
        for k = 1, bags[i].slotsCount do
            local count = bags[i].items[k].itemCount;
            local id = bags[i].items[k].id;
            local link = bags[i].items[k].link;
            local quality = bags[i].items[k].quality;

            if ((count == nil) or (id == nil)) then
                result = result .. '<item count="" id=""/>';
            else
                result = result .. '<item count="' .. count .. '" id="' .. id .. '" link="' .. link .. '" quality="' .. quality .. '"/>';
            end
        end
    end
    result = result .. "</bags><bank>";
    for i = 1, 24 do
        local count = bank["1"].items[i].itemCount;
        local id = bank["1"].items[i].id;
        local link = bank["1"].items[i].link;
        local quality = bank["1"].items[i].quality;

        if (count == nil or id == nil) then
            result = result .. '<item count="" id=""/>';
        else
            result = result .. '<item count="' .. count .. '" id="' .. id .. '" link="' .. link .. '" quality="' .. quality .. '"/>';
        end
    end

    for i = 5, 10 do
        if (bank[i].slotsCount == nil) then
            bank[i].slotsCount = 0;
        end
        for k = 1, bank[i].slotsCount do
            local count = bank[i].items[k].itemCount;
            local id = bank[i].items[k].id;
            local link = bank[i].items[k].link;
            local quality = bank[i].items[k].quality;

            if (count == nil or id == nil) then
                result = result .. '<item count="" id=""/>';
            else
                result = result .. '<item count="' .. count .. '" id="' .. id .. '" link="' .. link .. '" quality="' .. quality .. '"/>';
            end
        end
    end
    result = result .. "</bank>";

    result = result .. "</character>";
    toggleXML(result);
end

