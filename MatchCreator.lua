-- Enhanced slash commands with UI controls
SLASH_MATCHCREATOR1 = "/matchcreator"
SLASH_MATCHCREATOR2 = "/mc"
SlashCmdList["MATCHCREATOR"] = function(msg)
    local args = {strsplit(" ", msg)}
    local cmd = args[1] and string.lower(args[1]) or ""
    
    if cmd == "show" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Show()
            if MatchCreatorFrame.positionHook then
                MatchCreatorFrame.positionHook()
            end
        else
            MatchCreator:CreateRecommendationFrame()
            MatchCreatorFrame:Show()
        end
        MatchCreator:RefreshTabContent(MatchCreatorFrame.activeTab or 1)
        
    elseif cmd == "hide" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Hide()
        end
        
    elseif cmd == "toggle" then
        if MatchCreatorFrame then
            if MatchCreatorFrame:IsShown() then
                MatchCreatorFrame:Hide()
            else
                MatchCreatorFrame:Show()
                if MatchCreatorFrame.positionHook then
                    MatchCreatorFrame.positionHook()
                end
                MatchCreator:RefreshTabContent(MatchCreatorFrame.activeTab or 1)
            end
        else
            MatchCreator:CreateRecommendationFrame()
            MatchCreatorFrame:Show()
        end
        
    elseif cmd == "test" then
        -- Test with multiple dungeons
        local testDungeon = args[2] or "Mists of Tirna Scithe"
        local recommendations = MatchCreator:GetDungeonRecommendations(testDungeon)
        if recommendations then
            if not MatchCreatorFrame then
                MatchCreator:CreateRecommendationFrame()
            end
            MatchCreator:RefreshTabContent(MatchCreatorFrame.activeTab or 1)
            MatchCreatorFrame:Show()
            print("|cFF00FF00Match Creator:|r Testing with " .. testDungeon)
        else
            print("|cFFFF0000Error:|r Dungeon not found: " .. testDungeon)
        end
        
    elseif cmd == "tab" then
        local tab-- Enhanced boss encounter analysis
function MatchCreator:GetBossAnalysis(dungeonName, bossName)
    local dungeonData = self.dungeonData[dungeonName]
    if not dungeonData or not dungeonData.bosses then
        return nil
    end
    
    local boss = dungeonData.bosses[bossName]
    if not boss then
        return nil
    end
    
    return {
        mechanics = boss.mechanics,
        tips = boss.tips,
        difficulty = self:CalculateBossDifficulty(boss.mechanics),
        recommendations = self:GetBossSpecificRecommendations(dungeonName, boss.mechanics)
    }
end

-- Calculate boss difficulty based on mechanics
function MatchCreator:CalculateBossDifficulty(mechanics)
    local totalDifficulty = 0
    local mechanicCount = 0
    
    for _, value in pairs(mechanics) do
        totalDifficulty = totalDifficulty + value
        mechanicCount = mechanicCount + 1
    end
    
    if mechanicCount == 0 then return 0 end
    
    local avgDifficulty = totalDifficulty / mechanicCount
    
    if avgDifficulty >= 90 then
        return "Extreme"
    elseif avgDifficulty >= 80 then
        return "High"
    elseif avgDifficulty >= 70 then
        return "Moderate"
    elseif avgDifficulty >= 60 then
        return "Low"
    else
        return "Minimal"
    end
end

-- Get boss-specific recommendations
function MatchCreator:GetBossSpecificRecommendations(dungeonName, bossMechanics)
    local dungeonData = self.dungeonData[dungeonName]
    if not dungeonData then return {} end
    
    local recommendations = {}
    
    -- Analyze which specs excel at this boss's specific mechanics
    for role, specs in pairs(dungeonData.preferredSpecs) do
        recommendations[role] = {}
        for specName, baseScore in pairs(specs) do
            local adjustedScore = baseScore
            
            -- Adjust score based on boss-specific mechanics
            for mechanic, importance in pairs(bossMechanics) do
                local specBonus = self:GetSpecMechanicBonus(specName, mechanic)
                adjustedScore = adjustedScore + (specBonus * importance / 100 * 0.2) -- 20% weight to boss specifics
            end
            
            recommendations[role][specName] = math.min(100, math.max(0, adjustedScore))
        end
    end
    
    return recommendations
end

-- Get spec-specific bonuses for mechanics
function MatchCreator:GetSpecMechanicBonus(specName, mechanic)
    local bonuses = {
        -- Mobility bonuses
        ["Demon Hunter_Havoc"] = {mobility = 15, magicDefense = 10},
        ["Demon Hunter_Vengeance"] = {mobility = 15, magicDefense = 15},
        ["Monk_Windwalker"] = {mobility = 20, enrageRemoval = 5},
        ["Monk_Brewmaster"] = {mobility = 15, magicDefense = 10},
        ["Monk_Mistweaver"] = {mobility = 18, dispel = 8},
        ["Hunter_Any"] = {mobility = 12, enrageRemoval = 15, interrupt = 8},
        ["Druid_Any"] = {mobility = 10, enrageRemoval = 20, dispel = 12},
        
        -- Defense bonuses
        ["Warrior_Protection"] = {physicalDefense = 20, block = 15, parry = 10},
        ["Death Knight_Blood"] = {magicDefense = 8, physicalDefense = 12, dispel = -5},
        ["Paladin_Protection"] = {magicDefense = 12, physicalDefense = 12, dispel = 15},
        
        -- Utility bonuses
        ["Mage_Any"] = {spellSteal = 20, interrupt = 12, dispel = 10, magicDefense = 8},
        ["Priest_Holy"] = {dispel = 20, magicDefense = 8},
        ["Priest_Shadow"] = {dispel = 15, magicDefense = 10},
        ["Shaman_Any"] = {dispel = 15, interrupt = 10, windResistance = 15},
        ["Evoker_Any"] = {magicDefense = 15, mobility = 10, dispel = 12}
    }
    
    local specBonuses = bonuses[specName] or {}
    return specBonuses[mechanic] or 0
end

-- Enhanced recommendation display with boss breakdown
function MatchCreator:UpdateRecommendationFrame(recommendations, selectedBoss)
    if not MatchCreatorFrame then return end
    
    -- Clear existing content
    local content = MatchCreatorFrame.contentChild
    if content.textElements then
        for _, element in pairs(content.textElements) do
            element:Hide()
        end
    end
    content.textElements = {}
    
    local yOffset = -10
    
    -- Display dungeon overview
    local dungeonTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dungeonTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
    dungeonTitle:SetText("|cFFFFD700Dungeon Analysis:|r")
    table.insert(content.textElements, dungeonTitle)
    yOffset = yOffset - 25
    
    -- Display mechanics summary
    local mechanicsTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mechanicsTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
    mechanicsTitle:SetText("|cFFFFAA00Key Mechanics:|r")
    table.insert(content.textElements, mechanicsTitle)
    yOffset = yOffset - 20
    
    for mechanic, value in pairs(recommendations.summary) do
        local mechanicText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        mechanicText:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
        local color = value >= 80 and "|cFFFF4444" or value >= 60 and "|cFFFFAA00" or "|cFFFFFFFF"
        mechanicText:SetText(string.format("%s%s: %d%%|r", color, self:FormatMechanicName(mechanic), value))
        table.insert(content.textElements, mechanicText)
        yOffset = yOffset - 18
    end
    
    yOffset = yOffset - 10
    
    -- Display top recommendations by role
    local roleOrder = {"tank", "healer", "dps"}
    local roleNames = {tank = "Tanks", healer = "Healers", dps = "DPS"}
    local roleColors = {tank = "|cFF1E90FF", healer = "|cFF32CD32", dps = "|cFFFF6347"}
    
    for _, role in ipairs(roleOrder) do
        if recommendations.recommendations[role] then
            local roleTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            roleTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
            roleTitle:SetText(roleColors[role] .. "Top " .. roleNames[role] .. ":|r")
            table.insert(content.textElements, roleTitle)
            yOffset = yOffset - 18
            
            -- Sort specs by rating
            local sortedSpecs = {}
            for spec, rating in pairs(recommendations.recommendations[role]) do
                table.insert(sortedSpecs, {spec = spec, rating = rating})
            end
            table.sort(sortedSpecs, function(a, b) return a.rating > b.rating end)
            
            -- Show top 3 specs for this role
            for i = 1, math.min(3, #sortedSpecs) do
                local spec = sortedSpecs[i]
                local specText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                specText:SetPoint("TOPLEFT", content, "TOPLEFT", 30, yOffset)
                local ratingColor = spec.rating >= 90 and "|cFF00FF00" or spec.rating >= 80 and "|cFFFFAA00" or "|cFFFFFFFF"
                local formattedSpec = string.gsub(spec.spec, "_", " - ")
                specText:SetText(string.format("%s%d%%. %s|r", ratingColor, spec.rating, formattedSpec))
                table.insert(content.textElements, specText)
                yOffset = yOffset - 16
            end
            
            yOffset = yOffset - 5
        end
    end
    
    -- Add boss-specific analysis if selected
    if selectedBoss then
        yOffset = yOffset - 10
        local bossTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        bossTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
        bossTitle:SetText("|cFFFF69B4Boss Focus: " .. selectedBoss .. "|r")
        table.insert(content.textElements, bossTitle)
        yOffset = yOffset - 18
        
        -- Show boss-specific tip
        local currentDungeon = self:GetCurrentDungeon() -- This would be implemented to get current selection
        if currentDungeon then
            local bossAnalysis = self:GetBossAnalysis(currentDungeon, selectedBoss)
            if bossAnalysis and bossAnalysis.tips then
                local tipText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                tipText:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
                tipText:SetWidth(340)
                tipText:SetText("|cFFCCCCCC" .. bossAnalysis.tips .. "|r")
                tipText:SetJustifyH("LEFT")
                table.insert(content.textElements, tipText)
                yOffset = yOffset - (tipText:GetStringHeight() + 5)
            end
        end
    end
    
    -- Adjust frame size based on content
    local contentHeight = math.abs(yOffset) + 20
    MatchCreatorFrame:SetHeight(math.min(600, math.max(300, contentHeight + 60)))
    
    MatchCreatorFrame:Show()
end

-- Get current dungeon (placeholder - would integrate with Blizzard API)
function MatchCreator:GetCurrentDungeon()
    -- This would hook into the actual LFG system
    -- For testing, return a default dungeon
    return "Mists of Tirna Scithe"
end

-- Enhanced class data with more detailed utility information
function MatchCreator:InitializeClassData()
    self.classSpecs = {
        ["Death Knight"] = {
            specs = {"Blood", "Frost", "Unholy"},
            utilities = {
                Blood = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "low",
                    fearImmunity = true,
                    diseaseImmunity = true,
                    gripUtility = true,
                    selfHeal = "excellent"
                },
                Frost = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    fearImmunity = true,
                    diseaseImmunity = true,
                    gripUtility = true,
                    burstDamage = "high"
                },
                Unholy = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    fearImmunity = true,
                    diseaseImmunity = true,
                    gripUtility = true,
                    spreadDamage = "excellent"
                }
            }
        },
        ["Demon Hunter"] = {
            specs = {"Havoc", "Vengeance"},
            utilities = {
                Havoc = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    magicDefense = "high",
                    burstDamage = "high",
                    aoeStun = true
                },
                Vengeance = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    magicDefense = "excellent",
                    selfHeal = "good",
                    aoeStun = true
                }
            }
        },
        ["Druid"] = {
            specs = {"Balance", "Feral", "Guardian", "Restoration"},
            utilities = {
                Balance = {
                    interrupt = false, 
                    dispel = true, 
                    enrageRemoval = true, 
                    mobility = "medium",
                    versatility = "high",
                    rangedDPS = "high",
                    offHealing = "good"
                },
                Feral = {
                    interrupt = false, 
                    dispel = false, 
                    enrageRemoval = true, 
                    mobility = "high",
                    stealthUtility = true,
                    burstDamage = "high",
                    survivability = "good"
                },
                Guardian = {
                    interrupt = false, 
                    dispel = false, 
                    enrageRemoval = true, 
                    mobility = "medium",
                    versatility = "high",
                    selfHeal = "excellent",
                    massGrip = true
                },
                Restoration = {
                    interrupt = false, 
                    dispel = true, 
                    enrageRemoval = true, 
                    mobility = "medium",
                    healOverTime = "excellent",
                    emergencyHealing = "good",
                    battleRes = true
                }
            }
        },
        ["Evoker"] = {
            specs = {"Devastation", "Preservation"},
            utilities = {
                Devastation = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "high",
                    magicDamage = "excellent",
                    rangedDPS = "high",
                    utility = "high",
                    dragonflightSynergy = true
                },
                Preservation = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "high",
                    healingPower = "excellent",
                    emergencyHealing = "excellent",
                    utility = "excellent",
                    dragonflightSynergy = true
                }
            }
        },
        ["Hunter"] = {
            specs = {"Beast Mastery", "Marksmanship", "Survival"},
            utilities = {
                ["Beast Mastery"] = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = true, 
                    mobility = "excellent",
                    petUtility = "excellent",
                    rangedDPS = "high",
                    soothePet = true,
                    battleRes = true
                },
                Marksmanship = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "good",
                    rangedDPS = "excellent",
                    burstDamage = "excellent",
                    executePhase = "excellent"
                },
                Survival = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "high",
                    meleeDPS = "high",
                    trapUtility = "good",
                    survivability = "excellent"
                }
            }
        },
        ["Mage"] = {
            specs = {"Arcane", "Fire", "Frost"},
            utilities = {
                Arcane = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    spellSteal = true,
                    burstDamage = "excellent",
                    arcaneIntellect = true,
                    timeWarp = true
                },
                Fire = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    spellSteal = true,
                    spreadDamage = "excellent",
                    fireImmunity = true,
                    timeWarp = true
                },
                Frost = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    spellSteal = true,
                    crowdControl = "excellent",
                    frostImmunity = true,
                    timeWarp = true
                }
            }
        },
        ["Monk"] = {
            specs = {"Brewmaster", "Mistweaver", "Windwalker"},
            utilities = {
                Brewmaster = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    staggerMechanic = true,
                    magicDefense = "good",
                    ringOfPeace = true
                },
                Mistweaver = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    healingPower = "excellent",
                    emergencyHealing = "good",
                    revival = true
                },
                Windwalker = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    burstDamage = "high",
                    spreadDamage = "good",
                    touchOfDeath = true
                }
            }
        },
        ["Paladin"] = {
            specs = {"Holy", "Protection", "Retribution"},
            utilities = {
                Holy = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    healingPower = "excellent",
                    fearImmunity = true,
                    blessingUtility = true,
                    layOnHands = true
                },
                Protection = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    magicDefense = "good",
                    fearImmunity = true,
                    blessingUtility = true,
                    consecration = true
                },
                Retribution = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    burstDamage = "high",
                    fearImmunity = true,
                    blessingUtility = true,
                    cleanseUtility = true
                }
            }
        },
        ["Priest"] = {
            specs = {"Discipline", "Holy", "Shadow"},
            utilities = {
                Discipline = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    absorbs = "excellent",
                    preventativeCare = "excellent",
                    powerWordBarrier = true,
                    massDispel = true
                },
                Holy = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    healingPower = "excellent",
                    emergencyHealing = "excellent",
                    fearWard = true,
                    guardianSpirit = true
                },
                Shadow = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    sustainedDPS = "excellent",
                    executeDamage = "good",
                    massDispel = true,
                    psychicScream = true
                }
            }
        },
        ["Rogue"] = {
            specs = {"Assassination", "Outlaw", "Subtlety"},
            utilities = {
                Assassination = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "high",
                    stealthUtility = true,
                    poisonImmunity = true,
                    stunUtility = "excellent",
                    shroudOfConcealment = true
                },
                Outlaw = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    stealthUtility = true,
                    stunUtility = "excellent",
                    tricksOfTrade = true,
                    shroudOfConcealment = true
                },
                Subtlety = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "excellent",
                    stealthUtility = true,
                    burstDamage = "excellent",
                    stunUtility = "excellent",
                    shroudOfConcealment = true
                }
            }
        },
        ["Shaman"] = {
            specs = {"Elemental", "Enhancement", "Restoration"},
            utilities = {
                Elemental = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    rangedDPS = "high",
                    earthElemental = true,
                    windShear = true,
                    tremor = true
                },
                Enhancement = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "high",
                    burstDamage = "high",
                    windShear = true,
                    tremor = true,
                    offHealing = "good"
                },
                Restoration = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    healingPower = "excellent",
                    chainHeal = true,
                    spiritLink = true,
                    tremor = true
                }
            }
        },
        ["Warlock"] = {
            specs = {"Affliction", "Demonology", "Destruction"},
            utilities = {
                Affliction = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    sustainedDPS = "excellent",
                    spreadDamage = "excellent",
                    soulstone = true,
                    fearUtility = true
                },
                Demonology = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    petUtility = "good",
                    burstDamage = "high",
                    soulstone = true,
                    demonGate = true
                },
                Destruction = {
                    interrupt = true, 
                    dispel = true, 
                    enrageRemoval = false, 
                    mobility = "low",
                    burstDamage = "excellent",
                    fireImmunity = true,
                    soulstone = true,
                    havoc = true
                }
            }
        },
        ["Warrior"] = {
            specs = {"Arms", "Fury", "Protection"},
            utilities = {
                Arms = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    executePhase = "excellent",
                    spellReflect = true,
                    fearImmunity = true,
                    battleShout = true
                },
                Fury = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    sustainedDPS = "high",
                    spellReflect = true,
                    fearImmunity = true,
                    enrageUptime = "excellent"
                },
                Protection = {
                    interrupt = true, 
                    dispel = false, 
                    enrageRemoval = false, 
                    mobility = "medium",
                    physicalDefense = "excellent",
                    spellReflect = true,
                    fearImmunity = true,
                    shout = true
                }
            }
        }
    }
end

-- Seasonal affix integration
function MatchCreator:InitializeAffixData()
    self.affixData = {
        -- Dragonflight Season 4 Affixes
        ["Fortified"] = {
            impact = {
                interrupt = 20,     -- More important to interrupt
                aoeReduction = 15,  -- Trash hits harder
                physicalDefense = 15
            },
            description = "Non-boss enemies have 20% more health and deal 30% increased damage"
        },
        ["Tyrannical"] = {
            impact = {
                magicDefense = 15,  -- Bosses often do magic damage
                aoeReduction = 20,  -- Boss abilities hit harder
                mobility = 10       -- Boss mechanics more punishing
            },
            description = "Boss enemies have 30% more health and deal 15% increased damage"
        },
        ["Bursting"] = {
            impact = {
                aoeReduction = 25,  -- Critical for stacks
                dispel = 15,        -- Can dispel in emergencies
                healingPower = 20   -- Need strong healing
            },
            description = "When slain, non-boss enemies explode, dealing damage to nearby players. This damage increases with the number of explosions."
        },
        ["Inspiring"] = {
            impact = {
                interrupt = 30,     -- Must interrupt inspired casts
                mobility = 15,      -- Need to focus inspired mobs
                crowdControl = 20   -- CC becomes more important
            },
            description = "Some non-boss enemies have an inspiring presence, granting nearby allies immunity to crowd control effects."
        },
        ["Raging"] = {
            impact = {
                enrageRemoval = 40, -- Critical to have soothe
                kiting = 20,        -- Need to kite enraged mobs
                crowdControl = -15  -- CC becomes less effective
            },
            description = "Non-boss enemies enrage at 30% health remaining, dealing 100% increased damage until defeated."
        },
        ["Sanguine"] = {
            impact = {
                mobility = 25,      -- Must move mobs out of pools
                positioning = 20,   -- Tank positioning crucial
                aoeAbilities = -10  -- AoE can be counterproductive
            },
            description = "When slain, non-boss enemies leave behind a lingering pool of ichor that heals their allies and damages players."
        },
        ["Spiteful"] = {
            impact = {
                mobility = 30,      -- Must kite/avoid shades
                rangedDPS = 15,     -- Ranged can handle shades better
                survivability = 20  -- Need to survive shade fixation
            },
            description = "Fiery missiles bombard players, dealing damage in a small area and knocking players back."
        },
        ["Storming"] = {
            impact = {
                mobility = 25,      -- Constant movement required
                positioning = 20,   -- Good positioning reduces impact
                meleeHandicap = 15  -- Melee more affected
            },
            description = "While in combat, enemies periodically summon damaging whirlwinds."
        }
    }
end

-- Function to get current week's affixes (would integrate with game API)
function MatchCreator:GetCurrentAffixes()
    -- Placeholder - would get actual current affixes
    return {"Fortified", "Bursting", "Storming"}
end

-- Calculate affix-adjusted recommendations
function MatchCreator:GetAffixAdjustedRecommendations(dungeonName, affixes)
    local baseRecommendations = self:GetDungeonRecommendations(dungeonName)
    if not baseRecommendations or not affixes then
        return baseRecommendations
    end
    
    -- Apply affix modifiers
    for _, affixName in ipairs(affixes) do
        local affix = self.affixData[affixName]
        if affix and affix.impact then
            -- Adjust mechanic importance based on affix
            for mechanic, adjustment in pairs(affix.impact) do
                if baseRecommendations.mechanics[mechanic] then
                    baseRecommendations.mechanics[mechanic] = math.min(100, 
                        math.max(0, baseRecommendations.mechanics[mechanic] + adjustment))
                end
            end
        end
    end
    
    -- Recalculate summary and recommendations
    baseRecommendations.summary = self:GenerateSummary({mechanics = baseRecommendations.mechanics})
    baseRecommendations.affixes = affixes
    
    return baseRecommendations
end-- Match Creator Addon
-- Core framework for dungeon-specific group composition suggestions

MatchCreator = {}
MatchCreator.dungeonData = {}
MatchCreator.classSpecs = {}

-- Addon info
local addonName = "MatchCreator"
local addonVersion = "1.0.0"

-- Initialize addon
function MatchCreator:OnLoad()
    self:RegisterEvents()
    self:InitializeDungeonData()
    self:InitializeClassData()
    print("|cFF00FF00Match Creator|r loaded successfully!")
end

-- Event handling
function MatchCreator:RegisterEvents()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "ADDON_LOADED" and ... == addonName then
            MatchCreator:OnLoad()
        elseif event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
            MatchCreator:OnGroupFinderUpdate()
        end
    end)
end

-- Dungeon data structure with mechanic requirements and boss breakdowns
function MatchCreator:InitializeDungeonData()
    self.dungeonData = {
        -- DRAGONFLIGHT SEASON 4 (Current Season)
        
        ["Mists of Tirna Scithe"] = {
            mechanics = {
                parry = 75,          -- High parry value needed for Tred'ova
                dodge = 60,          -- Moderate dodge for various encounters
                block = 45,          -- Some block utility
                magicDefense = 85,   -- High magic damage throughout
                physicalDefense = 40,
                aoeReduction = 90,   -- Critical for maze and Tred'ova
                dispel = 80,         -- Curse/poison dispels needed
                interrupt = 70,      -- Several casters
                mobility = 75,       -- Maze mechanics
                enrageRemoval = 0,   -- No enrage mechanics
                stunBreak = 60,      -- Cocoon mechanics
                immunity = 50        -- Some immunity phases
            },
            bosses = {
                ["Ingra Maloch"] = {
                    mechanics = {magicDefense = 90, aoeReduction = 85, mobility = 60},
                    tips = "High nature damage, spread for Droman's Wrath, kite during Spirit Bolt"
                },
                ["Mistcaller"] = {
                    mechanics = {dispel = 95, interrupt = 80, mobility = 85},
                    tips = "Dispel Freeze Tag ASAP, dodge guessing game, interrupt Bramblethorn Coat"
                },
                ["Tred'ova"] = {
                    mechanics = {parry = 90, aoeReduction = 95, mobility = 70, stunBreak = 80},
                    tips = "Tank faces away for Accelerated Incubation, break cocoons quickly, mind control dispels"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,  -- Excellent magic defense + mobility
                    ["Death Knight_Blood"] = 85,      -- Good overall toolkit
                    ["Monk_Brewmaster"] = 80,         -- Good mobility/magic def
                    ["Paladin_Protection"] = 75,      -- Solid but less magic def
                    ["Warrior_Protection"] = 65,      -- Struggles with magic
                    ["Druid_Guardian"] = 70           -- Decent all-around
                },
                healer = {
                    ["Priest_Discipline"] = 90,       -- Excellent for consistent damage
                    ["Shaman_Restoration"] = 85,      -- Great dispels + cooldowns
                    ["Druid_Restoration"] = 80,       -- Good HoTs for damage
                    ["Monk_Mistweaver"] = 75,         -- Mobility is helpful
                    ["Paladin_Holy"] = 70,            -- Limited by range
                    ["Priest_Holy"] = 75,             -- Good dispels
                    ["Evoker_Preservation"] = 85      -- Strong toolkit
                },
                dps = {
                    ["Mage_Any"] = 85,                -- Excellent for mechanics + dispel
                    ["Hunter_Any"] = 80,              -- Good utility/mobility
                    ["Demon Hunter_Havoc"] = 90,     -- Magic defense + mobility
                    ["Rogue_Any"] = 75,               -- Good for maze
                    ["Warlock_Any"] = 70,             -- Limited mobility
                    ["Priest_Shadow"] = 85,           -- Dispel utility
                    ["Shaman_Elemental"] = 80         -- Dispel + ranged
                }
            }
        },
        
        ["The Necrotic Wake"] = {
            mechanics = {
                parry = 60,
                dodge = 55,
                block = 70,          -- More physical damage
                magicDefense = 60,
                physicalDefense = 80, -- High physical damage
                aoeReduction = 75,
                dispel = 90,         -- Disease dispels critical
                interrupt = 85,      -- Many casters
                mobility = 50,
                enrageRemoval = 0,
                fear = 70,           -- Fear mechanics on Amarth
                hookAvoidance = 85   -- Hook mechanics throughout
            },
            bosses = {
                ["Blightbone"] = {
                    mechanics = {physicalDefense = 85, aoeReduction = 70, hookAvoidance = 90},
                    tips = "Avoid Heaving Retch, dodge Fetid Gas clouds, interrupt Crunch"
                },
                ["Amarth the Harvester"] = {
                    mechanics = {fear = 90, interrupt = 80, aoeReduction = 75},
                    tips = "Fear immunity/breaks crucial, interrupt Land of the Dead, stack for Final Harvest"
                },
                ["Surgeon Stitchflesh"] = {
                    mechanics = {hookAvoidance = 95, mobility = 80, interrupt = 85},
                    tips = "Avoid meat hooks, interrupt Stitchneedle, position for Embalming Ichor"
                },
                ["Nalthor the Rimebinder"] = {
                    mechanics = {dispel = 95, mobility = 70, magicDefense = 85},
                    tips = "Dispel Icebound Aegis immediately, avoid Comet Storm, move out of Blizzard"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,      -- Excels vs physical + fear immunity
                    ["Death Knight_Blood"] = 95,      -- Thematic and strong + fear immunity
                    ["Paladin_Protection"] = 85,      -- Good cooldowns + fear immunity
                    ["Demon Hunter_Vengeance"] = 70,  -- Less physical focus
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70
                },
                healer = {
                    ["Priest_Holy"] = 90,             -- Disease dispel + fear breaks
                    ["Shaman_Restoration"] = 85,      -- Dispel + cooldowns + tremor
                    ["Paladin_Holy"] = 80,            -- Disease dispel + fear immunity
                    ["Druid_Restoration"] = 75,       -- Limited dispel
                    ["Monk_Mistweaver"] = 70,         -- No disease dispel
                    ["Priest_Discipline"] = 80,       -- Good for burst healing
                    ["Evoker_Preservation"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 85,              -- Can immune hooks + dispel pets
                    ["Mage_Any"] = 80,                -- Good interrupt + dispel
                    ["Priest_Shadow"] = 85,           -- Dispel + fear breaks
                    ["Shaman_Any"] = 80,              -- Tremor totem + dispel
                    ["Warlock_Any"] = 75,             -- Fear immunity
                    ["Death Knight_Any"] = 85,        -- Thematic + fear immunity
                    ["Paladin_Retribution"] = 80      -- Fear immunity + dispel
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
                interrupt = 95,      -- Critical throughout
                mobility = 85,       -- Positioning crucial
                enrageRemoval = 0,
                knockbackResist = 80 -- Various knockbacks
            },
            bosses = {
                ["Sergeant Bainbridge"] = {
                    mechanics = {interrupt = 95, mobility = 80, aoeReduction = 75},
                    tips = "Interrupt Heavy Ordnance, move for Wildfire, stack for healing"
                },
                ["Dread Captain Lockwood"] = {
                    mechanics = {mobility = 90, aoeReduction = 85, knockbackResist = 85},
                    tips = "Kite Eudora, avoid Cannon Barrage, position for Crimson Swipe"
                },
                ["Hadal Darkfathom"] = {
                    mechanics = {interrupt = 90, mobility = 85, magicDefense = 80},
                    tips = "Interrupt Break Water, move for Tidal Surge, stack in Upwelling"
                },
                ["Viq'Goth"] = {
                    mechanics = {interrupt = 95, aoeReduction = 90, mobility = 75},
                    tips = "Priority interrupt Putrid Waters, demolish adds, avoid tentacles"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 90,      -- Spell reflect + mobility
                    ["Paladin_Protection"] = 85,      -- Interrupts + mobility
                    ["Death Knight_Blood"] = 80,      -- Good utility
                    ["Demon Hunter_Vengeance"] = 85,  -- Mobility + interrupts
                    ["Monk_Brewmaster"] = 75,
                    ["Druid_Guardian"] = 70           -- Limited interrupt
                },
                healer = {
                    ["Shaman_Restoration"] = 90,      -- Tremor + mobility
                    ["Priest_Discipline"] = 85,       -- Good positioning tools
                    ["Evoker_Preservation"] = 85,     -- Mobility + utility
                    ["Monk_Mistweaver"] = 80,         -- Mobility
                    ["Druid_Restoration"] = 75,
                    ["Paladin_Holy"] = 70,            -- Range limitations
                    ["Priest_Holy"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 90,              -- Mobility + interrupts
                    ["Mage_Any"] = 85,                -- Interrupts + mobility tools
                    ["Demon Hunter_Havoc"] = 85,     -- Mobility + interrupts
                    ["Warrior_Any"] = 80,             -- Interrupts + mobility
                    ["Shaman_Any"] = 85,              -- Interrupts + utility
                    ["Death Knight_Any"] = 80,        -- Interrupts + grip utility
                    ["Monk_Windwalker"] = 85          -- Mobility + interrupts
                }
            }
        },

        ["Halls of Atonement"] = {
            mechanics = {
                parry = 80,          -- Echelon parry mechanic
                dodge = 70,
                block = 50,
                magicDefense = 75,
                physicalDefense = 85,
                aoeReduction = 80,
                dispel = 60,
                interrupt = 90,      -- Critical for Inquisitors
                mobility = 65,
                enrageRemoval = 0,
                reflectAvoidance = 85 -- Spell reflect mechanics
            },
            bosses = {
                ["Halkias"] = {
                    mechanics = {aoeReduction = 90, mobility = 70, magicDefense = 80},
                    tips = "Spread for Crumbling Slam, move for Heave Debris, use walls for LoS"
                },
                ["Echelon"] = {
                    mechanics = {parry = 95, mobility = 75, physicalDefense = 90},
                    tips = "Never attack from front when Stone Legion Heraldry active, kite Blade Dance"
                },
                ["High Adjudicator Aleez"] = {
                    mechanics = {dispel = 80, interrupt = 95, aoeReduction = 85},
                    tips = "Interrupt Pulse from Beyond, dispel Ghastly Parabola, avoid Anima pools"
                },
                ["Lord Chamberlain"] = {
                    mechanics = {reflectAvoidance = 90, mobility = 80, interrupt = 85},
                    tips = "Don't cast during Reflect, teleport dodging, ritual positioning"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 85,      -- Spell reflect utility
                    ["Death Knight_Blood"] = 80,      -- Good survivability
                    ["Paladin_Protection"] = 90,      -- Excellent interrupts
                    ["Demon Hunter_Vengeance"] = 75,  -- Good mobility
                    ["Monk_Brewmaster"] = 70,
                    ["Druid_Guardian"] = 65           -- Limited interrupt
                },
                healer = {
                    ["Priest_Holy"] = 85,             -- Good dispels
                    ["Shaman_Restoration"] = 80,      -- Interrupt + dispels
                    ["Evoker_Preservation"] = 80,     -- Good utility
                    ["Paladin_Holy"] = 75,            -- Dispels
                    ["Monk_Mistweaver"] = 70,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 80
                },
                dps = {
                    ["Mage_Any"] = 85,                -- Interrupts + spell steal
                    ["Hunter_Any"] = 80,              -- Interrupts + mobility
                    ["Warrior_Any"] = 85,             -- Interrupts + spell reflect
                    ["Shaman_Any"] = 80,              -- Interrupts + purge
                    ["Death Knight_Any"] = 80,        -- Interrupts
                    ["Demon Hunter_Havoc"] = 75,     -- Interrupts + mobility
                    ["Paladin_Retribution"] = 80      -- Interrupts
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
                mobility = 90,       -- Extremely high mobility requirement
                enrageRemoval = 85,  -- Gorechop enrage
                fearResist = 75      -- Xav fear mechanics
            },
            bosses = {
                ["An Affront of Challengers"] = {
                    mechanics = {interrupt = 85, mobility = 80, aoeReduction = 80},
                    tips = "Interrupt Necromantic Bolt, move for Dark Stride, focus order important"
                },
                ["Gorechop"] = {
                    mechanics = {enrageRemoval = 95, mobility = 95, aoeReduction = 85},
                    tips = "Soothe/dispel enrage ASAP, constant movement for Hateful Strike, dodge Tenderizing Smash"
                },
                ["Xav the Unfallen"] = {
                    mechanics = {fearResist = 90, mobility = 85, magicDefense = 85},
                    tips = "Fear immunity crucial, dodge Seismic Leap, position for Blood and Glory"
                },
                ["Mordretha"] = {
                    mechanics = {mobility = 95, aoeReduction = 90, interrupt = 80},
                    tips = "Constant movement for Reap Soul, interrupt Ghostly Charge, dodge Death Grasp"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,  -- Mobility + magic defense
                    ["Monk_Brewmaster"] = 85,         -- Good mobility
                    ["Warrior_Protection"] = 80,      -- Fear immunity
                    ["Death Knight_Blood"] = 75,      -- Less mobile but sturdy
                    ["Paladin_Protection"] = 80,      -- Fear immunity + utility
                    ["Druid_Guardian"] = 85           -- Good mobility + soothe
                },
                healer = {
                    ["Monk_Mistweaver"] = 90,         -- Best mobility
                    ["Evoker_Preservation"] = 85,     -- Good mobility + utility
                    ["Shaman_Restoration"] = 80,      -- Tremor totem + mobility
                    ["Priest_Discipline"] = 75,       -- Less mobile
                    ["Druid_Restoration"] = 85,       -- Good mobility + soothe
                    ["Paladin_Holy"] = 70,            -- Fear immunity but less mobile
                    ["Priest_Holy"] = 75               -- Fear wards but less mobile
                },
                dps = {
                    ["Hunter_Any"] = 95,              -- Soothe + mobility
                    ["Druid_Any"] = 95,               -- Soothe + mobility
                    ["Rogue_Any"] = 90,               -- Fear immunity + mobility
                    ["Demon Hunter_Havoc"] = 90,     -- Mobility + magic defense
                    ["Monk_Windwalker"] = 90,         -- Excellent mobility
                    ["Mage_Any"] = 80,                -- Good mobility tools
                    ["Warrior_Any"] = 85,             -- Fear immunity + mobility
                    ["Shaman_Any"] = 85               -- Mobility + tremor utility
                }
            }
        },

        ["Plaguefall"] = {
            mechanics = {
                parry = 50,
                dodge = 60,
                block = 55,
                magicDefense = 85,   -- High nature/disease damage
                physicalDefense = 60,
                aoeReduction = 90,   -- Critical for many encounters
                dispel = 95,         -- Disease dispels everywhere
                interrupt = 85,      -- Many casters
                mobility = 75,
                enrageRemoval = 0,
                immunityPhases = 70  -- Slime immunity phases
            },
            bosses = {
                ["Globgrog"] = {
                    mechanics = {aoeReduction = 95, mobility = 80, magicDefense = 85},
                    tips = "Stack for Beckon Slime, spread after, avoid Slime Wave"
                },
                ["Doctor Ickus"] = {
                    mechanics = {dispel = 95, interrupt = 90, mobility = 85},
                    tips = "Dispel diseases immediately, interrupt Harvest Plague, dodge vials"
                },
                ["Domina Venomblade"] = {
                    mechanics = {immunityPhases = 90, aoeReduction = 85, mobility = 80},
                    tips = "Kill adds during Shadow Ambush, avoid Cytotoxic Slash pools"
                },
                ["Margrave Stradama"] = {
                    mechanics = {dispel = 95, aoeReduction = 90, mobility = 75},
                    tips = "Dispel Plague Crash, avoid Infectious Rain, spread for Plague Bolt"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 90,  -- Magic defense + mobility
                    ["Death Knight_Blood"] = 85,      -- Disease immunity
                    ["Paladin_Protection"] = 80,      -- Dispels + magic defense
                    ["Monk_Brewmaster"] = 75,         -- Magic defense
                    ["Warrior_Protection"] = 70,      -- Less magic defense
                    ["Druid_Guardian"] = 75           -- Decent all-around
                },
                healer = {
                    ["Priest_Holy"] = 95,             -- Disease dispel expert
                    ["Paladin_Holy"] = 90,            -- Disease dispel + immunity
                    ["Shaman_Restoration"] = 85,      -- Dispel + cooldowns
                    ["Evoker_Preservation"] = 80,     -- Good utility
                    ["Monk_Mistweaver"] = 70,         -- No disease dispel
                    ["Druid_Restoration"] = 75,       -- Limited dispel
                    ["Priest_Discipline"] = 85        -- Good for consistent damage
                },
                dps = {
                    ["Priest_Shadow"] = 90,           -- Disease dispel utility
                    ["Paladin_Retribution"] = 85,    -- Dispel + disease immunity
                    ["Mage_Any"] = 80,                -- Interrupt + dispel utility
                    ["Hunter_Any"] = 80,              -- Good utility
                    ["Shaman_Any"] = 85,              -- Dispel utility
                    ["Death Knight_Any"] = 85,        -- Disease immunity
                    ["Demon Hunter_Havoc"] = 80      -- Magic defense
                }
            }
        },

        ["Spires of Ascension"] = {
            mechanics = {
                parry = 65,
                dodge = 70,
                block = 60,
                magicDefense = 90,   -- Heavy arcane/holy damage
                physicalDefense = 50,
                aoeReduction = 85,
                dispel = 80,         -- Arcane dispels needed
                interrupt = 95,      -- Critical interrupts throughout
                mobility = 80,       -- Positioning important
                enrageRemoval = 0,
                spellSteal = 85      -- Many stealable buffs
            },
            bosses = {
                ["Kin-Tara"] = {
                    mechanics = {interrupt = 95, mobility = 85, spellSteal = 80},
                    tips = "Interrupt Charged Spear, dodge Recharge, steal Motivating Presence"
                },
                ["Ventunax"] = {
                    mechanics = {mobility = 90, aoeReduction = 90, magicDefense = 85},
                    tips = "Constant movement for Dark Stride, avoid Void Orbs, spread for Dark Bolt"
                },
                ["Oryphrion"] = {
                    mechanics = {spellSteal = 95, interrupt = 85, mobility = 80},
                    tips = "Steal Empyreal Ordnance, interrupt Charged Stomp, dodge Draconic Image"
                },
                ["Devos"] = {
                    mechanics = {interrupt = 95, mobility = 85, aoeReduction = 90},
                    tips = "Interrupt Archon's Bastion, move for Lights Judgment, use LoS for Run Through"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,  -- Magic defense + interrupts
                    ["Paladin_Protection"] = 85,      -- Magic defense + interrupts
                    ["Warrior_Protection"] = 80,      -- Spell reflect utility
                    ["Death Knight_Blood"] = 75,      -- Less magic focus
                    ["Monk_Brewmaster"] = 80,         -- Magic defense
                    ["Druid_Guardian"] = 70           -- Limited interrupt
                },
                healer = {
                    ["Evoker_Preservation"] = 90,     -- Dispel + magic toolkit
                    ["Priest_Discipline"] = 85,       -- Magic damage mitigation
                    ["Shaman_Restoration"] = 80,      -- Interrupts + utility
                    ["Paladin_Holy"] = 85,            -- Magic defense
                    ["Priest_Holy"] = 80,             -- Dispels
                    ["Monk_Mistweaver"] = 75,
                    ["Druid_Restoration"] = 75
                },
                dps = {
                    ["Mage_Any"] = 95,                -- Spell steal + interrupts
                    ["Warlock_Any"] = 85,             -- Magic damage + utility
                    ["Priest_Shadow"] = 85,           -- Dispel utility
                    ["Shaman_Any"] = 85,              -- Interrupts + purge
                    ["Hunter_Any"] = 80,              -- Interrupts + mobility
                    ["Demon Hunter_Havoc"] = 85,     -- Magic defense + interrupts
                    ["Warrior_Any"] = 80              -- Interrupts + spell reflect
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
                dispel = 85,         -- Various debuff types
                interrupt = 80,
                mobility = 85,       -- Portal mechanics + positioning
                enrageRemoval = 70,  -- Hakkar enrage
                portalNavigation = 90 -- Unique mechanic
            },
            bosses = {
                ["Hakkar the Soulflayer"] = {
                    mechanics = {enrageRemoval = 90, dispel = 85, aoeReduction = 80},
                    tips = "Soothe Blood Barrier, dispel Corrupted Blood, spread for Piercing Barb"
                },
                ["The Manastorms"] = {
                    mechanics = {interrupt = 90, mobility = 90, aoeReduction = 85},
                    tips = "Interrupt Arcane Lightning, dodge teleports, focus priority targets"
                },
                ["Dealer Xy'exa"] = {
                    mechanics = {mobility = 95, portalNavigation = 95, aoeReduction = 80},
                    tips = "Navigate portals quickly, avoid Explosive Contrivance, position for Chains"
                },
                ["Mueh'zala"] = {
                    mechanics = {portalNavigation = 95, mobility = 90, magicDefense = 85},
                    tips = "Master portal rotations, dodge Cosmic Artifice, avoid Master of Death"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Monk_Brewmaster"] = 90,         -- Best mobility for portals
                    ["Demon Hunter_Vengeance"] = 85,  -- Good mobility + magic defense
                    ["Warrior_Protection"] = 75,      -- Less mobile
                    ["Death Knight_Blood"] = 70,      -- Least mobile for portals
                    ["Paladin_Protection"] = 80,      -- Decent mobility
                    ["Druid_Guardian"] = 85           -- Good mobility + soothe
                },
                healer = {
                    ["Monk_Mistweaver"] = 95,         -- Best mobility for portals
                    ["Evoker_Preservation"] = 90,     -- Good mobility + utility
                    ["Shaman_Restoration"] = 80,      -- Decent mobility
                    ["Druid_Restoration"] = 85,       -- Good mobility + soothe
                    ["Priest_Discipline"] = 75,       -- Less mobile
                    ["Priest_Holy"] = 75,
                    ["Paladin_Holy"] = 70             -- Least mobile
                },
                dps = {
                    ["Hunter_Any"] = 90,              -- Soothe + mobility
                    ["Druid_Any"] = 90,               -- Soothe + mobility
                    ["Monk_Windwalker"] = 95,         -- Best mobility for portals
                    ["Demon Hunter_Havoc"] = 85,     -- Good mobility
                    ["Rogue_Any"] = 80,               -- Good mobility
                    ["Mage_Any"] = 75,                -- Portal utility but less mobile
                    ["Warrior_Any"] = 75,             -- Less mobile
                    ["Death Knight_Any"] = 70         -- Least mobile for portals
                }
            }
        },

        -- SEASON 4 RAID DUNGEONS (Dawn of the Infinites split)
        
        ["Dawn of the Infinites: Galakrond's Fall"] = {
            mechanics = {
                parry = 70,
                dodge = 65,
                block = 60,
                magicDefense = 95,   -- Extremely high temporal/cosmic damage
                physicalDefense = 60,
                aoeReduction = 90,
                dispel = 80,
                interrupt = 90,      -- Critical throughout
                mobility = 85,       -- Time mechanics require movement
                enrageRemoval = 0,
                timeResistance = 95, -- Unique temporal mechanics
                dragonflightLore = 80 -- Helps with mechanics understanding
            },
            bosses = {
                ["Chronikar"] = {
                    mechanics = {timeResistance = 90, interrupt = 95, aoeReduction = 85},
                    tips = "Interrupt Chronoshear, avoid temporal zones, stack for Chrono Burn"
                },
                ["Manifested Timeways"] = {
                    mechanics = {mobility = 95, timeResistance = 85, aoeReduction = 80},
                    tips = "Navigate timeline splits, avoid Infinite Corruption, focus priority"
                },
                ["Blight of Galakrond"] = {
                    mechanics = {magicDefense = 95, aoeReduction = 95, mobility = 85},
                    tips = "Massive shadow damage, spread for Necrofrost, dodge breath"
                },
                ["Iridikron the Stonescaled"] = {
                    mechanics = {timeResistance = 95, magicDefense = 90, mobility = 90},
                    tips = "Earth and time mechanics, avoid Extinction Blast, position for adds"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,  -- Magic defense + mobility
                    ["Paladin_Protection"] = 90,      -- Magic defense + utility
                    ["Death Knight_Blood"] = 85,      -- Good survivability
                    ["Monk_Brewmaster"] = 80,         -- Magic defense + mobility
                    ["Warrior_Protection"] = 75,      -- Less magic defense
                    ["Druid_Guardian"] = 80           -- Decent magic defense
                },
                healer = {
                    ["Evoker_Preservation"] = 95,     -- Dracthyr lore + toolkit
                    ["Priest_Discipline"] = 90,       -- Excellent for heavy damage
                    ["Shaman_Restoration"] = 85,      -- Good cooldowns
                    ["Priest_Holy"] = 85,             -- Strong healing
                    ["Paladin_Holy"] = 80,            -- Magic defense
                    ["Monk_Mistweaver"] = 80,         -- Mobility
                    ["Druid_Restoration"] = 85        -- Good sustained healing
                },
                dps = {
                    ["Evoker_Devastation"] = 95,      -- Dracthyr synergy + magic damage
                    ["Mage_Any"] = 90,                -- Temporal magic understanding
                    ["Warlock_Any"] = 85,             -- Magic damage + utility
                    ["Priest_Shadow"] = 85,           -- Magic damage + utility
                    ["Hunter_Any"] = 80,              -- Good mobility + utility
                    ["Demon Hunter_Havoc"] = 85,     -- Magic defense + mobility
                    ["Death Knight_Any"] = 80         -- Good survivability
                }
            }
        },

        ["Dawn of the Infinites: Murozond's Rise"] = {
            mechanics = {
                parry = 65,
                dodge = 70,
                block = 55,
                magicDefense = 95,   -- Extremely high temporal damage
                physicalDefense = 55,
                aoeReduction = 95,   -- Critical for timeline mechanics
                dispel = 75,
                interrupt = 85,
                mobility = 95,       -- Highest mobility requirement
                enrageRemoval = 0,
                timeResistance = 100, -- Maximum temporal mechanics
                infiniteLore = 85    -- Understanding Infinite Dragonflight
            },
            bosses = {
                ["Tyr, the Infinite Keeper"] = {
                    mechanics = {timeResistance = 95, aoeReduction = 90, mobility = 85},
                    tips = "Avoid Infinite Corruption, stack for Titanic Blow, dodge timeline shifts"
                },
                ["Morchie"] = {
                    mechanics = {mobility = 95, timeResistance = 90, interrupt = 85},
                    tips = "Constant timeline hopping, interrupt Sand Breath, avoid temporal zones"
                },
                ["Time-Lost Battlefield"] = {
                    mechanics = {aoeReduction = 95, mobility = 90, timeResistance = 85},
                    tips = "Multi-target encounter, constant movement, timeline awareness crucial"
                },
                ["Chrono-Lord Deios"] = {
                    mechanics = {timeResistance = 100, mobility = 95, aoeReduction = 95},
                    tips = "Master timeline mechanic, avoid Rewind, position for Temporal Shatter"
                },
                ["Murozond"] = {
                    mechanics = {timeResistance = 100, magicDefense = 95, mobility = 95},
                    tips = "Ultimate timeline boss, avoid Temporal Blast, master phase transitions"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,  -- Best mobility + magic defense
                    ["Monk_Brewmaster"] = 90,         -- Excellent mobility
                    ["Paladin_Protection"] = 85,      -- Good magic defense
                    ["Death Knight_Blood"] = 80,      -- Less mobile but sturdy
                    ["Warrior_Protection"] = 75,      -- Struggles with magic + mobility
                    ["Druid_Guardian"] = 85           -- Good all-around
                },
                healer = {
                    ["Monk_Mistweaver"] = 95,         -- Best mobility
                    ["Evoker_Preservation"] = 95,     -- Draconic synergy + mobility
                    ["Priest_Discipline"] = 85,       -- Good for heavy damage
                    ["Shaman_Restoration"] = 80,      -- Decent mobility
                    ["Druid_Restoration"] = 85,       -- Good mobility
                    ["Paladin_Holy"] = 75,            -- Less mobile
                    ["Priest_Holy"] = 80               -- Decent toolkit
                },
                dps = {
                    ["Evoker_Devastation"] = 100,     -- Perfect thematic fit
                    ["Demon Hunter_Havoc"] = 95,      -- Best mobility + magic defense
                    ["Monk_Windwalker"] = 95,         -- Excellent mobility
                    ["Hunter_Any"] = 90,              -- Great mobility + utility
                    ["Mage_Any"] = 85,                -- Time magic synergy
                    ["Rogue_Any"] = 85,               -- Good mobility
                    ["Druid_Any"] = 85,               -- Versatile + mobile
                    ["Warrior_Any"] = 75              -- Less optimal for mechanics
                }
            }
        },

        -- CLASSIC DUNGEONS (Still relevant in rotation)

        ["Brackenhide Hollow"] = {
            mechanics = {
                parry = 60,
                dodge = 65,
                block = 70,
                magicDefense = 70,
                physicalDefense = 80,
                aoeReduction = 85,   -- Rot mechanics
                dispel = 90,         -- Decay dispels critical
                interrupt = 85,
                mobility = 75,
                enrageRemoval = 80,  -- Enraged creatures
                naturesResistance = 85 -- Decay/nature damage
            },
            bosses = {
                ["Hackclaw's War-Band"] = {
                    mechanics = {interrupt = 90, aoeReduction = 80, mobility = 75},
                    tips = "Focus priority, interrupt Greater Heal, avoid Bladestorm"
                },
                ["Treemouth"] = {
                    mechanics = {naturesResistance = 90, aoeReduction = 85, dispel = 80},
                    tips = "High nature damage, avoid Consuming Stomp, dispel Withering"
                },
                ["Gutshot"] = {
                    mechanics = {enrageRemoval = 85, mobility = 80, aoeReduction = 75},
                    tips = "Soothe/dispel enrage, avoid Gut Shot, kite when needed"
                },
                ["Decatriarch Wratheye"] = {
                    mechanics = {dispel = 95, naturesResistance = 90, interrupt = 85},
                    tips = "Dispel Withering Contagion, interrupt Withering, avoid decay pools"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Death Knight_Blood"] = 90,      -- Disease immunity helps with decay
                    ["Demon Hunter_Vengeance"] = 85,  -- Magic defense
                    ["Paladin_Protection"] = 80,      -- Dispels
                    ["Druid_Guardian"] = 90,          -- Nature resistance + soothe
                    ["Warrior_Protection"] = 75,
                    ["Monk_Brewmaster"] = 80
                },
                healer = {
                    ["Druid_Restoration"] = 95,       -- Nature synergy + dispels + soothe
                    ["Shaman_Restoration"] = 85,      -- Dispels + nature spells
                    ["Priest_Holy"] = 80,             -- Good dispels
                    ["Evoker_Preservation"] = 80,
                    ["Paladin_Holy"] = 75,
                    ["Monk_Mistweaver"] = 70,
                    ["Priest_Discipline"] = 75
                },
                dps = {
                    ["Hunter_Any"] = 90,              -- Soothe + nature resistance
                    ["Druid_Any"] = 95,               -- Perfect nature synergy + soothe
                    ["Shaman_Any"] = 85,              -- Nature spells + utility
                    ["Death Knight_Any"] = 85,        -- Disease immunity
                    ["Demon Hunter_Havoc"] = 80,     -- Magic defense
                    ["Mage_Any"] = 75,
                    ["Priest_Shadow"] = 80,           -- Dispel utility
                    ["Paladin_Retribution"] = 80      -- Dispel utility
                }
            }
        },

        ["Neltharus"] = {
            mechanics = {
                parry = 75,
                dodge = 60,
                block = 80,          -- Physical heavy dungeon
                magicDefense = 60,
                physicalDefense = 90, -- Very high physical damage
                aoeReduction = 80,
                dispel = 70,
                interrupt = 80,
                mobility = 70,
                enrageRemoval = 0,
                fireResistance = 90,  -- Heavy fire damage
                dragonscaleArmor = 85 -- Thematic defense bonus
            },
            bosses = {
                ["Chargath"] = {
                    mechanics = {fireResistance = 85, physicalDefense = 90, aoeReduction = 80},
                    tips = "High fire damage, avoid Grounding Spear, stack for Dragon Strike"
                },
                ["Forgemaster Gorek"] = {
                    mechanics = {fireResistance = 95, interrupt = 85, mobility = 75},
                    tips = "Interrupt Forgestorm, avoid Heated Swings, dodge Blazing Eruption"
                },
                ["Magmatusk"] = {
                    mechanics = {fireResistance = 90, mobility = 80, aoeReduction = 85},
                    tips = "Avoid Magma Tentacles, dodge Lava Spray, move for Molten Gold"
                },
                ["Warlord Sargha"] = {
                    mechanics = {physicalDefense = 95, fireResistance = 85, aoeReduction = 80},
                    tips = "Heavy physical damage, avoid Magma Shield, position for Curse of the Dragon Hoard"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 95,      -- Excels vs physical + fire resist
                    ["Paladin_Protection"] = 90,      -- Good physical defense + fire resist
                    ["Death Knight_Blood"] = 85,      -- Good survivability
                    ["Demon Hunter_Vengeance"] = 75,  -- Less physical focused
                    ["Monk_Brewmaster"] = 80,         -- Decent physical mitigation
                    ["Druid_Guardian"] = 80           -- Good all-around
                },
                healer = {
                    ["Paladin_Holy"] = 90,            -- Fire resistance + strong healing
                    ["Shaman_Restoration"] = 85,      -- Fire spells + good cooldowns
                    ["Priest_Holy"] = 80,             -- Strong single target
                    ["Evoker_Preservation"] = 80,     -- Fire resistance
                    ["Monk_Mistweaver"] = 75,
                    ["Druid_Restoration"] = 75,
                    ["Priest_Discipline"] = 80
                },
                dps = {
                    ["Fire_Mage"] = 95,               -- Fire immunity/resistance
                    ["Shaman_Any"] = 90,              -- Fire spells + resistance
                    ["Paladin_Retribution"] = 85,    -- Fire resistance + utility
                    ["Hunter_Any"] = 80,              -- Good utility
                    ["Warrior_Any"] = 85,             -- Fire resistance + physical synergy
                    ["Death Knight_Any"] = 80,        -- Good survivability
                    ["Demon Hunter_Havoc"] = 75      -- Less optimal for this dungeon
                }
            }
        },

        ["The Azure Vault"] = {
            mechanics = {
                parry = 60,
                dodge = 70,
                block = 55,
                magicDefense = 95,   -- Extremely magic heavy
                physicalDefense = 45,
                aoeReduction = 85,
                dispel = 90,         -- Many magical effects
                interrupt = 95,      -- Critical interrupts
                mobility = 80,
                enrageRemoval = 0,
                spellSteal = 90,     -- Many stealable buffs
                arcaneResistance = 90 -- Heavy arcane damage
            },
            bosses = {
                ["Leymor"] = {
                    mechanics = {interrupt = 95, spellSteal = 85, arcaneResistance = 90},
                    tips = "Interrupt Erupting Fissure, steal Leyline Sprouts buffs, avoid orb explosions"
                },
                ["Azureblade"] = {
                    mechanics = {mobility = 90, arcaneResistance = 85, aoeReduction = 80},
                    tips = "Avoid Arcane Cleave, dodge Ancient Orb, interrupt Ancient Orb cast"
                },
                ["Telash Greywing"] = {
                    mechanics = {interrupt = 95, mobility = 85, dispel = 90},
                    tips = "Interrupt Frost Bomb, dispel Absolute Zero, avoid icy devastation"
                },
                ["Umbrelskul"] = {
                    mechanics = {arcaneResistance = 95, interrupt = 90, mobility = 85},
                    tips = "Massive arcane damage, interrupt Arcane Fissure, avoid Oppressive Miasma"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Demon Hunter_Vengeance"] = 95,  -- Best magic defense
                    ["Paladin_Protection"] = 90,      -- Magic defense + interrupts
                    ["Death Knight_Blood"] = 80,      -- Decent magic defense
                    ["Monk_Brewmaster"] = 85,         -- Good magic defense
                    ["Warrior_Protection"] = 75,      -- Spell reflect utility but less defense
                    ["Druid_Guardian"] = 75           -- Limited interrupt
                },
                healer = {
                    ["Evoker_Preservation"] = 95,     -- Magic synergy + dispels
                    ["Priest_Discipline"] = 90,       -- Excellent for magic damage
                    ["Shaman_Restoration"] = 85,      -- Good utility + interrupts
                    ["Mage_Any"] = 80,                -- Can heal with right spec/utility
                    ["Priest_Holy"] = 85,             -- Good dispels
                    ["Paladin_Holy"] = 80,            -- Magic resistance
                    ["Monk_Mistweaver"] = 75
                },
                dps = {
                    ["Mage_Any"] = 95,                -- Spell steal expert + arcane synergy
                    ["Warlock_Any"] = 85,             -- Magic damage + utility
                    ["Priest_Shadow"] = 85,           -- Magic damage + dispels
                    ["Shaman_Any"] = 85,              -- Magic damage + interrupts + purge
                    ["Evoker_Devastation"] = 90,     -- Magic synergy
                    ["Hunter_Any"] = 75,              -- Less magic synergy
                    ["Demon Hunter_Havoc"] = 80,     -- Magic defense
                    ["Death Knight_Any"] = 75         -- Less magic focused
                }
            }
        },

        ["The Nokhud Offensive"] = {
            mechanics = {
                parry = 80,
                dodge = 75,
                block = 85,
                magicDefense = 65,
                physicalDefense = 90, -- Very physical heavy
                aoeReduction = 90,    -- Massive cleaves throughout
                dispel = 75,
                interrupt = 85,
                mobility = 85,        -- Positioning crucial
                enrageRemoval = 90,   -- Multiple enrage mechanics
                windResistance = 80   -- Wind/storm magic
            },
            bosses = {
                ["Granyth"] = {
                    mechanics = {enrageRemoval = 90, aoeReduction = 90, physicalDefense = 85},
                    tips = "Soothe Brutalize, avoid Shatter, massive physical cleave"
                },
                ["The Raging Tempest"] = {
                    mechanics = {windResistance = 95, mobility = 90, interrupt = 85},
                    tips = "Avoid tornados, interrupt Storm Bolt, constant movement required"
                },
                ["Teera and Maruuk"] = {
                    mechanics = {mobility = 95, enrageRemoval = 85, aoeReduction = 85},
                    tips = "Separate bosses, soothe Frightening Shout effects, avoid charges"
                },
                ["Balakar Khan"] = {
                    mechanics = {physicalDefense = 95, aoeReduction = 95, mobility = 80},
                    tips = "Massive Iron Spear damage, avoid Upheaval, position for adds"
                }
            },
            preferredSpecs = {
                tank = {
                    ["Warrior_Protection"] = 95,      -- Perfect for physical + mobility
                    ["Paladin_Protection"] = 85,      -- Good physical defense
                    ["Death Knight_Blood"] = 80,      -- Good survivability
                    ["Monk_Brewmaster"] = 85,         -- Good mobility + physical mitigation
                    ["Demon Hunter_Vengeance"] = 75,  -- Less physical focused
                    ["Druid_Guardian"] = 90           -- Excellent soothe + mobility
                },
                healer = {
                    ["Druid_Restoration"] = 95,       -- Soothe utility crucial
                    ["Shaman_Restoration"] = 85,      -- Wind resistance + utility
                    ["Priest_Holy"] = 80,             -- Strong healing for physical damage
                    ["Paladin_Holy"] = 80,            -- Good for physical damage
                    ["Monk_Mistweaver"] = 85,         -- Good mobility
                    ["Evoker_Preservation"] = 80,
                    ["Priest_Discipline"] = 75        -- Less optimal for this style
                },
                dps = {
                    ["Hunter_Any"] = 95,              -- Soothe + mobility + ranged
                    ["Druid_Any"] = 95,               -- Soothe + versatility
                    ["Warrior_Any"] = 85,             -- Physical synergy + mobility
                    ["Shaman_Any"] = 80,              -- Wind magic + utility
                    ["Death Knight_Any"] = 80,        -- Good survivability
                    ["Monk_Windwalker"] = 85,         -- Good mobility
                    ["Demon Hunter_Havoc"] = 80,     -- Good mobility
                    ["Mage_Any"] = 70                 -- Less optimal positioning
                }
            }
        }
    }
end

-- Class and spec data
function MatchCreator:InitializeClassData()
    self.classSpecs = {
        ["Death Knight"] = {
            specs = {"Blood", "Frost", "Unholy"},
            utilities = {
                Blood = {interrupt = true, dispel = false, enrageRemoval = false, mobility = "low"},
                Frost = {interrupt = true, dispel = false, enrageRemoval = false, mobility = "medium"},
                Unholy = {interrupt = true, dispel = false, enrageRemoval = false, mobility = "medium"}
            }
        },
        ["Demon Hunter"] = {
            specs = {"Havoc", "Vengeance"},
            utilities = {
                Havoc = {interrupt = true, dispel = false, enrageRemoval = false, mobility = "high"},
                Vengeance = {interrupt = true, dispel = false, enrageRemoval = false, mobility = "high"}
            }
        },
        ["Druid"] = {
            specs = {"Balance", "Feral", "Guardian", "Restoration"},
            utilities = {
                Balance = {interrupt = false, dispel = true, enrageRemoval = true, mobility = "medium"},
                Feral = {interrupt = false, dispel = false, enrageRemoval = true, mobility = "high"},
                Guardian = {interrupt = false, dispel = false, enrageRemoval = true, mobility = "medium"},
                Restoration = {interrupt = false, dispel = true, enrageRemoval = true, mobility = "medium"}
            }
        },
        -- Add more classes here...
    }
end

-- Main function to get dungeon recommendations
function MatchCreator:GetDungeonRecommendations(dungeonName)
    local data = self.dungeonData[dungeonName]
    if not data then
        return nil, "Dungeon data not found"
    end
    
    return {
        mechanics = data.mechanics,
        recommendations = data.preferredSpecs,
        summary = self:GenerateSummary(data)
    }
end

-- Generate a summary of key requirements
function MatchCreator:GenerateSummary(dungeonData)
    local summary = {}
    local mechanics = dungeonData.mechanics
    
    -- Find top 3 most important mechanics
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        if value > 0 then
            table.insert(sortedMechanics, {name = mechanic, value = value})
        end
    end
    
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    for i = 1, math.min(3, #sortedMechanics) do
        local mech = sortedMechanics[i]
        summary[mech.name] = mech.value
    end
    
    return summary
end

-- Function to integrate with Group Finder UI
function MatchCreator:OnGroupFinderUpdate()
    -- This would hook into the LFG system
    -- Show recommendations when a dungeon is selected
    local selectedDungeon = self:GetSelectedDungeon()
    if selectedDungeon then
        local recommendations = self:GetDungeonRecommendations(selectedDungeon)
        if recommendations then
            self:DisplayRecommendations(recommendations)
        end
    end
end

-- Get currently selected dungeon (placeholder)
function MatchCreator:GetSelectedDungeon()
    -- This would integrate with Blizzard's LFG API
    -- For now, return nil
    return nil
end

-- Display recommendations in UI
function MatchCreator:DisplayRecommendations(recommendations)
    -- Create or update recommendation frame
    if not MatchCreatorFrame then
        self:CreateRecommendationFrame()
    end
    
    -- Update the frame with new data
    self:UpdateRecommendationFrame(recommendations)
end

-- Create the main UI frame with tabbed interface
function MatchCreator:CreateRecommendationFrame()
    local frame = CreateFrame("Frame", "MatchCreatorFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(500, 400)
    frame:SetPoint("CENTER", 0, 0)
    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFontObject("GameFontHighlight")
    frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
    frame.title:SetText("Match Creator - Dungeon Analysis")
    
    -- Make it movable
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
    local tabWidth = 95
    
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
        contentChild:SetSize(460, 340)
        content:SetScrollChild(contentChild)
        content:Hide()
        
        frame.tabContents[i] = {frame = content, child = contentChild, elements = {}}
    end
    
    -- Show first tab by default
    frame.tabContents[1].frame:Show()
    PanelTemplates_SelectTab(frame.tabs[1])
    
    -- Add close button functionality
    frame:SetScript("OnHide", function(self)
        -- Clean up any resources if needed
    end)
    
    -- Integration with Group Finder
    self:IntegrateWithGroupFinder(frame)
    
    frame:Hide()
    MatchCreatorFrame = frame
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

-- Refresh content for specific tab
function MatchCreator:RefreshTabContent(tabIndex)
    local currentDungeon = self:GetCurrentDungeon()
    if not currentDungeon then return end
    
    local recommendations = self:GetDungeonRecommendations(currentDungeon)
    local affixes = self:GetCurrentAffixes()
    
    if affixes then
        recommendations = self:GetAffixAdjustedRecommendations(currentDungeon, affixes)
    end
    
    if tabIndex == 1 then
        self:UpdateOverviewTab(recommendations, affixes)
    elseif tabIndex == 2 then
        self:UpdateRoleTab("tank", recommendations)
    elseif tabIndex == 3 then
        self:UpdateRoleTab("healer", recommendations)
    elseif tabIndex == 4 then
        self:UpdateRoleTab("dps", recommendations)
    elseif tabIndex == 5 then
        self:UpdateMechanicsTab(recommendations)
    end
end

-- Update overview tab
function MatchCreator:UpdateOverviewTab(recommendations, affixes)
    local content = MatchCreatorFrame.tabContents[1]
    self:ClearTabContent(1)
    
    local yOffset = -10
    
    -- Dungeon title
    local dungeonTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dungeonTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    dungeonTitle:SetText("|cFFFFD700" .. (self:GetCurrentDungeon() or "Select Dungeon") .. "|r")
    table.insert(content.elements, dungeonTitle)
    yOffset = yOffset - 30
    
    -- Current affixes
    if affixes then
        local affixTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        affixTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        affixTitle:SetText("|cFFFFAA00Current Week Affixes:|r")
        table.insert(content.elements, affixTitle)
        yOffset = yOffset - 20
        
        for _, affix in ipairs(affixes) do
            local affixText = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            affixText:SetPoint("TOPLEFT", content.child, "TOPLEFT", 20, yOffset)
            affixText:SetText("• " .. affix)
            table.insert(content.elements, affixText)
            yOffset = yOffset - 16
        end
        yOffset = yOffset - 10
    end
    
    -- Quick recommendations summary
    local quickTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    quickTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    quickTitle:SetText("|cFF00FF00Quick Picks:|r")
    table.insert(content.elements, quickTitle)
    yOffset = yOffset - 20
    
    -- Top pick for each role
    local roles = {
        {key = "tank", name = "Tank", color = "|cFF1E90FF"},
        {key = "healer", name = "Healer", color = "|cFF32CD32"},
        {key = "dps", name = "DPS", color = "|cFFFF6347"}
    }
    
    for _, role in ipairs(roles) do
        if recommendations.recommendations[role.key] then
            local topSpec = self:GetTopSpec(recommendations.recommendations[role.key])
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
    
    -- Mechanic importance visual chart
    self:CreateMechanicChart(content, recommendations.summary, yOffset)
end

-- Create visual mechanic importance chart
function MatchCreator:CreateMechanicChart(content, mechanics, yOffset)
    local chartTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    chartTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    chartTitle:SetText("|cFFFFAA00Mechanic Importance:|r")
    table.insert(content.elements, chartTitle)
    yOffset = yOffset - 25
    
    -- Sort mechanics by importance
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        table.insert(sortedMechanics, {name = mechanic, value = value})
    end
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    -- Create visual bars
    local maxBarWidth = 300
    for i, mech in ipairs(sortedMechanics) do
        if i > 6 then break end -- Show top 6 mechanics
        
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
            barTexture:SetColorTexture(0.6, 0.6, 0.6, 0.8) -- Gray for low
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
function MatchCreator:UpdateRoleTab(role, recommendations)
    local tabIndex = role == "tank" and 2 or role == "healer" and 3 or 4
    local content = MatchCreatorFrame.tabContents[tabIndex]
    self:ClearTabContent(tabIndex)
    
    local yOffset = -10
    local roleColors = {tank = "|cFF1E90FF", healer = "|cFF32CD32", dps = "|cFFFF6347"}
    local roleNames = {tank = "Tank", healer = "Healer", dps = "DPS"}
    
    -- Role title
    local roleTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    roleTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    roleTitle:SetText(roleColors[role] .. roleNames[role] .. " Recommendations|r")
    table.insert(content.elements, roleTitle)
    yOffset = yOffset - 35
    
    if not recommendations.recommendations[role] then
        local noData = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noData:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        noData:SetText("No data available for this role")
        table.insert(content.elements, noData)
        return
    end
    
    -- Sort specs by rating
    local sortedSpecs = {}
    for spec, rating in pairs(recommendations.recommendations[role]) do
        table.insert(sortedSpecs, {spec = spec, rating = rating})
    end
    table.sort(sortedSpecs, function(a, b) return a.rating > b.rating end)
    
    -- Create detailed spec cards
    for i, spec in ipairs(sortedSpecs) do
        local card = self:CreateSpecCard(content, spec, yOffset, role)
        yOffset = yOffset - 80
        if yOffset < -300 then
            content.child:SetHeight(-yOffset + 50)
        end
    end
end

-- Create detailed spec recommendation card
function MatchCreator:CreateSpecCard(content, spec, yOffset, role)
    local cardHeight = 70
    
    -- Card background
    local card = CreateFrame("Frame", nil, content.child)
    card:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    card:SetSize(440, cardHeight)
    
    local cardBG = card:CreateTexture(nil, "BACKGROUND")
    cardBG:SetAllPoints()
    cardBG:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Rating color background
    local ratingBG = CreateFrame("Frame", nil, card)
    ratingBG:SetPoint("LEFT", card, "LEFT", 0, 0)
    ratingBG:SetSize(60, cardHeight)
    
    local ratingTexture = ratingBG:CreateTexture(nil, "ARTWORK")
    ratingTexture:SetAllPoints()
    
    -- Color by rating
    if spec.rating >= 90 then
        ratingTexture:SetColorTexture(0, 0.8, 0, 0.6) -- Green
    elseif spec.rating >= 80 then
        ratingTexture:SetColorTexture(1, 0.8, 0, 0.6) -- Gold
    elseif spec.rating >= 70 then
        ratingTexture:SetColorTexture(1, 0.6, 0, 0.6) -- Orange
    else
        ratingTexture:SetColorTexture(0.6, 0.6, 0.6, 0.6) -- Gray
    end
    
    -- Rating text
    local ratingText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    ratingText:SetPoint("CENTER", ratingBG, "CENTER", 0, 0)
    ratingText:SetText(spec.rating)
    
    -- Spec name
    local specName = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    specName:SetPoint("LEFT", ratingBG, "RIGHT", 10, 10)
    local formattedSpec = string.gsub(spec.spec, "_", " ")
    specName:SetText("|cFFFFFFFF" .. formattedSpec .. "|r")
    
    -- Utility indicators
    local utilities = self:GetSpecUtilities(spec.spec, role)
    if utilities then
        local utilityText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        utilityText:SetPoint("LEFT", ratingBG, "RIGHT", 10, -15)
        utilityText:SetWidth(360)
        utilityText:SetJustifyH("LEFT")
        utilityText:SetText(utilities)
    end
    
    -- Why this rating explanation
    local explanation = self:GetSpecExplanation(spec.spec, spec.rating, role)
    if explanation then
        local explainText = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        explainText:SetPoint("LEFT", ratingBG, "RIGHT", 10, -30)
        explainText:SetWidth(360)
        explainText:SetJustifyH("LEFT")
        explainText:SetText("|cFF888888" .. explanation .. "|r")
    end
    
    table.insert(content.elements, card)
    return card
end

-- Get spec utilities for display
function MatchCreator:GetSpecUtilities(specName, role)
    local class, spec = string.match(specName, "(.+)_(.+)")
    if not class or not spec then return "" end
    
    local utilities = {}
    local classData = self.classSpecs[class]
    if classData and classData.utilities[spec] then
        local util = classData.utilities[spec]
        
        if util.interrupt then table.insert(utilities, "|cFF00FF00Interrupt|r") end
        if util.dispel then table.insert(utilities, "|cFF4169E1Dispel|r") end
        if util.enrageRemoval then table.insert(utilities, "|cFFFF69B4Soothe|r") end
        if util.mobility == "excellent" then table.insert(utilities, "|cFFFFD700High Mobility|r") end
        if util.spellSteal then table.insert(utilities, "|cFF9370DBSpell Steal|r") end
        if util.fearImmunity then table.insert(utilities, "|cFFFFA500Fear Immune|r") end
        if util.battleRes then table.insert(utilities, "|cFF32CD32Battle Rez|r") end
    end
    
    return table.concat(utilities, " • ")
end

-- Get explanation for spec rating
function MatchCreator:GetSpecExplanation(specName, rating, role)
    local currentDungeon = self:GetCurrentDungeon()
    if not currentDungeon then return "" end
    
    local dungeonData = self.dungeonData[currentDungeon]
    if not dungeonData then return "" end
    
    local explanations = {
        [95] = "Excellent choice - strong synergy with this dungeon's mechanics",
        [90] = "Great pick - very well suited for this content",
        [85] = "Strong option - good toolkit for these encounters", 
        [80] = "Solid choice - reliable performance expected",
        [75] = "Decent pick - can handle the content well",
        [70] = "Workable option - may struggle with some mechanics",
        [65] = "Challenging - requires skilled play to be effective"
    }
    
    -- Find closest explanation
    local bestMatch = 50
    for threshold, _ in pairs(explanations) do
        if math.abs(rating - threshold) < math.abs(rating - bestMatch) then
            bestMatch = threshold
        end
    end
    
    return explanations[bestMatch] or "Performance will vary based on player skill"
end

-- Update mechanics analysis tab
function MatchCreator:UpdateMechanicsTab(recommendations)
    local content = MatchCreatorFrame.tabContents[5]
    self:ClearTabContent(5)
    
    local yOffset = -10
    
    -- Mechanics title
    local mechTitle = content.child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mechTitle:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
    mechTitle:SetText("|cFFFFD700Detailed Mechanics Analysis|r")
    table.insert(content.elements, mechTitle)
    yOffset = yOffset - 30
    
    -- Create comprehensive mechanics breakdown
    self:CreateDetailedMechanicsChart(content, recommendations.mechanics, yOffset)
end

-- Create detailed mechanics analysis chart
function MatchCreator:CreateDetailedMechanicsChart(content, mechanics, yOffset)
    -- Sort all mechanics
    local sortedMechanics = {}
    for mechanic, value in pairs(mechanics) do
        if value > 0 then
            table.insert(sortedMechanics, {name = mechanic, value = value})
        end
    end
    table.sort(sortedMechanics, function(a, b) return a.value > b.value end)
    
    local maxBarWidth = 350
    
    for i, mech in ipairs(sortedMechanics) do
        -- Mechanic category
        local mechCard = CreateFrame("Frame", nil, content.child)
        mechCard:SetPoint("TOPLEFT", content.child, "TOPLEFT", 10, yOffset)
        mechCard:SetSize(450, 40)
        
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
            barTex:SetColorTexture(1, 0.2, 0.2, 0.9)
        elseif mech.value >= 80 then
            barTex:SetColorTexture(1, 0.6, 0, 0.9)
        elseif mech.value >= 70 then
            barTex:SetColorTexture(1, 1, 0, 0.9)
        elseif mech.value >= 60 then
            barTex:SetColorTexture(0.6, 1, 0.2, 0.9)
        else
            barTex:SetColorTexture(0.4, 0.8, 1, 0.9)
        end
        
        -- Value and description
        local valueText = mechCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        valueText:SetPoint("RIGHT", mechCard, "RIGHT", -10, 0)
        valueText:SetText(mech.value .. "% - " .. self:GetMechanicDescription(mech.name))
        
        table.insert(content.elements, mechCard)
        yOffset = yOffset - 50
        
        if yOffset < -350 then
            content.child:SetHeight(-yOffset + 50)
        end
    end
end

-- Get mechanic descriptions
function MatchCreator:GetMechanicDescription(mechanic)
    local descriptions = {
        parry = "Tank must face away from enemies",
        dodge = "Movement and positioning crucial",
        block = "Physical damage mitigation important",
        magicDefense = "Magic resistance and cooldowns needed",
        physicalDefense = "Physical damage reduction important",
        aoeReduction = "AoE damage mitigation critical",
        dispel = "Dispel/cleanse abilities required",
        interrupt = "Interrupt abilities essential",
        mobility = "Movement and positioning key",
        enrageRemoval = "Soothe/tranquilizing abilities needed",
        spellSteal = "Spell steal/purge helpful",
        timeResistance = "Temporal mechanics understanding",
        fireResistance = "Fire damage mitigation helpful"
    }
    
    return descriptions[mechanic] or "Important mechanic"
end

-- Integration with Group Finder
function MatchCreator:IntegrateWithGroupFinder(frame)
    -- Hook into Group Finder events
    local hookFrame = CreateFrame("Frame")
    hookFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
    hookFrame:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE")
    
    hookFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
            MatchCreator:OnGroupFinderUpdate()
        elseif event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
            MatchCreator:OnGroupFinderEntryUpdate()
        end
    end)
    
    -- Position near Group Finder when it's open
    frame.positionHook = function()
        if LFGListFrame and LFGListFrame:IsShown() then
            frame:ClearAllPoints()
            frame:SetPoint("LEFT", LFGListFrame, "RIGHT", 10, 0)
        end
    end
end

-- Handle Group Finder entry updates
function MatchCreator:OnGroupFinderEntryUpdate()
    -- Auto-show when creating/editing group
    if MatchCreatorFrame and self:GetSelectedDungeon() then
        MatchCreatorFrame:Show()
        if MatchCreatorFrame.positionHook then
            MatchCreatorFrame.positionHook()
        end
        self:RefreshTabContent(MatchCreatorFrame.activeTab)
    end
end

-- Clear tab content
function MatchCreator:ClearTabContent(tabIndex)
    local content = MatchCreatorFrame.tabContents[tabIndex]
    if content.elements then
        for _, element in pairs(content.elements) do
            if element.Hide then
                element:Hide()
            end
        end
    end
    content.elements = {}
end

-- Get top spec from recommendations
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
end

-- Update the recommendation frame with data
function MatchCreator:UpdateRecommendationFrame(recommendations)
    if not MatchCreatorFrame then return end
    
    -- Clear existing content
    local content = MatchCreatorFrame.contentChild
    if content.textElements then
        for _, element in pairs(content.textElements) do
            element:Hide()
        end
    end
    content.textElements = {}
    
    local yOffset = -10
    
    -- Display mechanics summary
    local mechanicsTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    mechanicsTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)
    mechanicsTitle:SetText("|cFFFFD700Key Mechanics:|r")
    table.insert(content.textElements, mechanicsTitle)
    yOffset = yOffset - 25
    
    for mechanic, value in pairs(recommendations.summary) do
        local mechanicText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        mechanicText:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
        local color = value >= 80 and "|cFFFF4444" or value >= 60 and "|cFFFFAA00" or "|cFFFFFFFF"
        mechanicText:SetText(string.format("%s%s: %d%%|r", color, self:FormatMechanicName(mechanic), value))
        table.insert(content.textElements, mechanicText)
        yOffset = yOffset - 18
    end
    
    MatchCreatorFrame:Show()
end

-- Format mechanic names for display
function MatchCreator:FormatMechanicName(mechanic)
    local names = {
        parry = "Parry",
        dodge = "Dodge", 
        block = "Block",
        magicDefense = "Magic Defense",
        physicalDefense = "Physical Defense",
        aoeReduction = "AOE Reduction",
        dispel = "Dispel",
        interrupt = "Interrupt",
        mobility = "Mobility",
        enrageRemoval = "Enrage Removal"
    }
    return names[mechanic] or mechanic
end

-- Slash command
SLASH_MATCHCREATOR1 = "/matchcreator"
SLASH_MATCHCREATOR2 = "/mc"
SlashCmdList["MATCHCREATOR"] = function(msg)
    local args = {strsplit(" ", msg)}
    local cmd = args[1] and string.lower(args[1]) or ""
    
    if cmd == "show" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Show()
        end
    elseif cmd == "hide" then
        if MatchCreatorFrame then
            MatchCreatorFrame:Hide()
        end
    elseif cmd == "test" then
        local recommendations = MatchCreator:GetDungeonRecommendations("Mists of Tirna Scithe")
        if recommendations then
            MatchCreator:DisplayRecommendations(recommendations)
        end
    else
        print("|cFF00FF00Match Creator Commands:|r")
        print("/mc show - Show recommendations window")
        print("/mc hide - Hide recommendations window") 
        print("/mc test - Test with sample data")
    end
end
