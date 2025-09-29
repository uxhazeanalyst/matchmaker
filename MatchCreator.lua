-- Initialize Class Spec Utilities Database
function MatchCreator:InitializeClassUtilities()
    self.classUtilities = {
        ["Demon Hunter"] = {
            ["Vengeance"] = {interrupt = true, mobility = "excellent", magicDefense = "excellent"},
            ["Havoc"] = {interrupt = true, mobility = "excellent", magicDefense = "high"}
        },
        ["Death Knight"] = {
            ["Blood"] = {interrupt = true, fearImmunity = true, diseaseImmunity = true, grip = true},
            ["Frost"] = {interrupt = true, fearImmunity = true, diseaseImmunity = true},
            ["Unholy"] = {interrupt = true, fearImmunity = true, diseaseImmunity = true, grip = true}
        },
        ["Druid"] = {
            ["Guardian"] = {enrageRemoval = true, mobility = "good"},
            ["Feral"] = {enrageRemoval = true, mobility = "high"},
            ["Balance"] = {dispel = true, enrageRemoval = true, mobility = "good"},
            ["Restoration"] = {dispel = true, enrageRemoval = true, mobility = "good"}
        },
        ["Evoker"] = {
            ["Devastation"] = {interrupt = true, dispel = true, mobility = "high"},
            ["Preservation"] = {interrupt = true, dispel = true, mobility = "high"}
        },
        ["Hunter"] = {
            ["Beast Mastery"] = {interrupt = true, enrageRemoval = true, mobility = "excellent"},
            ["Marksmanship"] = {interrupt = true, mobility = "good"},
            ["Survival"] = {interrupt = true, mobility = "high"}
        },
        ["Mage"] = {
            ["Arcane"] = {interrupt = true, spellSteal = true, dispel = true},
            ["Fire"] = {interrupt = true, spellSteal = true, dispel = true},
            ["Frost"] = {interrupt = true, spellSteal = true, dispel = true}
        },
        ["Monk"] = {
            ["Brewmaster"] = {interrupt = true, mobility = "excellent"},
            ["Mistweaver"] = {interrupt = true, dispel = true, mobility = "excellent"},
            ["Windwalker"] = {interrupt = true, mobility = "excellent"}
        },
        ["Paladin"] = {
            ["Holy"] = {interrupt = true, dispel = true, fearImmunity = true},
            ["Protection"] = {interrupt = true, dispel = true, fearImmunity = true},
            ["Retribution"] = {interrupt = true, dispel = true, fearImmunity = true}
        },
        ["Priest"] = {
            ["Discipline"] = {interrupt = true, dispel = true},
            ["Holy"] = {interrupt = true, dispel = true},
            ["Shadow"] = {interrupt = true, dispel = true}
        },
        ["Rogue"] = {
            ["Assassination"] = {interrupt = true, mobility = "high"},
            ["Outlaw"] = {interrupt = true, mobility = "excellent"},
            ["Subtlety"] = {interrupt = true, mobility = "excellent"}
        },
        ["Shaman"] = {
            ["Elemental"] = {interrupt = true, dispel = true},
            ["Enhancement"] = {interrupt = true, dispel = true, mobility = "high"},
            ["Restoration"] = {interrupt = true, dispel = true}
        },
        ["Warlock"] = {
            ["Affliction"] = {interrupt = true, dispel = true},
            ["Demonology"] = {interrupt = true, dispel = true},
            ["Destruction"] = {interrupt = true, dispel = true}
        },
        ["Warrior"] = {
            ["Arms"] = {interrupt = true, fearImmunity = true},
            ["Fury"] = {interrupt = true, fearImmunity = true, mobility = "good"},
            ["Protection"] = {interrupt = true, fearImmunity = true}
        }
    }
end

-- Initialize Affix Data
function MatchCreator:InitializeAffixData()
    self.affixData = {
        ["Fortified"] = {
            description = "Non-boss enemies have 20% more health and deal 30% increased damage",
            impact = {
                interrupt = 20,
                aoeReduction = 15,
                physicalDefense = 15,
                crowdControl = 10
            }
        },
        ["Tyrannical"] = {
            description = "Boss enemies have 30% more health and deal 15% increased damage",
            impact = {
                magicDefense = 15,
                aoeReduction = 20,
                mobility = 10,
                positioning = 15
            }
        },
        ["Bursting"] = {
            description = "Enemies explode when slain, dealing damage that stacks",
            impact = {
                aoeReduction = 25,
                dispel = 15,
                positioning = 20
            },
            counterClasses = {"Priest", "Paladin", "Shaman"}
        },
        ["Inspiring"] = {
            description = "Some enemies inspire nearby allies, granting CC immunity",
            impact = {
                interrupt = 30,
                mobility = 15,
                crowdControl = -20,
                positioning = 20
            },
            counterClasses = {"Mage", "Hunter", "Shaman", "Demon Hunter"}
        },
        ["Raging"] = {
            description = "Enemies enrage at 30% health, dealing 100% increased damage",
            impact = {
                enrageRemoval = 40,
                crowdControl = -15,
                positioning = 20
            },
            counterClasses = {"Hunter", "Druid"},
            critical = true
        },
        ["Sanguine"] = {
            description = "Slain enemies leave healing pools that damage players",
            impact = {
                mobility = 25,
                positioning = 20,
                rangedAdvantage = 15
            },
            counterClasses = {"Death Knight", "Druid", "Monk"}
        },
        ["Spiteful"] = {
            description = "Enemies spawn Spiteful Shades on death that fixate players",
            impact = {
                mobility = 30,
                rangedAdvantage = 15,
                aoeReduction = 20
            },
            counterClasses = {"Hunter", "Mage", "Warlock"}
        },
        ["Storming"] = {
            description = "Enemies periodically summon damaging whirlwinds",
            impact = {
                mobility = 25,
                positioning = 20,
                rangedAdvantage = 10
            },
            counterClasses = {"Hunter", "Mage", "Warlock", "Priest"}
        },
        ["Bolstering"] = {
            description = "Enemies bolster nearby allies when killed",
            impact = {
                crowdControl = 15,
                positioning = 25,
                aoeReduction = 20
            },
            counterClasses = {"Any class with strong single target"}
        },
        ["Explosive"] = {
            description = "Enemies spawn explosive orbs that must be destroyed",
            impact = {
                interrupt = -10,
                positioning = 20,
                rangedAdvantage = 25
            },
            counterClasses = {"Hunter", "Warlock", "Balance Druid"}
        }
    }
    
    -- Set current week affixes (placeholder - would be dynamically updated)
    self.currentAffixes = {"Tyrannical", "Bursting", "Storming"}
end

-- Get current affixes
function MatchCreator:GetCurrentAffixes()
    return self.currentAffixes or {}
end

-- Get spec utilities
function MatchCreator:GetSpecUtilities(specKey)
    local class, spec = string.match(specKey, "(.+)_(.+)")
    if not class or not spec then return nil end
    
    -- Handle "Any" spec designation
    if spec == "Any" then
        -- Return combined utilities of all specs
        local classData = self.classUtilities[class]
        if not classData then return nil end
        
        local combinedUtils = {}
        for _, specUtils in pairs(classData) do
            for util, value in pairs(specUtils) do
                if not combinedUtils[util] then
                    combinedUtils[util] = value
                end
            end
        end
        return combinedUtils
    end
    
    if self.classUtilities[class] and self.classUtilities[class][spec] then
        return self.classUtilities[class][spec]
    end
    
    return nil
end

-- Format utilities for display
function MatchCreator:FormatUtilities(utilities)
    if not utilities then return "" end
    
    local utilStrings = {}
    
    if utilities.interrupt then
        table.insert(utilStrings, "|cFF00FF00Interrupt|r")
    end
    if utilities.dispel then
        table.insert(utilStrings, "|cFF4169E1Dispel|r")
    end
    if utilities.enrageRemoval then
        table.insert(utilStrings, "|cFFFF69B4Soothe|r")
    end
    if utilities.spellSteal then
        table.insert(utilStrings, "|cFF9370DBSpell Steal|r")
    end
    if utilities.fearImmunity then
        table.insert(utilStrings, "|cFFFFA500Fear Immune|r")
    end
    if utilities.mobility == "excellent" then
        table.insert(utilStrings, "|cFFFFD700High Mobility|r")
    end
    if utilities.grip then
        table.insert(utilStrings, "|cFF00CED1Grip|r")
    end
    
    return table.concat(utilStrings, " • ")
end

-- Enhanced spec card with utilities
function MatchCreator:CreateSpecCard(content, spec, yOffset)
    local cardHeight = 70
    
    -- Card background
    local card = CreateFrame("Frame", nil, content.child)
    card:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    card:SetSize(520, cardHeight)
    
    local cardBG = card:CreateTexture(nil, "BACKGROUND")
    cardBG:SetAllPoints()
    cardBG:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Rating indicator on left side
    local ratingBG = CreateFrame("Frame", nil, card)
    ratingBG:SetPoint("LEFT", card, "LEFT", 0, 0)
    ratingBG:SetSize(60, cardHeight)
    
    local ratingTexture = ratingBG:CreateTexture(nil, "ARTWORK")
    ratingTexture:SetAllPoints()
    
    -- Color by rating
    if spec.rating >= 90 then
        ratingTexture:SetColorTexture(0, 0.8, 0, 0.6)
    elseif spec.rating >= 80 then
        ratingTexture:SetColorTexture(1, 0.8, 0, 0.6)
    elseif spec.rating >= 70 then
        ratingTexture:SetColorTexture(1, 0.6, 0, 0.6)
    else
        ratingTexture:SetColorTexture(0.6, 0.6, 0.6, 0.6)
    end
    
    -- Rating number
    local ratingText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    ratingText:SetPoint("CENTER", ratingBG, "CENTER", 0, 0)
    ratingText:SetText(spec.rating)
    
    -- Spec name
    local specName = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specName:SetPoint("LEFT", ratingBG, "RIGHT", 10, 20)
    local formattedSpec = string.gsub(spec.spec, "_", " ")
    specName:SetText("|cFFFFFFFF" .. formattedSpec .. "|r")
    
    -- Utilities display
    local utilities = self:GetSpecUtilities(spec.spec)
    if utilities then
        local utilText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        utilText:SetPoint("LEFT", ratingBG, "RIGHT", 10, 5)
        utilText:SetWidth(430)
        utilText:SetJustifyH("LEFT")
        utilText:SetText(self:FormatUtilities(utilities))
    end
    
    -- Performance description
    local perfDesc = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    perfDesc:SetPoint("LEFT", ratingBG, "RIGHT", 10, -12)
    perfDesc:SetWidth(430)
    perfDesc:SetJustifyH("LEFT")
    
    local description = self:GetPerformanceDescription(spec.rating)
    perfDesc:SetText("|cFF888888" .. description .. "|r")
    
    table.insert(content.elements, card)
    return card
end

-- Add boss information display
function MatchCreator:ShowBossInfo(dungeonName)
    local dungeonData = self.dungeonData[dungeonName]
    if not dungeonData or not dungeonData.bosses then
        print("|cFFFF0000Error:|r No boss data available for " .. dungeonName)
        return
    end
    
    print("|cFF00FF00Boss Strategies for " .. dungeonName .. ":|r")
    for bossName, bossData in pairs(dungeonData.bosses) do
        print("|cFFFFD700" .. bossName .. "|r - " .. (bossData.difficulty or "Unknown") .. " difficulty")
        print("  " .. bossData.tips)
    end
end

-- Enhanced overview tab with boss previews
function MatchCreator:UpdateOverviewTab(recommendations, dungeonName)
    local content = MatchCreatorFrame.tabContents[1]
    self:ClearTabContent(1)
    
    local yOffset = -10
    
    -- Dungeon title
    local dungeonTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dungeonTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    dungeonTitle:SetText("|cFFFFD700" .. dungeonName .. "|r")
    table.insert(content.elements, dungeonTitle)
    yOffset = yOffset - 30
    
    -- Current affixes display
    local affixes = self:GetCurrentAffixes()
    if affixes and #affixes > 0 then
        local affixTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        affixTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        affixTitle:SetText("|cFFFFAA00Current Week:|r " .. table.concat(affixes, ", "))
        table.insert(content.elements, affixTitle)
        yOffset = yOffset - 25
    end
    
    -- Quick summary
    local summaryTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    summaryTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    summaryTitle:SetText("|cFF00FF00Quick Recommendations:|r")
    table.insert(content.elements, summaryTitle)
    yOffset = yOffset - 25
    
    -- Top pick for each role
    local roles = {
        {key = "tank", name = "Tank", color = "|cFF4A9EFF"},
        {key = "healer", name = "Healer", color = "|cFF40FF40"},
        {key = "dps", name = "DPS", color = "|cFFFF6347"}
    }
    
    for _, role in ipairs(roles) do
        if recommendations.preferredSpecs[role.key] then
            local topSpec = self:GetTopSpec(recommendations.preferredSpecs[role.key])
            if topSpec then
                local roleText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                roleText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
                local formattedSpec = string.gsub(topSpec.spec, "_", " - ")
                roleText:SetText(string.format("%s%s:|r %s (%d%%)", role.color, role.name, formattedSpec, topSpec.rating))
                table.insert(content.elements, roleText)
                yOffset = yOffset - 18
            end
        end
    end
    
    yOffset = yOffset - 15
    
    -- Key mechanics with visual bars
    local mechanicsTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mechanicsTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    mechanicsTitle:SetText("|cFFFFAA00Key Mechanics:|r")
    table.insert(content.elements, mechanicsTitle)
    yOffset = yOffset - 25
    
    yOffset = self:CreateMechanicBars(content, recommendations.summary, yOffset)
    
    yOffset = yOffset - 15
    
    -- Boss preview section
    local dungeonData = self.dungeonData[dungeonName]
    if dungeonData and dungeonData.bosses then
        local bossTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        bossTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        bossTitle:SetText("|cFFFF69B4Boss Quick Reference:|r")
        table.insert(content.elements, bossTitle)
        yOffset = yOffset - 22
        
        for bossName, bossData in pairs(dungeonData.bosses) do
            local bossText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            bossText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
            bossText:SetWidth(520)
            bossText:SetJustifyH("LEFT")
            
            local diffColor = bossData.difficulty == "High" and "|cFFFF4444" or 
                             bossData.difficulty == "Moderate" and "|cFFFFAA00" or "|cFF88FF88"
            
            bossText:SetText(diffColor .. bossName .. "|r - " .. (bossData.tips or "No tips available"))
            table.insert(content.elements, bossText)
            yOffset = yOffset - (bossText:GetStringHeight() + 5)
        end
    end
    
    -- Adjust content height
    if yOffset < -400 then
        content.child:SetHeight(math.abs(yOffset) + 50)
    end
end

-- Create mechanic bars and return new yOffset
function MatchCreator:CreateMechanicBars(content, mechanics, yOffset)
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        table.insert(sortedMechanics, {name = mechanic, value = value})
    end
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    local maxBarWidth = 300
    for i, mech in ipairs(sortedMechanics) do
        if i > 6 then break end
        
        local mechName = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        mechName:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
        mechName:SetText(self:FormatMechanicName(mech.name))
        table.insert(content.elements, mechName)
        
        local barBG = CreateFrame("Frame", nil, content.child)
        barBG:SetPoint("LEFT", mechName, "RIGHT", 10, 0)
        barBG:SetSize(maxBarWidth, 12)
        local bgTexture = barBG:CreateTexture(nil, "BACKGROUND")
        bgTexture:SetAllPoints()
        bgTexture:SetColorTexture(0.2, 0.2, 0.2, 0.8)
        table.insert(content.elements, barBG)
        
        local barWidth = (mech.value / 100) * maxBarWidth
        local bar = CreateFrame("Frame", nil, content.child)
        bar:SetPoint("LEFT", barBG, "LEFT", 0, 0)
        bar:SetSize(barWidth, 12)
        
        local barTexture = bar:CreateTexture(nil, "ARTWORK")
        barTexture:SetAllPoints()
        
        if mech.value >= 90 then
            barTexture:SetColorTexture(1, 0.2, 0.2, 0.8)
        elseif mech.value >= 80 then
            barTexture:SetColorTexture(1, 0.6, 0, 0.8)
        elseif mech.value >= 70 then
            barTexture:SetColorTexture(1, 1, 0, 0.8)
        else
            barTexture:SetColorTexture(0.6, 0.8, 1, 0.8)
        end
        
        table.insert(content.elements, bar)
        
        local valueText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", barBG, "RIGHT", 5, 0)
        valueText:SetText(mech.value .. "%")
        table.insert(content.elements, valueText)
        
        yOffset = yOffset - 20
    end
    
    return yOffset
end

-- Add new slash commands for Phase 1B features
local originalSlashHandler = SlashCmdList["MATCHCREATOR"]
SlashCmdList["MATCHCREATOR"] = function(msg)
    local args = {strsplit(" ", msg)}
    local cmd = args[1] and string.lower(args[1]) or ""
    
    if cmd == "bosses" then
        local dungeon = table.concat(args, " ", 2)
        if dungeon and dungeon ~= "" then
            MatchCreator:ShowBossInfo(dungeon)
        else
            local current = MatchCreator:GetCurrentDungeon()
            MatchCreator:ShowBossInfo(current)
        end
        
    elseif cmd == "affixes" then
        local affixes = MatchCreator:GetCurrentAffixes()
        print("|cFF00FF00Current Week Affixes:|r")
        for _, affix in ipairs(affixes) do
            local affixData = MatchCreator.affixData[affix]
            if affixData then
                print("|cFFFFD700" .. affix .. ":|r " .. affixData.description)
                if affixData.counterClasses then
                    print("  Best classes: " .. table.concat(affixData.counterClasses, ", "))
                end
            end
        end
        
    elseif cmd == "utilities" then
        local specKey = table.concat(args, " ", 2)
        if specKey and specKey ~= "" then
            local utilities = MatchCreator:GetSpecUtilities(specKey)
            if utilities then
                print("|cFF00FF00Utilities for " .. specKey .. ":|r")
                for util, value in pairs(utilities) do
                    print("  " .. util .. ": " .. tostring(value))
                end
            else
                print("|cFFFF0000Error:|r Spec not found")
            end
        else
            print("|cFFFF0000Usage:|r /mc utilities <Class>_<Spec>")
            print("Example: /mc utilities Demon Hunter_Vengeance")
        end
        
    else
        -- Call original handler
        originalSlashHandler(msg)
    end
end-- Format mechanic names for display
function MatchCreator:FormatMechanicName(mechanic)
    local names = {
        parry = "Parry",
        dodge = "Dodge",
        block = "Block",
        magicDefense = "Magic Defense",
        physicalDefense = "Physical Defense",
        aoeReduction = "AoE Reduction",
        dispel = "Dispel",
        interrupt = "Interrupt",
        mobility = "Mobility",
        enrageRemoval = "Enrage Removal",
        stunBreak = "Stun Break",
        immunity = "Immunity Phases",
        fearResist = "Fear Resistance",
        hookAvoidance = "Hook Avoidance",
        diseaseResist = "Disease Resistance",
        positioning = "Positioning",
        crowdControl = "Crowd Control",
        rangedAdvantage = "Ranged Advantage",
        knockbackResist = "Knockback Resist",
        reflectAvoidance = "Reflect Avoidance",
        portalNavigation = "Portal Navigation",
        spellSteal = "Spell Steal",
        immunityPhases = "Immunity Phases"
    }
    return names[mechanic] or mechanic
end

-- Enhanced recommendation frame with tabbed interface
function MatchCreator:ShowRecommendationFrame()
    -- Close existing frame
    if MatchCreatorFrame then
        MatchCreatorFrame:Hide()
        MatchCreatorFrame = nil
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "MatchCreatorFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(600, 500)
    frame:SetPoint("CENTER", 0, 0)
    
    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
    frame.title:SetText("Match Creator - Dungeon Analysis")
    
    -- Make movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    -- Create tab system
    frame.tabs = {}
    frame.tabContents = {}
    frame.activeTab = 1
    
    local tabNames = {"Overview", "Tanks", "Healers", "DPS", "Mechanics"}
    local tabWidth = 110
    
    for i, tabName in ipairs(tabNames) do
        local tab = CreateFrame("Button", "MatchCreatorTab"..i, frame, "TabButtonTemplate")
        tab:SetSize(tabWidth, 32)
        tab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", (i-1) * tabWidth, 2)
        tab:SetText(tabName)
        tab.tabIndex = i
        
        tab:SetScript("OnClick", function(self)
            MatchCreator:SelectTab(self.tabIndex)
        end)
        
        frame.tabs[i] = tab
        
        -- Create content frame for each tab
        local content = CreateFrame("ScrollFrame", "MatchCreatorContent"..i, frame, "UIPanelScrollFrameTemplate")
        content:SetPoint("TOPLEFT", frame.Inset, "TOPLEFT", 4, -4)
        content:SetPoint("BOTTOMRIGHT", frame.Inset, "BOTTOMRIGHT", -24, 4)
        
        local contentChild = CreateFrame("Frame", nil, content)
        contentChild:SetSize(550, 450)
        content:SetScrollChild(contentChild)
        content:Hide()
        
        frame.tabContents[i] = {frame = content, child = contentChild, elements = {}}
    end
    
    -- Show first tab by default
    frame.tabContents[1].frame:Show()
    PanelTemplates_SelectTab(frame.tabs[1])
    
    -- Load content
    self:RefreshTabContent(1)
    
    frame:Show()
end

-- Tab selection handler
function MatchCreator:SelectTab(tabIndex)
    local frame = MatchCreatorFrame
    if not frame then return end
    
    -- Hide all tab contents
    for i, content in ipairs(frame.tabContents) do
        content.frame:Hide()
        PanelTemplates_DeselectTab(frame.tabs[i])
    end
    
    -- Show selected tab
    frame.tabContents[tabIndex].frame:Show()
    PanelTemplates_SelectTab(frame.tabs[tabIndex])
    frame.activeTab = tabIndex
    
    -- Refresh content for the selected tab
    self:RefreshTabContent(tabIndex)
end

-- Refresh tab content
function MatchCreator:RefreshTabContent(tabIndex)
    local currentDungeon = self:GetCurrentDungeon()
    local recommendations = self:GetDungeonRecommendations(currentDungeon)
    
    if not recommendations then
        self:ShowTabError(tabIndex, "No data available for current dungeon")
        return
    end
    
    if tabIndex == 1 then
        self:UpdateOverviewTab(recommendations, currentDungeon)
    elseif tabIndex == 2 then
        self:UpdateRoleTab("tank", recommendations, currentDungeon)
    elseif tabIndex == 3 then
        self:UpdateRoleTab("healer", recommendations, currentDungeon)
    elseif tabIndex == 4 then
        self:UpdateRoleTab("dps", recommendations, currentDungeon)
    elseif tabIndex == 5 then
        self:UpdateMechanicsTab(recommendations, currentDungeon)
    end
end

-- Update overview tab
function MatchCreator:UpdateOverviewTab(recommendations, dungeonName)
    local content = MatchCreatorFrame.tabContents[1]
    self:ClearTabContent(1)
    
    local yOffset = -10
    
    -- Dungeon title
    local dungeonTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dungeonTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    dungeonTitle:SetText("|cFFFFD700" .. dungeonName .. "|r")
    table.insert(content.elements, dungeonTitle)
    yOffset = yOffset - 35
    
    -- Quick summary
    local summaryTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    summaryTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    summaryTitle:SetText("|cFF00FF00Quick Recommendations:|r")
    table.insert(content.elements, summaryTitle)
    yOffset = yOffset - 25
    
    -- Top pick for each role
    local roles = {
        {key = "tank", name = "Tank", color = "|cFF4A9EFF"},
        {key = "healer", name = "Healer", color = "|cFF40FF40"},
        {key = "dps", name = "DPS", color = "|cFFFF6347"}
    }
    
    for _, role in ipairs(roles) do
        if recommendations.preferredSpecs[role.key] then
            local topSpec = self:GetTopSpec(recommendations.preferredSpecs[role.key])
            if topSpec then
                local roleText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                roleText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
                local formattedSpec = string.gsub(topSpec.spec, "_", " - ")
                roleText:SetText(string.format("%s%s:|r %s (%d%%)", role.color, role.name, formattedSpec, topSpec.rating))
                table.insert(content.elements, roleText)
                yOffset = yOffset - 18
            end
        end
    end
    
    yOffset = yOffset - 15
    
    -- Key mechanics with visual bars
    local mechanicsTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mechanicsTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    mechanicsTitle:SetText("|cFFFFAA00Key Mechanics:|r")
    table.insert(content.elements, mechanicsTitle)
    yOffset = yOffset - 25
    
    self:CreateMechanicBars(content, recommendations.summary, yOffset)
end

-- Create visual mechanic importance bars
function MatchCreator:CreateMechanicBars(content, mechanics, yOffset)
    -- Sort mechanics by importance
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        table.insert(sortedMechanics, {name = mechanic, value = value})
    end
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    -- Create visual bars for top 6 mechanics
    local maxBarWidth = 300
    for i, mech in ipairs(sortedMechanics) do
        if i > 6 then break end
        
        -- Mechanic name
        local mechName = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        mechName:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
        mechName:SetText(self:FormatMechanicName(mech.name))
        table.insert(content.elements, mechName)
        
        -- Create bar background
        local barBG = CreateFrame("Frame", nil, content.child)
        barBG:SetPoint("LEFT", mechName, "RIGHT", 10, 0)
        barBG:SetSize(maxBarWidth, 12)
        local bgTexture = barBG:CreateTexture(nil, "BACKGROUND")
        bgTexture:SetAllPoints()
        bgTexture:SetColorTexture(0.2, 0.2, 0.2, 0.8)
        table.insert(content.elements, barBG)
        
        -- Create importance bar
        local barWidth = (mech.value / 100) * maxBarWidth
        local bar = CreateFrame("Frame", nil, content.child)
        bar:SetPoint("LEFT", barBG, "LEFT", 0, 0)
        bar:SetSize(barWidth, 12)
        
        local barTexture = bar:CreateTexture(nil, "ARTWORK")
        barTexture:SetAllPoints()
        
        -- Color code by importance
        if mech.value >= 90 then
            barTexture:SetColorTexture(1, 0.2, 0.2, 0.8) -- Red for critical
        elseif mech.value >= 80 then
            barTexture:SetColorTexture(1, 0.6, 0, 0.8) -- Orange for high
        elseif mech.value >= 70 then
            barTexture:SetColorTexture(1, 1, 0, 0.8) -- Yellow for moderate
        else
            barTexture:SetColorTexture(0.6, 0.8, 1, 0.8) -- Blue for low
        end
        
        table.insert(content.elements, bar)
        
        -- Value text
        local valueText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", barBG, "RIGHT", 5, 0)
        valueText:SetText(mech.value .. "%")
        table.insert(content.elements, valueText)
        
        yOffset = yOffset - 20
    end
end

-- Update role-specific tab
function MatchCreator:UpdateRoleTab(role, recommendations, dungeonName)
    local tabIndex = role == "tank" and 2 or role == "healer" and 3 or 4
    local content = MatchCreatorFrame.tabContents[tabIndex]
    self:ClearTabContent(tabIndex)
    
    local yOffset = -10
    local roleColors = {tank = "|cFF4A9EFF", healer = "|cFF40FF40", dps = "|cFFFF6347"}
    local roleNames = {tank = "Tank", healer = "Healer", dps = "DPS"}
    
    -- Role title
    local roleTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    roleTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    roleTitle:SetText(roleColors[role] .. roleNames[role] .. " Recommendations|r")
    table.insert(content.elements, roleTitle)
    yOffset = yOffset - 30
    
    -- Dungeon context
    local contextText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    contextText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    contextText:SetText("For: " .. dungeonName)
    table.insert(content.elements, contextText)
    yOffset = yOffset - 25
    
    if not recommendations.preferredSpecs[role] then
        local noData = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noData:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        noData:SetText("No data available for this role")
        table.insert(content.elements, noData)
        return
    end
    
    -- Sort specs by rating
    local sortedSpecs = {}
    for spec, rating in pairs(recommendations.preferredSpecs[role]) do
        table.insert(sortedSpecs, {spec = spec, rating = rating})
    end
    table.sort(sortedSpecs, function(a, b) return a.rating > b.rating end)
    
    -- Create spec cards
    for i, spec in ipairs(sortedSpecs) do
        local card = self:CreateSpecCard(content, spec, yOffset)
        yOffset = yOffset - 70
        
        if yOffset < -400 then
            content.child:SetHeight(-yOffset + 50)
        end
    end
end

-- Create spec recommendation card
function MatchCreator:CreateSpecCard(content, spec, yOffset)
    local cardHeight = 60
    
    -- Card background
    local card = CreateFrame("Frame", nil, content.child)
    card:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    card:SetSize(520, cardHeight)
    
    local cardBG = card:CreateTexture(nil, "BACKGROUND")
    cardBG:SetAllPoints()
    cardBG:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Rating indicator on left side
    local ratingBG = CreateFrame("Frame", nil, card)
    ratingBG:SetPoint("LEFT", card, "LEFT", 0, 0)
    ratingBG:SetSize(60, cardHeight)
    
    local ratingTexture = ratingBG:CreateTexture(nil, "ARTWORK")
    ratingTexture:SetAllPoints()
    
    -- Color by rating
    if spec.rating >= 90 then
        ratingTexture:SetColorTexture(0, 0.8, 0, 0.6) -- Green for excellent
    elseif spec.rating >= 80 then
        ratingTexture:SetColorTexture(1, 0.8, 0, 0.6) -- Gold for very good
    elseif spec.rating >= 70 then
        ratingTexture:SetColorTexture(1, 0.6, 0, 0.6) -- Orange for good
    else
        ratingTexture:SetColorTexture(0.6, 0.6, 0.6, 0.6) -- Gray for average
    end
    
    -- Rating number
    local ratingText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    ratingText:SetPoint("CENTER", ratingBG, "CENTER", 0, 0)
    ratingText:SetText(spec.rating)
    
    -- Spec name
    local specName = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specName:SetPoint("LEFT", ratingBG, "RIGHT", 10, 15)
    local formattedSpec = string.gsub(spec.spec, "_", " ")
    specName:SetText("|cFFFFFFFF" .. formattedSpec .. "|r")
    
    -- Performance description
    local perfDesc = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    perfDesc:SetPoint("LEFT", ratingBG, "RIGHT", 10, -5)
    perfDesc:SetWidth(430)
    perfDesc:SetJustifyH("LEFT")
    
    local description = self:GetPerformanceDescription(spec.rating)
    perfDesc:SetText("|cFF888888" .. description .. "|r")
    
    table.insert(content.elements, card)
    return card
end

-- Get performance description
function MatchCreator:GetPerformanceDescription(rating)
    if rating >= 95 then
        return "Exceptional - Perfect for this content"
    elseif rating >= 90 then
        return "Excellent - Highly recommended choice"
    elseif rating >= 80 then
        return "Very Good - Strong performance expected"
    elseif rating >= 70 then
        return "Good - Solid choice for this dungeon"
    elseif rating >= 60 then
        return "Average - Can handle the content"
    else
        return "Below Average - Consider alternatives"
    end
end

-- Update mechanics analysis tab
function MatchCreator:UpdateMechanicsTab(recommendations, dungeonName)
    local content = MatchCreatorFrame.tabContents[5]
    self:ClearTabContent(5)
    
    local yOffset = -10
    
    -- Mechanics title
    local mechTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mechTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    mechTitle:SetText("|cFFFFD700Detailed Mechanics Analysis|r")
    table.insert(content.elements, mechTitle)
    yOffset = yOffset - 25
    
    -- Dungeon context
    local contextText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    contextText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    contextText:SetText("For: " .. dungeonName)
    table.insert(content.elements, contextText)
    yOffset = yOffset - 30
    
    -- Create comprehensive mechanics breakdown
    self:CreateDetailedMechanicsDisplay(content, recommendations.mechanics, yOffset)
end

-- Create detailed mechanics display
function MatchCreator:CreateDetailedMechanicsDisplay(content, mechanics, yOffset)
    -- Sort all mechanics by value
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        if value > 0 then
            table.insert(sortedMechanics, {name = mechanic, value = value})
        end
    end
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    local maxBarWidth = 400
    
    for i, mech in ipairs(sortedMechanics) do
        -- Mechanic card
        local mechCard = CreateFrame("Frame", nil, content.child)
        mechCard:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        mechCard:SetSize(530, 35)
        
        local cardBG = mechCard:CreateTexture(nil, "BACKGROUND")
        cardBG:SetAllPoints()
        cardBG:SetColorTexture(0.1, 0.1, 0.1, 0.6)
        
        -- Mechanic name
        local mechName = mechCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        mechName:SetPoint("LEFT", mechCard, "LEFT", 10, 8)
        mechName:SetText(self:FormatMechanicName(mech.name))
        
        -- Importance bar
        local barBG = CreateFrame("Frame", nil, mechCard)
        barBG:SetPoint("LEFT", mechCard, "LEFT", 10, -8)
        barBG:SetSize(maxBarWidth, 8)
        local bgTex = barBG:CreateTexture(nil, "BACKGROUND")
        bgTex:SetAllPoints()
        bgTex:SetColorTexture(0.3, 0.3, 0.3, 0.8)
        
        local barWidth = (mech.value / 100) * maxBarWidth
        local bar = CreateFrame("Frame", nil, mechCard)
        bar:SetPoint("LEFT", barBG, "LEFT", 0, 0)
        bar:SetSize(barWidth, 8)
        
        local barTex = bar:CreateTexture(nil, "ARTWORK")
        barTex:SetAllPoints()
        
        -- Color gradient based on importance
        if mech.value >= 90 then
            barTex:SetColorTexture(1, 0.2, 0.2, 0.9) -- Red for critical
        elseif mech.value >= 80 then
            barTex:SetColorTexture(1, 0.6, 0, 0.9) -- Orange for high
        elseif mech.value >= 70 then
            barTex:SetColorTexture(1, 1, 0, 0.9) -- Yellow for moderate
        elseif mech.value >= 60 then
            barTex:SetColorTexture(0.6, 1, 0.2, 0.9) -- Yellow-green for useful
        else
            barTex:SetColorTexture(0.4, 0.8, 1, 0.9) -- Blue for minor
        end
        
        -- Value text with description
        local valueText = mechCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", mechCard, "RIGHT", -10, 0)
        
        local importanceLevel = ""
        if mech.value >= 90 then
            importanceLevel = "CRITICAL"
        elseif mech.value >= 80 then
            importanceLevel = "High"
        elseif mech.value >= 70 then
            importanceLevel = "Moderate"
        elseif mech.value >= 60 then
            importanceLevel = "Useful"
        else
            importanceLevel = "Minor"
        end
        
        valueText:SetText(mech.value .. "% - " .. importanceLevel)
        
        table.insert(content.elements, mechCard)
        yOffset = yOffset - 40
        
        if yOffset < -400 then
            content.child:SetHeight(-yOffset + 50)
        end
    end
end

-- Clear tab content helper
function MatchCreator:ClearTabContent(tabIndex)
    local content = MatchCreatorFrame.tabContents[tabIndex]
    if content.elements then
        for _, element in pairs(content.elements) do
            if element and element.Hide then
                element:Hide()
            end
        end
    end
    content.elements = {}
end

-- Show error message in tab
function MatchCreator:ShowTabError(tabIndex, message)
    local content = MatchCreatorFrame.tabContents[tabIndex]
    self:ClearTabContent(tabIndex)
    
    local errorText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    errorText:SetPoint("CENTER", content.child, "CENTER")
    errorText:SetText("|cFFFF6666" .. message .. "|r")
    table.insert(content.elements, errorText)
end

-- Get top spec from role recommendations
function MatchCreator:GetTopSpec(roleSpecs)
    local topSpec = nil
    local topRating = 0
    
    for spec, rating in pairs(roleSpecs) do
        if rating > topRating then
            topRating = rating
            topSpec = {spec = spec, rating = rating}
        end
    end
    
    return topSpec
end-- Match Creator Addon - Clean Working Version
-- TOC: ## Interface: 100200
-- TOC: ## Title: Match Creator
-- TOC: ## Notes: Advanced dungeon group composition analyzer
-- TOC: ## Author: YourName
-- TOC: ## Version: 1.0.0

MatchCreator = {}

-- Initialize core data structures
function MatchCreator:Initialize()
    -- Extended dungeon database with boss breakdowns
    self.dungeonData = {
        ["Mists of Tirna Scithe"] = {
            mechanics = {
                parry = 75,
                dodge = 60,
                block = 45,
                magicDefense = 85,
                physicalDefense = 40,
                aoeReduction = 90,
                dispel = 80,
                interrupt = 70,
                mobility = 75,
                enrageRemoval = 0,
                stunBreak = 60,
                immunity = 50,
                positioning = 80,
                crowdControl = 65,
                rangedAdvantage = 70
            },
            bosses = {
                ["Ingra Maloch"] = {
                    mechanics = {magicDefense = 90, aoeReduction = 85, mobility = 60},
                    tips = "High nature damage throughout. Spread for Droman's Wrath. Tank kites during Spirit Bolt channel.",
                    difficulty = "Moderate"
                },
                ["Mistcaller"] = {
                    mechanics = {dispel = 95, interrupt = 80, mobility = 85},
                    tips = "Dispel Freeze Tag immediately. Dodge guessing game mechanics. Interrupt Bramblethorn Coat on adds.",
                    difficulty = "High"
                },
                ["Tred'ova"] = {
                    mechanics = {parry = 90, aoeReduction = 95, mobility = 70, stunBreak = 80},
                    tips = "Tank faces boss away for Accelerated Incubation. Break cocoons quickly. Dispel mind control effects.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,
                    ["Death Knight_Blood"] = 85,
                    ["Monk_Brewmaster"] = 80,
                    ["Paladin_Protection"] = 75,
                    ["Warrior_Protection"] = 65,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Priest_Discipline"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Druid_Restoration"] = 80,
                    ["Monk_Mistweaver"] = 75,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75,
                    ["Evoker_Preservation"] = 85
                },
                dps = {
                    ["Mage_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 90,
                    ["Rogue_Any"] = 75,
                    ["Warlock_Any"] = 70,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Elemental"] = 80,
                    ["Druid_Balance"] = 80
                }
            }
        },
        
        ["The Necrotic Wake"] = {
            mechanics = {
                parry = 60,
                dodge = 55,
                block = 70,
                magicDefense = 60,
                physicalDefense = 80,
                aoeReduction = 75,
                dispel = 90,
                interrupt = 85,
                mobility = 50,
                enrageRemoval = 0,
                fearResist = 70,
                hookAvoidance = 85,
                diseaseResist = 80,
                positioning = 60,
                crowdControl = 70
            },
            bosses = {
                ["Blightbone"] = {
                    mechanics = {physicalDefense = 85, aoeReduction = 70, hookAvoidance = 90},
                    tips = "Avoid Heaving Retch frontal. Dodge Fetid Gas clouds. Interrupt Crunch to reduce tank damage.",
                    difficulty = "Low"
                },
                ["Amarth the Harvester"] = {
                    mechanics = {fearResist = 90, interrupt = 80, aoeReduction = 75},
                    tips = "Fear immunity/breaks crucial. Interrupt Land of the Dead. Stack loosely for Final Harvest.",
                    difficulty = "High"
                },
                ["Surgeon Stitchflesh"] = {
                    mechanics = {hookAvoidance = 95, mobility = 80, interrupt = 85},
                    tips = "Avoid meat hooks at all costs. Interrupt Stitchneedle. Position away from Embalming Ichor.",
                    difficulty = "Moderate"
                },
                ["Nalthor the Rimebinder"] = {
                    mechanics = {dispel = 95, mobility = 70, magicDefense = 85},
                    tips = "Dispel Icebound Aegis immediately. Avoid Comet Storm paths. Move out of Blizzard zones.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,
                    ["Death Knight_Blood"] = 95,
                    ["Paladin_Protection"] = 85,
                    ["Demon Hunter_Vengeance"] = 70,
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Priest_Holy"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Paladin_Holy"] = 80,
                    ["Druid_Restoration"] = 75,
                    ["Monk_Mistweaver"] = 70,
                    ["Priest_Discipline"] = 80,
                    ["Evoker_Preservation"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 85,
                    ["Mage_Any"] = 80,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Any"] = 80,
                    ["Warlock_Any"] = 75,
                    ["Death Knight_Any"] = 85,
                    ["Paladin_Retribution"] = 80
                }
            }
        },

        ["Siege of Boralus"] = {
            mechanics = {
                parry = 70,
                dodge = 65,
                block = 75,
                magicDefense = 70,
                physicalDefense = 85,
                aoeReduction = 80,
                dispel = 75,
                interrupt = 95,
                mobility = 85,
                enrageRemoval = 0,
                knockbackResist = 80,
                positioning = 90,
                rangedAdvantage = 85,
                crowdControl = 60
            },
            bosses = {
                ["Sergeant Bainbridge"] = {
                    mechanics = {interrupt = 95, mobility = 80, aoeReduction = 75},
                    tips = "Interrupt Heavy Ordnance (priority). Move out of Wildfire patches. Stack for healing during adds.",
                    difficulty = "Moderate"
                },
                ["Dread Captain Lockwood"] = {
                    mechanics = {mobility = 90, aoeReduction = 85, knockbackResist = 85},
                    tips = "Kite Eudora away from group. Avoid Cannon Barrage. Position for Crimson Swipe knockback.",
                    difficulty = "High"
                },
                ["Hadal Darkfathom"] = {
                    mechanics = {interrupt = 90, mobility = 85, magicDefense = 80},
                    tips = "Interrupt Break Water (critical). Move for Tidal Surge. Stack in Upwelling for damage buff.",
                    difficulty = "Moderate"
                },
                ["Viq'Goth"] = {
                    mechanics = {interrupt = 95, aoeReduction = 90, mobility = 75},
                    tips = "Priority interrupt Putrid Waters. Demolish adds quickly. Avoid tentacle slams.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,
                    ["Paladin_Protection"] = 85,
                    ["Death Knight_Blood"] = 80,
                    ["Demon Hunter_Vengeance"] = 85,
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Shaman_Restoration"] = 90,
                    ["Priest_Discipline"] = 85,
                    ["Evoker_Preservation"] = 85,
                    ["Monk_Mistweaver"] = 80,
                    ["Druid_Restoration"] = 75,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 90,
                    ["Mage_Any"] = 85,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Warrior_Any"] = 80,
                    ["Shaman_Any"] = 85,
                    ["Death Knight_Any"] = 80,
                    ["Monk_Windwalker"] = 85
                }
            }
        },

        ["Halls of Atonement"] = {
            mechanics = {
                parry = 80,
                dodge = 70,
                block = 50,
                magicDefense = 75,
                physicalDefense = 85,
                aoeReduction = 80,
                dispel = 60,
                interrupt = 90,
                mobility = 65,
                enrageRemoval = 0,
                reflectAvoidance = 85,
                positioning = 75,
                crowdControl = 70,
                rangedAdvantage = 60
            },
            bosses = {
                ["Halkias"] = {
                    mechanics = {aoeReduction = 90, mobility = 70, magicDefense = 80},
                    tips = "Spread for Crumbling Slam. Move for Heave Debris. Use pillars for line of sight.",
                    difficulty = "Moderate"
                },
                ["Echelon"] = {
                    mechanics = {parry = 95, mobility = 75, physicalDefense = 90},
                    tips = "NEVER attack from front during Stone Legion Heraldry. Kite during Blade Dance.",
                    difficulty = "High"
                },
                ["High Adjudicator Aleez"] = {
                    mechanics = {dispel = 80, interrupt = 95, aoeReduction = 85},
                    tips = "Interrupt Pulse from Beyond (critical). Dispel Ghastly Parabola. Avoid Anima pools.",
                    difficulty = "High"
                },
                ["Lord Chamberlain"] = {
                    mechanics = {reflectAvoidance = 90, mobility = 80, interrupt = 85},
                    tips = "Do NOT cast during Reflect phase. Dodge teleport patterns. Coordinate ritual positions.",
                    difficulty = "Moderate"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 85,
                    ["Death Knight_Blood"] = 80,
                    ["Paladin_Protection"] = 90,
                    ["Demon Hunter_Vengeance"] = 75,
                    ["Monk_Brewmaster"] = 70,
                    ["Druid_Guardian"] = 65
                },
                healer = {
                    ["Priest_Holy"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Evoker_Preservation"] = 80,
                    ["Paladin_Holy"] = 75,
                    ["Monk_Mistweaver"] = 70,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 80
                },
                dps = {
                    ["Mage_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Warrior_Any"] = 85,
                    ["Shaman_Any"] = 80,
                    ["Death Knight_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 75,
                    ["Paladin_Retribution"] = 80
                }
            }
        },

        ["Theater of Pain"] = {
            mechanics = {
                parry = 60,
                dodge = 70,
                block = 65,
                magicDefense = 80,
                physicalDefense = 75,
                aoeReduction = 85,
                dispel = 70,
                interrupt = 80,
                mobility = 90,
                enrageRemoval = 85,
                fearResist = 75,
                positioning = 95,
                crowdControl = 80,
                rangedAdvantage = 75
            },
            bosses = {
                ["An Affront of Challengers"] = {
                    mechanics = {interrupt = 85, mobility = 80, aoeReduction = 80},
                    tips = "Interrupt Necromantic Bolt. Move for Dark Stride. Focus kill order: Sathel > Paceran > Dessia.",
                    difficulty = "Moderate"
                },
                ["Gorechop"] = {
                    mechanics = {enrageRemoval = 95, mobility = 95, aoeReduction = 85},
                    tips = "Soothe/dispel Hateful Strike enrage IMMEDIATELY. Constant movement required. Dodge Tenderizing Smash.",
                    difficulty = "High"
                },
                ["Xav the Unfallen"] = {
                    mechanics = {fearResist = 90, mobility = 85, magicDefense = 85},
                    tips = "Fear immunity crucial. Dodge Seismic Leap. Position properly for Blood and Glory.",
                    difficulty = "Moderate"
                },
                ["Mordretha"] = {
                    mechanics = {mobility = 95, aoeReduction = 90, interrupt = 80},
                    tips = "Constant movement for Reap Soul. Interrupt Ghostly Charge. Dodge Death Grasp lines.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,
                    ["Monk_Brewmaster"] = 85,
                    ["Warrior_Protection"] = 80,
                    ["Death Knight_Blood"] = 75,
                    ["Paladin_Protection"] = 80,
                    ["Druid_Guardian"] = 85
                },
                healer = {
                    ["Monk_Mistweaver"] = 90,
                    ["Evoker_Preservation"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Priest_Discipline"] = 75,
                    ["Druid_Restoration"] = 85,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 95,
                    ["Druid_Any"] = 95,
                    ["Rogue_Any"] = 90,
                    ["Demon Hunter_Havoc"] = 90,
                    ["Monk_Windwalker"] = 90,
                    ["Mage_Any"] = 80,
                    ["Warrior_Any"] = 85,
                    ["Shaman_Any"] = 85
                }
            }
        },

        ["Plaguefall"] = {
            mechanics = {
                parry = 50,
                dodge = 60,
                block = 55,
                magicDefense = 85,
                physicalDefense = 60,
                aoeReduction = 90,
                dispel = 95,
                interrupt = 85,
                mobility = 75,
                enrageRemoval = 0,
                diseaseResist = 95,
                immunityPhases = 70,
                positioning = 80,
                crowdControl = 75
            },
            bosses = {
                ["Globgrog"] = {
                    mechanics = {aoeReduction = 95, mobility = 80, magicDefense = 85},
                    tips = "Stack for Beckon Slime, then spread immediately. Avoid Slime Wave. Tank positions boss carefully.",
                    difficulty = "Moderate"
                },
                ["Doctor Ickus"] = {
                    mechanics = {dispel = 95, interrupt = 90, mobility = 85},
                    tips = "Dispel diseases IMMEDIATELY. Interrupt Harvest Plague. Dodge Pestilence Bolt and potion vials.",
                    difficulty = "High"
                },
                ["Domina Venomblade"] = {
                    mechanics = {immunityPhases = 90, aoeReduction = 85, mobility = 80},
                    tips = "Kill adds during Shadow Ambush phases. Avoid Cytotoxic Slash pools. Position for adds spawns.",
                    difficulty = "Moderate"
                },
                ["Margrave Stradama"] = {
                    mechanics = {dispel = 95, aoeReduction = 90, mobility = 75},
                    tips = "Dispel Plague Crash. Avoid Infectious Rain puddles. Spread for Plague Bolt. Kill tentacles.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,
                    ["Death Knight_Blood"] = 85,
                    ["Paladin_Protection"] = 80,
                    ["Monk_Brewmaster"] = 75,
                    ["Warrior_Protection"] = 70,
                    ["Druid_Guardian"] = 75
                },
                healer = {
                    ["Priest_Holy"] = 95,
                    ["Paladin_Holy"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Evoker_Preservation"] = 80,
                    ["Monk_Mistweaver"] = 70,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 85
                },
                dps = {
                    ["Priest_Shadow"] = 90,
                    ["Paladin_Retribution"] = 85,
                    ["Mage_Any"] = 80,
                    ["Hunter_Any"] = 80,
                    ["Shaman_Any"] = 85,
                    ["Death Knight_Any"] = 85,
                    ["Demon Hunter_Havoc"] = 80
                }
            }
        },

        ["Spires of Ascension"] = {
            mechanics = {
                parry = 65,
                dodge = 70,
                block = 60,
                magicDefense = 90,
                physicalDefense = 50,
                aoeReduction = 85,
                dispel = 80,
                interrupt = 95,
                mobility = 80,
                enrageRemoval = 0,
                spellSteal = 85,
                positioning = 85,
                crowdControl = 75,
                rangedAdvantage = 80
            },
            bosses = {
                ["Kin-Tara"] = {
                    mechanics = {interrupt = 95, mobility = 85, spellSteal = 80},
                    tips = "Interrupt Charged Spear (critical). Dodge Recharge beams. Steal Motivating Presence buff.",
                    difficulty = "High"
                },
                ["Ventunax"] = {
                    mechanics = {mobility = 90, aoeReduction = 90, magicDefense = 85},
                    tips = "Constant movement for Dark Stride. Avoid Void Orbs. Spread for Dark Bolt impacts.",
                    difficulty = "High"
                },
                ["Oryphrion"] = {
                    mechanics = {spellSteal = 95, interrupt = 85, mobility = 80},
                    tips = "Steal Empyreal Ordnance (essential). Interrupt Charged Stomp. Dodge Draconic Image breath.",
                    difficulty = "Moderate"
                },
                ["Devos"] = {
                    mechanics = {interrupt = 95, mobility = 85, aoeReduction = 90},
                    tips = "Interrupt Archon's Bastion (priority). Move for Lights Judgment. Use LoS for Run Through.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,
                    ["Paladin_Protection"] = 85,
                    ["Warrior_Protection"] = 80,
                    ["Death Knight_Blood"] = 75,
                    ["Monk_Brewmaster"] = 80,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Evoker_Preservation"] = 90,
                    ["Priest_Discipline"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Paladin_Holy"] = 85,
                    ["Priest_Holy"] = 80,
                    ["Monk_Mistweaver"] = 75,
                    ["Druid_Restoration"] = 75
                },
                dps = {
                    ["Mage_Any"] = 95,
                    ["Warlock_Any"] = 85,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Warrior_Any"] = 80
                }
            }
        },

        ["De Other Side"] = {
            mechanics = {
                parry = 55,
                dodge = 60,
                block = 50,
                magicDefense = 75,
                physicalDefense = 70,
                aoeReduction = 80,
                dispel = 85,
                interrupt = 80,
                mobility = 85,
                enrageRemoval = 70,
                portalNavigation = 90,
                positioning = 85,
                crowdControl = 80,
                rangedAdvantage = 75
            },
            bosses = {
                ["Hakkar the Soulflayer"] = {
                    mechanics = {enrageRemoval = 90, dispel = 85, aoeReduction = 80},
                    tips = "Soothe Blood Barrier buff. Dispel Corrupted Blood. Spread for Piercing Barb. Kill blood adds.",
                    difficulty = "Moderate"
                },
                ["The Manastorms"] = {
                    mechanics = {interrupt = 90, mobility = 90, aoeReduction = 85},
                    tips = "Interrupt Arcane Lightning. Dodge teleport mechanics. Focus priority: Millificent > Millhouse.",
                    difficulty = "High"
                },
                ["Dealer Xy'exa"] = {
                    mechanics = {mobility = 95, portalNavigation = 95, aoeReduction = 80},
                    tips = "Navigate portals quickly. Avoid Explosive Contrivance. Position for Chains of Damnation.",
                    difficulty = "High"
                },
                ["Mueh'zala"] = {
                    mechanics = {portalNavigation = 95, mobility = 90, magicDefense = 85},
                    tips = "Master portal rotation timing. Dodge Cosmic Artifice. Avoid Master of Death damage zones.",
                    difficulty = "High"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Monk_Brewmaster"] = 90,
                    ["Demon Hunter_Vengeance"] = 85,
                    ["Warrior_Protection"] = 75,
                    ["Death Knight_Blood"] = 70,
                    ["Paladin_Protection"] = 80,
                    ["Druid_Guardian"] = 85
                },
                healer = {
                    ["Monk_Mistweaver"] = 95,
                    ["Evoker_Preservation"] = 90,
                    ["Shaman_Restoration"] = 80,
                    ["Druid_Restoration"] = 85,
                    ["Priest_Discipline"] = 75,
                    ["Priest_Holy"] = 75,
                    ["Paladin_Holy"] = 70
                },
                dps = {
                    ["Hunter_Any"] = 90,
                    ["Druid_Any"] = 90,
                    ["Monk_Windwalker"] = 95,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Rogue_Any"] = 80,
                    ["Mage_Any"] = 75,
                    ["Warrior_Any"] = 75,
                    ["Death Knight_Any"] = 70
                }
            }
        }
    }
    
    -- Initialize Class Spec Utilities Database
    self:InitializeClassUtilities()
    
    -- Initialize Affix System
    self:InitializeAffixData()
    
    print("|cFF00FF00Match Creator:|r Phase 1B loaded - " .. self:CountDungeons() .. " dungeons with boss data!")
end
        ["Mists of Tirna Scithe"] = {
            mechanics = {
                parry = 75,
                dodge = 60,
                block = 45,
                magicDefense = 85,
                physicalDefense = 40,
                aoeReduction = 90,
                dispel = 80,
                interrupt = 70,
                mobility = 75,
                enrageRemoval = 0,
                stunBreak = 60,
                immunity = 50,
                positioning = 80,
                crowdControl = 65,
                rangedAdvantage = 70
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,
                    ["Death Knight_Blood"] = 85,
                    ["Monk_Brewmaster"] = 80,
                    ["Paladin_Protection"] = 75,
                    ["Warrior_Protection"] = 65,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Priest_Discipline"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Druid_Restoration"] = 80,
                    ["Monk_Mistweaver"] = 75,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75,
                    ["Evoker_Preservation"] = 85
                },
                dps = {
                    ["Mage_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 90,
                    ["Rogue_Any"] = 75,
                    ["Warlock_Any"] = 70,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Elemental"] = 80,
                    ["Druid_Balance"] = 80
                }
            }
        },
        
        ["The Necrotic Wake"] = {
            mechanics = {
                parry = 60,
                dodge = 55,
                block = 70,
                magicDefense = 60,
                physicalDefense = 80,
                aoeReduction = 75,
                dispel = 90,
                interrupt = 85,
                mobility = 50,
                enrageRemoval = 0,
                fearResist = 70,
                hookAvoidance = 85,
                diseaseResist = 80,
                positioning = 60,
                crowdControl = 70
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,
                    ["Death Knight_Blood"] = 95,
                    ["Paladin_Protection"] = 85,
                    ["Demon Hunter_Vengeance"] = 70,
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Priest_Holy"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Paladin_Holy"] = 80,
                    ["Druid_Restoration"] = 75,
                    ["Monk_Mistweaver"] = 70,
                    ["Priest_Discipline"] = 80,
                    ["Evoker_Preservation"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 85,
                    ["Mage_Any"] = 80,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Any"] = 80,
                    ["Warlock_Any"] = 75,
                    ["Death Knight_Any"] = 85,
                    ["Paladin_Retribution"] = 80
                }
            }
        },

        ["Siege of Boralus"] = {
            mechanics = {
                parry = 70,
                dodge = 65,
                block = 75,
                magicDefense = 70,
                physicalDefense = 85,
                aoeReduction = 80,
                dispel = 75,
                interrupt = 95,
                mobility = 85,
                enrageRemoval = 0,
                knockbackResist = 80,
                positioning = 90,
                rangedAdvantage = 85,
                crowdControl = 60
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,
                    ["Paladin_Protection"] = 85,
                    ["Death Knight_Blood"] = 80,
                    ["Demon Hunter_Vengeance"] = 85,
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Shaman_Restoration"] = 90,
                    ["Priest_Discipline"] = 85,
                    ["Evoker_Preservation"] = 85,
                    ["Monk_Mistweaver"] = 80,
                    ["Druid_Restoration"] = 75,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 90,
                    ["Mage_Any"] = 85,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Warrior_Any"] = 80,
                    ["Shaman_Any"] = 85,
                    ["Death Knight_Any"] = 80,
                    ["Monk_Windwalker"] = 85
                }
            }
        },

        ["Halls of Atonement"] = {
            mechanics = {
                parry = 80,
                dodge = 70,
                block = 50,
                magicDefense = 75,
                physicalDefense = 85,
                aoeReduction = 80,
                dispel = 60,
                interrupt = 90,
                mobility = 65,
                enrageRemoval = 0,
                reflectAvoidance = 85,
                positioning = 75,
                crowdControl = 70,
                rangedAdvantage = 60
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 85,
                    ["Death Knight_Blood"] = 80,
                    ["Paladin_Protection"] = 90,
                    ["Demon Hunter_Vengeance"] = 75,
                    ["Monk_Brewmaster"] = 70,
                    ["Druid_Guardian"] = 65
                },
                healer = {
                    ["Priest_Holy"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Evoker_Preservation"] = 80,
                    ["Paladin_Holy"] = 75,
                    ["Monk_Mistweaver"] = 70,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 80
                },
                dps = {
                    ["Mage_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Warrior_Any"] = 85,
                    ["Shaman_Any"] = 80,
                    ["Death Knight_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 75,
                    ["Paladin_Retribution"] = 80
                }
            }
        },

        ["Theater of Pain"] = {
            mechanics = {
                parry = 60,
                dodge = 70,
                block = 65,
                magicDefense = 80,
                physicalDefense = 75,
                aoeReduction = 85,
                dispel = 70,
                interrupt = 80,
                mobility = 90,
                enrageRemoval = 85,
                fearResist = 75,
                positioning = 95,
                crowdControl = 80,
                rangedAdvantage = 75
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,
                    ["Monk_Brewmaster"] = 85,
                    ["Warrior_Protection"] = 80,
                    ["Death Knight_Blood"] = 75,
                    ["Paladin_Protection"] = 80,
                    ["Druid_Guardian"] = 85
                },
                healer = {
                    ["Monk_Mistweaver"] = 90,
                    ["Evoker_Preservation"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Priest_Discipline"] = 75,
                    ["Druid_Restoration"] = 85,
                    ["Paladin_Holy"] = 70,
                    ["Priest_Holy"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 95,
                    ["Druid_Any"] = 95,
                    ["Rogue_Any"] = 90,
                    ["Demon Hunter_Havoc"] = 90,
                    ["Monk_Windwalker"] = 90,
                    ["Mage_Any"] = 80,
                    ["Warrior_Any"] = 85,
                    ["Shaman_Any"] = 85
                }
            }
        },

        ["Plaguefall"] = {
            mechanics = {
                parry = 50,
                dodge = 60,
                block = 55,
                magicDefense = 85,
                physicalDefense = 60,
                aoeReduction = 90,
                dispel = 95,
                interrupt = 85,
                mobility = 75,
                enrageRemoval = 0,
                diseaseResist = 95,
                immunityPhases = 70,
                positioning = 80,
                crowdControl = 75
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,
                    ["Death Knight_Blood"] = 85,
                    ["Paladin_Protection"] = 80,
                    ["Monk_Brewmaster"] = 75,
                    ["Warrior_Protection"] = 70,
                    ["Druid_Guardian"] = 75
                },
                healer = {
                    ["Priest_Holy"] = 95,
                    ["Paladin_Holy"] = 90,
                    ["Shaman_Restoration"] = 85,
                    ["Evoker_Preservation"] = 80,
                    ["Monk_Mistweaver"] = 70,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 85
                },
                dps = {
                    ["Priest_Shadow"] = 90,
                    ["Paladin_Retribution"] = 85,
                    ["Mage_Any"] = 80,
                    ["Hunter_Any"] = 80,
                    ["Shaman_Any"] = 85,
                    ["Death Knight_Any"] = 85,
                    ["Demon Hunter_Havoc"] = 80
                }
            }
        },

        ["Spires of Ascension"] = {
            mechanics = {
                parry = 65,
                dodge = 70,
                block = 60,
                magicDefense = 90,
                physicalDefense = 50,
                aoeReduction = 85,
                dispel = 80,
                interrupt = 95,
                mobility = 80,
                enrageRemoval = 0,
                spellSteal = 85,
                positioning = 85,
                crowdControl = 75,
                rangedAdvantage = 80
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,
                    ["Paladin_Protection"] = 85,
                    ["Warrior_Protection"] = 80,
                    ["Death Knight_Blood"] = 75,
                    ["Monk_Brewmaster"] = 80,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Evoker_Preservation"] = 90,
                    ["Priest_Discipline"] = 85,
                    ["Shaman_Restoration"] = 80,
                    ["Paladin_Holy"] = 85,
                    ["Priest_Holy"] = 80,
                    ["Monk_Mistweaver"] = 75,
                    ["Druid_Restoration"] = 75
                },
                dps = {
                    ["Mage_Any"] = 95,
                    ["Warlock_Any"] = 85,
                    ["Priest_Shadow"] = 85,
                    ["Shaman_Any"] = 85,
                    ["Hunter_Any"] = 80,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Warrior_Any"] = 80
                }
            }
        },

        ["De Other Side"] = {
            mechanics = {
                parry = 55,
                dodge = 60,
                block = 50,
                magicDefense = 75,
                physicalDefense = 70,
                aoeReduction = 80,
                dispel = 85,
                interrupt = 80,
                mobility = 85,
                enrageRemoval = 70,
                portalNavigation = 90,
                positioning = 85,
                crowdControl = 80,
                rangedAdvantage = 75
            },
            preferredSpecs = {
                tank = {
                    ["Monk_Brewmaster"] = 90,
                    ["Demon Hunter_Vengeance"] = 85,
                    ["Warrior_Protection"] = 75,
                    ["Death Knight_Blood"] = 70,
                    ["Paladin_Protection"] = 80,
                    ["Druid_Guardian"] = 85
                },
                healer = {
                    ["Monk_Mistweaver"] = 95,
                    ["Evoker_Preservation"] = 90,
                    ["Shaman_Restoration"] = 80,
                    ["Druid_Restoration"] = 85,
                    ["Priest_Discipline"] = 75,
                    ["Priest_Holy"] = 75,
                    ["Paladin_Holy"] = 70
                },
                dps = {
                    ["Hunter_Any"] = 90,
                    ["Druid_Any"] = 90,
                    ["Monk_Windwalker"] = 95,
                    ["Demon Hunter_Havoc"] = 85,
                    ["Rogue_Any"] = 80,
                    ["Mage_Any"] = 75,
                    ["Warrior_Any"] = 75,
                    ["Death Knight_Any"] = 70
                }
            }
        }
    }
    
    print("|cFF00FF00Match Creator:|r Initialized with " .. self:CountDungeons() .. " dungeons!")
end

-- Count dungeons for confirmation
function MatchCreator:CountDungeons()
    local count = 0
    for _ in pairs(self.dungeonData) do
        count = count + 1
    end
    return count
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
