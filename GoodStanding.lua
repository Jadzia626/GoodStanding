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

    print("GS: Faction scan started");

    local numFactions = GetNumFactions();
    print("GS: Count:",numFactions);
    for factionIdx = 1, numFactions do
        local name, description, standingID, barMin, barMax, barValue, atWarWith, _, isHeader,
              isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIdx);
        --print("GS: Faction:",name,factionID)
    end

    print("GS: Faction scan completed");

    isScanning = false;

end

--
--  Event Handlers
-- ****************
--

do
    function self:GS_OnEvent(event)
        print("GS Event: ",event);
        self:ScanFactions();
    end
end
