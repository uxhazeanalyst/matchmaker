-- Match Creator Addon - Clean Working Version
-- TOC: ## Interface: 100200
-- TOC: ## Title: Match Creator
-- TOC: ## Notes: Advanced dungeon group composition analyzer
-- TOC: ## Author: YourName
-- TOC: ## Version: 1.0.0

MatchCreator = {}

-- Initialize core data structures
function MatchCreator:Initialize()
    -- Core dungeon data (simplified for testing)
    self.dungeonData = {
        ["Mists of Tirna Scithe"] = {
            mechanics = {
                parry = 75,
                dodge = 60,
                magicDefense = 85,
                physicalDefense = 40,
                aoeReduction = 90,
                dispel = 80,
                interrupt = 70,
                mobility = 75,
                enrageRemoval = 0
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,
                    ["Death Knight_Blood"] = 85,
                    ["Paladin_Protection"] = 75
                },
                healer = {
                    ["Priest_Discipline"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Druid_Restoration"] = 80
                },
                dps = {
                    ["Hunter_Beast Mastery"] = 85,
                    ["Mage_Frost"] = 80,
                    ["Demon Hunter_Havoc"] = 90
                }
            }
        },
        ["The Necrotic Wake"] = {
            mechanics = {
                parry = 60,
                dodge = 55,
                magicDefense = 60,
                physicalDefense = 80,
                aoeReduction = 75,
                dispel = 90,
                interrupt = 85,
                mobility = 50,
                enrageRemoval = 0
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,
                    ["Death Knight_Blood"] = 95,
                    ["Paladin_Protection"] = 85
                },
                healer = {
                    ["Priest_Holy"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Paladin_Holy"] = 80
                },
                dps = {
                    ["Hunter_Beast Mastery"] = 85,
                    ["Mage_Fire"] = 80,
                    ["Death Knight_Unholy"] = 85
                }
            }
        }
    }
    
    print("|cFF00FF00Match Creator:|r Initialized successfully!")
end

-- Get current dungeon (placeholder)
function MatchCreator:GetCurrentDungeon()
    -- Try to get from instance info first
    local name = GetInstanceInfo()
    if name and self.dungeonData[name] then
        return name
    end
    
    -- Default for testing
    return "Mists of Tirna Scithe"
end

-- Get dungeon recommendations
function MatchCreator:GetDungeonRecommendations(dungeonName)
    local data = self.dungeonData[dungeonName]
    if not data then
        return nil
    end
    
    -- Generate summary of top 3 mechanics
    local summary = {}
    local sortedMechanics = {}
    
    for mechanic, value in pairs(data.mechanics) do
        if value > 0 then
            table.insert(sortedMechanics, {name = mechanic, value = value})
        end
    end
    
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    for i = 1, math.min(3, #sortedMechanics) do
        local mech = sortedMechanics[i]
        summary[mech.name] = mech.value
    end
    
    return {
        mechanics = data.mechanics,
        preferredSpecs = data.preferredSpecs,
        summary = summary
    }
end

-- Format mechanic names for display
function MatchCreator:FormatMechanicName(mechanic)
    local names = {
        parry = "Parry",
        dodge = "Dodge",
        magicDefense = "Magic Defense",
        physicalDefense = "Physical Defense",
        aoeReduction = "AoE Reduction",
        dispel = "Dispel",
        interrupt = "Interrupt",
        mobility = "Mobility",
        enrageRemoval = "Enrage Removal"
    }
    return names[mechanic] or mechanic
end

-- Create simple recommendation frame
function MatchCreator:ShowRecommendationFrame()
    -- Close existing frame
    if MatchCreatorFrame then
        MatchCreatorFrame:Hide()
        MatchCreatorFrame = nil
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "MatchCreatorFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(500, 400)
    frame:SetPoint("CENTER", 0, 0)
    
    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
    frame.title:SetText("Match Creator - Dungeon Recommendations")
    
    -- Make movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    -- Content area
    local content = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    content:SetPoint("TOPLEFT", frame.Inset, "TOPLEFT", 4, -4)
    content:SetPoint("BOTTOMRIGHT", frame.Inset, "BOTTOMRIGHT", -24, 4)
    
    local contentChild = CreateFrame("Frame", nil, content)
    contentChild:SetSize(460, 350)
    content:SetScrollChild(contentChild)
    
    -- Get recommendations
    local currentDungeon = self:GetCurrentDungeon()
    local recommendations = self:GetDungeonRecommendations(currentDungeon)
    
    if recommendations then
        self:PopulateRecommendations(contentChild, currentDungeon, recommendations)
    else
        local errorText = contentChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        errorText:SetPoint("CENTER", contentChild, "CENTER")
        errorText:SetText("No data available for current dungeon")
    end
    
    frame:Show()
end

-- Populate recommendations content
function MatchCreator:PopulateRecommendations(parent, dungeonName, recommendations)
    local yOffset = -10
    
    -- Dungeon title
    local dungeonTitle = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dungeonTitle:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    dungeonTitle:SetText("|cFFFFD700" .. dungeonName .. "|r")
    yOffset = yOffset - 35
    
    -- Key mechanics
    local mechanicsTitle = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mechanicsTitle:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    mechanicsTitle:SetText("|cFFFFAA00Key Mechanics:|r")
    yOffset = yOffset - 25
    
    for mechanic, value in pairs(recommendations.summary) do
        local mechanicText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        mechanicText:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset)
        
        local color = "|cFFFFFFFF"
        if value >= 80 then
            color = "|cFFFF4444"
        elseif value >= 60 then
            color = "|cFFFFAA00"
        end
        
        mechanicText:SetText(string.format("%s%s: %d%%|r", color, self:FormatMechanicName(mechanic), value))
        yOffset = yOffset - 20
    end
    
    yOffset = yOffset - 15
    
    -- Role recommendations
    local roles = {"tank", "healer", "dps"}
    local roleColors = {tank = "|cFF4A9EFF", healer = "|cFF40FF40", dps = "|cFFFF6347"}
    local roleNames = {tank = "Tanks", healer = "Healers", dps = "DPS"}
    
    for _, role in ipairs(roles) do
        if recommendations.preferredSpecs[role] then
            local roleTitle = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            roleTitle:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
            roleTitle:SetText(roleColors[role] .. "Top " .. roleNames[role] .. ":|r")
            yOffset = yOffset - 22
            
            -- Sort specs by rating
            local sortedSpecs = {}
            for spec, rating in pairs(recommendations.preferredSpecs[role]) do
                table.insert(sortedSpecs, {spec = spec, rating = rating})
            end
            table.sort(sortedSpecs, function(a, b) return a.rating > b.rating end)
            
            -- Show top 3 specs
            for i = 1, math.min(3, #sortedSpecs) do
                local spec = sortedSpecs[i]
                local specText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                specText:SetPoint("TOPLEFT", parent, "TOPLEFT", 30, yOffset)
                
                local ratingColor = "|cFFFFFFFF"
                if spec.rating >= 90 then
                    ratingColor = "|cFF00FF00"
                elseif spec.rating >= 80 then
                    ratingColor = "|cFFFFAA00"
                end
                
                local formattedSpec = string.gsub(spec.spec, "_", " - ")
                specText:SetText(string.format("%s%d%%. %s|r", ratingColor, spec.rating, formattedSpec))
                yOffset = yOffset - 18
            end
            
            yOffset = yOffset - 10
        end
    end
end

-- Analyze current group (simplified)
function MatchCreator:AnalyzeCurrentGroup()
    if not IsInGroup() then
        return nil
    end
    
    local group = {
        tanks = {},
        healers = {},
        dps = {}
    }
    
    -- Analyze group members (simplified)
    local numMembers = GetNumGroupMembers()
    for i = 1, numMembers do
        local unit = (numMembers <= 5) and ("party" .. i) or ("raid" .. i)
        if UnitExists(unit) then
            local name = UnitName(unit)
            local _, class = UnitClass(unit)
            
            if name and class then
                -- Simple role assignment based on class (placeholder)
                if class == "WARRIOR" or class == "PALADIN" or class == "DEATHKNIGHT" then
                    table.insert(group.tanks, {name = name, class = class})
                elseif class == "PRIEST" or class == "SHAMAN" or class == "DRUID" then
                    table.insert(group.healers, {name = name, class = class})
                else
                    table.insert(group.dps, {name = name, class = class})
                end
            end
        end
    end
    
    return group
end

-- Create minimap button
function MatchCreator:CreateMinimapButton()
    if self.minimapButton then return end
    
    local button = CreateFrame("Button", "MatchCreatorMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -15, 5)
    
    -- Button texture
    local texture = button:CreateTexture(nil, "BACKGROUND")
    texture:SetSize(20, 20)
    texture:SetPoint("CENTER")
    texture:SetTexture("Interface\\Icons\\Achievement_Boss_Murmur")
    
    -- Border
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    -- Click handler
    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            MatchCreator:ShowRecommendationFrame()
        end
    end)
    
    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Match Creator", 1, 1, 1)
        GameTooltip:AddLine("Left-click: Show recommendations", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    self.minimapButton = button
    return button
end

-- Slash command handler
SLASH_MATCHCREATOR1 = "/matchcreator"
SLASH_MATCHCREATOR2 = "/mc"

SlashCmdList["MATCHCREATOR"] = function(msg)
    local args = {strsplit(" ", msg)}
    local cmd = args[1] and string.lower(args[1]) or ""
    
    if cmd == "" or cmd == "show" then
        MatchCreator:ShowRecommendationFrame()
        
    elseif cmd == "hide" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Hide()
        end
        
    elseif cmd == "toggle" then
        if MatchCreatorFrame and MatchCreatorFrame:IsShown() then
            MatchCreatorFrame:Hide()
        else
            MatchCreator:ShowRecommendationFrame()
        end
        
    elseif cmd == "test" then
        local dungeon = args[2] or "Mists of Tirna Scithe"
        local recommendations = MatchCreator:GetDungeonRecommendations(dungeon)
        
        if recommendations then
            print("|cFF00FF00Match Creator Test - " .. dungeon .. ":|r")
            print("Key mechanics:")
            for mechanic, value in pairs(recommendations.summary) do
                local color = value >= 80 and "|cFFFF4444" or value >= 60 and "|cFFFFAA00" or "|cFFFFFFFF"
                print(string.format("  %s%s: %d%%|r", color, MatchCreator:FormatMechanicName(mechanic), value))
            end
        else
            print("|cFFFF0000Error:|r Dungeon not found: " .. dungeon)
        end
        
    elseif cmd == "list" then
        print("|cFF00FF00Available Dungeons:|r")
        for dungeonName, _ in pairs(MatchCreator.dungeonData or {}) do
            print("  • " .. dungeonName)
        end
        
    elseif cmd == "analyze" then
        local group = MatchCreator:AnalyzeCurrentGroup()
        if group then
            print("|cFF00FF00Current Group Analysis:|r")
            print("Tanks: " .. #group.tanks)
            print("Healers: " .. #group.healers) 
            print("DPS: " .. #group.dps)
        else
            print("|cFFFF0000Error:|r Not in a group")
        end
        
    elseif cmd == "minimap" then
        if MatchCreator.minimapButton then
            if MatchCreator.minimapButton:IsShown() then
                MatchCreator.minimapButton:Hide()
                print("|cFF00FF00Match Creator:|r Minimap button hidden")
            else
                MatchCreator.minimapButton:Show()
                print("|cFF00FF00Match Creator:|r Minimap button shown")
            end
        end
        
    elseif cmd == "reset" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Hide()
            MatchCreatorFrame = nil
        end
        print("|cFF00FF00Match Creator:|r UI reset")
        
    elseif cmd == "help" then
        print("|cFF00FF00Match Creator Commands:|r")
        print("/mc or /mc show - Show recommendations window")
        print("/mc hide - Hide window")
        print("/mc toggle - Toggle window visibility")
        print("/mc test [dungeon] - Test dungeon analysis")
        print("/mc list - List available dungeons")
        print("/mc analyze - Analyze current group")
        print("/mc minimap - Toggle minimap button")
        print("/mc reset - Reset UI")
        print("/mc help - Show this help")
        
    else
        print("|cFFFF0000Unknown command:|r " .. cmd)
        print("Type |cFFFFFF00/mc help|r for available commands")
    end
end

-- Event handler for addon loading
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "MatchCreator" then
        MatchCreator:Initialize()
        MatchCreator:CreateMinimapButton()
        print("|cFF00FF00Match Creator|r loaded! Type |cFFFFFF00/mc help|r for commands.")
    elseif event == "PLAYER_LOGIN" then
        -- Additional initialization after login if needed
        if MatchCreator.minimapButton then
            MatchCreator.minimapButton:Show()
        end
    end
end)
