--
--  Good Standing
-- ===============
--  By: Jadzia626
--
--  Core File
--

local self = LibStub("AceAddon-3.0"):NewAddon("Good Standing","AceEvent-3.0","AceConsole-3.0");

-- Runtime Variables
local isScanning = false;
local allFactions = {};

-- Faction Colours
local factionColBlizz = {
	[1] = {r = 0.80, g = 0.30, b = 0.22},
	[2] = {r = 0.80, g = 0.30, b = 0.22},
	[3] = {r = 0.75, g = 0.27, b = 0.00},
	[4] = {r = 0.90, g = 0.70, b = 0.00},
	[5] = {r = 0.00, g = 0.60, b = 0.10},
	[6] = {r = 0.00, g = 0.60, b = 0.10},
	[7] = {r = 0.00, g = 0.60, b = 0.10},
	[8] = {r = 0.00, g = 0.60, b = 0.10},
};
local factionColGS = {
	[1] = {r = 0.80, g = 0.30, b = 0.22}, -- Hated
	[2] = {r = 0.80, g = 0.30, b = 0.22}, -- Hostile
	[3] = {r = 0.75, g = 0.27, b = 0.00}, -- Unfriendly
	[4] = {r = 0.90, g = 0.70, b = 0.00}, -- Neutral
	[5] = {r = 0.08, g = 0.70, b = 0.00}, -- Friendly    Common Colour
	[6] = {r = 0.41, g = 0.80, b = 0.94}, -- Honored     Mage Colour
	[7] = {r = 0.00, g = 0.44, b = 0.87}, -- Revered     Shaman Colour
	[8] = {r = 0.78, g = 0.27, b = 0.98}, -- Exalted     Epic Colour
};

function rgbToCol(rgb)
    return ("%02x%02x%02x"):format(floor(rgb.r*255), floor(rgb.g*255), floor(rgb.b*255));
end

function textColor(text, color)
    return ("|cff%s%s|r"):format(color, text);
end

-- Values
local standingName = {
    FACTION_STANDING_LABEL1, -- Hated
    FACTION_STANDING_LABEL2, -- Hostile
    FACTION_STANDING_LABEL3, -- Unfriendly
    FACTION_STANDING_LABEL4, -- Neutral
    FACTION_STANDING_LABEL5, -- Friendly
    FACTION_STANDING_LABEL6, -- Honored
    FACTION_STANDING_LABEL7, -- Revered
    FACTION_STANDING_LABEL8, -- Exalted
};
local standingColor = {
    [1] = rgbToCol(factionColGS[1]),
    [2] = rgbToCol(factionColGS[2]),
    [3] = rgbToCol(factionColGS[3]),
    [4] = rgbToCol(factionColGS[4]),
    [5] = rgbToCol(factionColGS[5]),
    [6] = rgbToCol(factionColGS[6]),
    [7] = rgbToCol(factionColGS[7]),
    [8] = rgbToCol(factionColGS[8]),
};
local gsColors = {
    ["faction"] = "fff569",
    ["pos"]     = "40ff40",
    ["neg"]     = "c41f3b",
    ["message"] = "aaaaff",
}

--
-- Addon Init
--

function self:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
end

function self:OnEnable()
    self:RegisterEvent("UPDATE_FACTION","GS_OnEvent");
    --self:RegisterEvent("QUEST_LOG_UPDATE","GS_OnEvent");
    self:RegisterEvent("LFG_BONUS_FACTION_ID_UPDATED","GS_OnEvent");
end

function self:OnDisable()
    self:UnregisterEvent("UPDATE_FACTION","GS_OnEvent");
    --self:UnregisterEvent("QUEST_LOG_UPDATE","GS_OnEvent");
    self:UnregisterEvent("LFG_BONUS_FACTION_ID_UPDATED","GS_OnEvent");
end

--
--  Data Functions
-- ****************
--

function self:ScanFactions()

    -- Check if a scan is already running
    if (isScanning) then return end;
    isScanning = true;

    --print("GS: Faction scan started");

    local numFactions = GetNumFactions();
    --print("GS: Count:",numFactions);
    for factionIdx = 1, numFactions do
        local name, description, standingID, barMin, barMax, barValue, atWarWith, _, isHeader,
              isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIdx);

        if (allFactions[factionID] == nil) then
            local newFaction = {
                ["name"]       = name,
                ["repValue"]   = barValue,
                ["repInitial"] = barValue,
            };
            if (factionID ~= nil) then
                allFactions[factionID] = newFaction;
            end
        else
            repChange  = barValue - allFactions[factionID].repValue;
            sessionInc = barValue - allFactions[factionID].repInitial;
            allFactions[factionID].repValue = barValue;
            if (repChange ~= 0) then
                local facStanding = textColor(standingName[standingID],standingColor[standingID]);
                local facName     = textColor(name,gsColors.faction);
                local facProgress = ("%d/%d"):format(barValue-barMin,barMax-barMin);
                local facSession  = "(0)";
                if (sessionInc > 0) then
                    facSession = textColor(("(+%d)"):format(sessionInc),gsColors.pos);
                end
                if (sessionInc < 0) then
                    facSession = textColor(("(%d)"):format(sessionInc),gsColors.neg);
                end
                print(facName, facStanding, facProgress, facSession);
            end
        end

        --print("GS: Faction:",name,factionID)
    end

    --print("GS: Faction scan completed");

    isScanning = false;

end

--
--  Event Handlers
-- ****************
--

do
    function self:GS_OnEvent(event)
        print(textColor("GS Faction Update",gsColors.message));
        self:ScanFactions();
    end
end
