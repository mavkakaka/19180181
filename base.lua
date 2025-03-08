local imgui = require 'mimgui'
local memory = require 'memory'
local MDS = MONET_DPI_SCALE
local ffi = require 'ffi'
local ev = require('lib.samp.events')
local sampEvents = require("lib.samp.events")
local events = require 'lib.samp.events'
local faicons = require('fAwesome6')
local gta = ffi.load('GTASA')

local new = imgui.new
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local widgets = require('widgets')
local ammo = new.int(500)
local fastreload = imgui.new.bool(false)
local weapon_id = new.int(31)
local reparar = imgui.new.bool(false)
local rainbow = imgui.new.bool(false)
local ffi = require 'ffi'
local gta = ffi.load('GTASA')
local SAMemory = require 'SAMemory'
local encoding = require 'encoding'
local vector3d = require("vector3d")
SAMemory.require("CCamera")
local json = require 'json'
local inicfg = require 'inicfg'
local ltn12 = require("ltn12")
local playerIdToAdd = ffi.new("int[1]", 0)

local MDS = MONET_DPI_SCALE
local DPI = MONET_DPI_SCALE
local window = imgui.new.bool(false)
local camera = SAMemory.camera
local screenWidth, screenHeight = getScreenResolution()
local configFilePath = getWorkingDirectory() .. "/config/config.json"
local circuloFOVAIM = false

local config = {
    ignorePlayerId = ffi.new("int[1]", 0),
    ignoredPlayers = {}
}

local buttonPressedTime = 0
local buttonRepeatInterval = 0.0
local renderWindow = imgui.new.bool(false)
local buttonSize = imgui.ImVec2(120 * DPI, 60 * DPI)
local WinState = imgui.new.bool()
local renderWindow = imgui.new.bool()
local sizeX, sizeY = getScreenResolution()
local BOTAO = 2
local activeTab = 2
local SCREEN_W, SCREEN_H = getScreenResolution()

local bones = { 3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2 }
local font = renderCreateFont("Arial", 12, 1 + 4)
ffi.cdef("typedef struct RwV3d { float x; float y; float z; } RwV3d; void _ZN4CPed15GetBonePositionER5RwV3djb(void* thiz, RwV3d* posn, uint32_t bone, bool calledFromCam);")
ffi.cdef([[ void _Z12AND_OpenLinkPKc(const char* link); ]])
ignoredPlayers = {}


local function shouldIgnorePlayer(playerId)
    for _, id in ipairs(ignoredPlayers) do
        if id == playerId then
            return true
        end
    end
    return false
end

local function addIgnoredPlayer(playerId)
    if not table.contains(ignoredPlayers, playerId) then
        table.insert(ignoredPlayers, playerId)
    end
end

local function removeIgnoredPlayer(playerId)
    for i, id in ipairs(ignoredPlayers) do
        if id == playerId then
            table.remove(ignoredPlayers, i)
            break
        end
    end
end

local function shouldIgnorePlayer(playerId)
    for _, id in ipairs(ignoredPlayers) do
        if id == playerId then
            return true
        end
    end
    return false
end

local function loadConfig()
    local file = io.open(configFilePath, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local config = json.decode(content)
        if config and config.slide then
            slide.FoVVHG[0] = tonumber(config.slide.FoVVHG) or slide.FoVVHG[0]
            slide.fovX[0] = tonumber(config.slide.fovX) or slide.fovX[0]
            slide.fovY[0] = tonumber(config.slide.fovY) or slide.fovY[0]          
            slide.fovvaimbotcirculo[0] = tonumber(config.slide.fovvaimbotcirculo) or slide.fovvaimbotcirculo[0]
            slide.DistanciaAIM[0] = tonumber(config.slide.DistanciaAIM) or slide.DistanciaAIM[0]
            slide.aimSmoothhhh[0] = tonumber(config.slide.aimSmoothhhh) or slide.aimSmoothhhh[0]
            slide.fovCorAimmm[0] = tonumber(config.slide.fovCorAimmm) or slide.fovCorAimmm[0]
            slide.posiX[0] = tonumber(config.slide.posiX) or slide.posiX[0]
            slide.posiY[0] = tonumber(config.slide.posiY) or slide.posiY[0]
            slide.circulooPosX[0] = tonumber(config.slide.circulooPosX) or slide.circulooPosX[0]
            slide.circuloooPosY[0] = tonumber(config.slide.circuloooPosY) or slide.circuloooPosY[0]
            slide.distancia[0] = tonumber(config.slide.distancia) or slide.distancia[0]
            slide.fovColor[0] = tonumber(config.slide.fovColorR) or slide.fovColor[0]
            slide.fovColor[1] = tonumber(config.slide.fovColorG) or slide.fovColor[1]
            slide.fovColor[2] = tonumber(config.slide.fovColorB) or slide.fovColor[2]
            slide.fovColor[3] = tonumber(config.slide.fovColorA) or slide.fovColor[3]
        end
    end
end

local function saveConfig()
    local config = {
        slide = {
            FoVVHG = slide.FoVVHG[0],
            fovX = slide.fovX[0],
            fovY = slide.fovY[0],
            fovvaimbotcirculo = slide.fovvaimbotcirculo[0],
            DistanciaAIM = slide.DistanciaAIM[0],
            aimSmoothhhh = slide.aimSmoothhhh[0],
            fovCorAimmm = slide.fovCorAimmm[0],
            posiX = slide.posiX[0],
            posiY = slide.posiY[0],
            circulooPosX = slide.circulooPosX[0],
            circuloooPosY = slide.circuloooPosY[0],
            distancia = slide.distancia[0],
            fovColorR = slide.fovColor[0],
            fovColorG = slide.fovColor[1],
            fovColorB = slide.fovColor[2],
            fovColorA = slide.fovColor[3],
        }
    }
    local file = io.open(configFilePath, "w")
    if file then
        file:write(json.encode(config))
        file:close()
    end
end

local function randomizeToggleButtons()
    while sulist.ativarRandomizacao[0] do
        sulist.peito[0].Checked = math.random(0, 1) == 1
        sulist.braco[0].Checked = math.random(0, 1) == 1
        sulist.braco2[0].Checked = math.random(0, 1) == 1
        sulist.cabeca[0].Checked = math.random(0, 4) == 1
        
        wait(40)
    end
end

local function isAnyToggleButtonActive()
    return sulist.cabeca[0].Checked or sulist.perna[0].Checked or sulist.virilha[0].Checked or sulist.pernas2[0].Checked or sulist.peito[0].Checked or sulist.braco[0].Checked or sulist.braco2[0].Checked or ativarMatarAtravesDeParedes[0].Checked
end

local ui_meta = {
    __index = function(self, v)
        if v == "switch" then
            local switch = function()
                if self.process and self.process:status() ~= "dead" then
                    return false
                end
                self.timer = os.clock()
                self.state = not self.state

                self.process = lua_thread.create(function()
                    local bringFloatTo = function(from, to, start_time, duration)
                        local timer = os.clock() - start_time
                        if timer >= 0.00 and timer <= duration then
                            local count = timer / (duration / 100)
                            return count * ((to - from) / 100)
                        end
                        return (timer > duration) and to or from
                    end

                    while true do wait(0)
                        local a = bringFloatTo(0.00, 1.00, self.timer, self.duration)
                        self.alpha = self.state and a or 1.00 - a
                        if a == 1.00 then break end
                    end
                end)
                return true
            end
            return switch
        end
 
        if v == "alpha" then
            return self.state and 1.00 or 0.00
        end
    end
}

local menu = { state = false, duration = 1.15 }
setmetatable(menu, ui_meta)



--fim local aimbot

-- Tabela para armazenar os IDs dos jogadores que o aimbot deve ignorar
local ignoredPlayers = {}

-- Função para adicionar um ID à lista de ignorados
local function addIgnoredPlayer(playerId)
    if not table.contains(ignoredPlayers, playerId) then
        table.insert(ignoredPlayers, playerId)
    end
end

-- Função para remover um ID da lista de ignorados
local function removeIgnoredPlayer(playerId)
    for i, id in ipairs(ignoredPlayers) do
        if id == playerId then
            table.remove(ignoredPlayers, i)
            break
        end
    end
end

-- Configurações do aimbot
local slide = {
    fovColor = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    fovX = imgui.new.float(832.0),
    fovY = imgui.new.float(313.0),
    FoVVHG = imgui.new.float(150.0),
    distancia = imgui.new.int(1000),
    fovvaimbotcirculo = imgui.new.float(200),
    DistanciaAIM = imgui.new.float(1000.0),
    aimSmoothhhh = imgui.new.float(1.000),
    fovCorAimmm = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    fovCorsilent = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    espcores = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    posiX = imgui.new.float(0.520),
    posiY = imgui.new.float(0.439),
    circulooPosX = imgui.new.float(832.0),
    circuloooPosY = imgui.new.float(313.0),
    circuloFOV = false,
    qtdraios = imgui.new.int(5),
    raiosseguidos = imgui.new.int(10),
    larguraraios = imgui.new.int(40),
    HGPROAIM = imgui.new.int(1),
    minFov = 1,
    aimCtdr = imgui.new.int(1),
}

local sulist = {
    cabecaAIM = imgui.new.bool(),
    peitoAIM = imgui.new.bool(),
    bracoAIM = imgui.new.bool(),
    virilhaAIM = imgui.new.bool(),
    braco2AIM = imgui.new.bool(),
    pernaAIM = imgui.new.bool(),
    perna2AIM = imgui.new.bool(),
    PROAIM2 = imgui.new.bool(),
    aimbotparede = imgui.new.bool(false),
    lockAIM = imgui.new.bool()
}


local sampev = require "samp.events"

local ped_airbrake_enabled = false
local speed = 0.3
local was_in_car = false
local last_car
local isPedAirBrakeCheckboxActive = ffi.new("bool[1]", false) 
local autoRegenerarVida = imgui.new.bool(false)
local minusX, minusY = 231, 350
local font2 = renderCreateFont('Arial', 8, 5)

local var_0_10  

local FCR_BOLD = 1
local FCR_BORDER = 4
 
local function createFont()
    local var_0_10 = renderCreateFont("Arial", 12, 4, FCR_BOLD + FCR_BORDER)
    return var_0_10
end

local players = {}

local aim = {
    renderWindow = {
        renderWindow = imgui.new.bool()
    },
    CheckBox = {
        enableLagger = imgui.new.bool(),
        teste73 = imgui.new.bool()
    }
}

local cbugs = {
	lifefoot = imgui.new.bool(false),
	lifefoot1 = imgui.new.bool(false),
	shootingEnabled = imgui.new.bool(false),
	shootingEnabled1 = imgui.new.bool(false),
	clearAnimTime = imgui.new.float(200)
}

local tiroContador = 0
local miraAtual = 3
local currentWeaponID = 0
local shotCount = 0
local isActive = imgui.new.bool(false)
local weaponList = {}
local window = imgui.new.bool(false)
local config = {
    active_tab = imgui.new.int(1),
    godmod = imgui.new.bool(false),
    teste72 = new.bool(false),
    ANTICONGELAR = imgui.new.bool(),
    noreload = imgui.new.bool(false),    
    naotelaradm = new.bool(false),
    atrplay_enabled = new.bool(false),
    ativarfov = new.bool(false),
    alterarfov = new.float(60.0),
    noreload = imgui.new.bool(false),    
    nostun = imgui.new.bool(false),
    noreset = imgui.new.bool(false),
    espcar_enabled = new.bool(false),
    espcarlinha_enablade = new.bool(false),
    espinfo_enabled = new.bool(false),
    espplataforma = new.bool(false),
    ESP_ESQUELETO = imgui.new.bool(false),
    esp_enabled = new.bool(false),
    wallhack_enabled = new.bool(false),
    espcores = imgui.new.float[4](1.0, 1.0, 1.0, 1.0),
    dirsemcombus = imgui.new.bool(false),
    godcar = imgui.new.bool(false),
    motorcar = imgui.new.bool(false),
    pesadocar = imgui.new.bool(false),
    matararea_enabled = imgui.new.bool(false),
}

--[LOCAIS LOGICAS]

local function regenerarVida()
    lua_thread.create(function()
        while autoRegenerarVida[0] do
            wait(100)
            local vidaAtual = getCharHealth(PLAYER_PED)
            if vidaAtual < 100 then
                setCharHealth(PLAYER_PED, vidaAtual + 10)
            end
        end
    end)
end


imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    imgui.GetStyle():ScaleAllSizes(MDS)
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    local iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('Regular'), 18, config, iconRanges)

    local style = imgui.GetStyle()
    style.WindowRounding = 13 * MDS
    style.FramePadding = imgui.ImVec2(7 * MDS, 7 * MDS)
    style.ItemSpacing = imgui.ImVec2(10.0 * MDS, 5.0 * MDS)
    style.FrameRounding = 10 * MDS
    style.WindowBorderSize = 3.0 * MDS
    style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.0, 0.0, 0.0, 1.0)
    style.Colors[imgui.Col.Border] = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
    style.Colors[imgui.Col.Button] = imgui.ImVec4(1.0, 0.0, 0.0, 1.0)
    style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.8, 0.0, 0.0, 1.0)
    style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.6, 0.0, 0.0, 1.0)
    style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.1, 0.1, 0.1, 1.0)
    style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.2, 0.2, 0.2, 1.0)
    style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.3, 0.3, 0.3, 1.0)
    style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(1.0, 0.0, 0.0, 1.0)
    style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.8, 0.0, 0.0, 1.0)
end)

imgui.OnFrame(function()
    return window[0]
end, function()
    local resX, resY = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(700 * MDS, 450 * MDS), imgui.Cond.Always)

    imgui.Begin("NESCAU COMMUNITY", window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

    imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize("JUCA MENU 1.0").x) / 2)
    imgui.Text("JUCA MENU")
    imgui.SameLine()
    imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0), " 1.0")

    imgui.BeginChild("Aba", imgui.ImVec2(170 * MDS, imgui.GetWindowHeight() - 50 * MDS), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)

    local buttonSize = imgui.ImVec2(150 * MDS, 70 * MDS)

    if imgui.Button(faicons("USER") .. " PLAYER", buttonSize) then
        config.active_tab[0] = 1
        addOneOffSound(0, 0, 0, 1085)
    end

    if imgui.Button(faicons("raygun") .. " ARMAS", buttonSize) then
        config.active_tab[0] = 2
        addOneOffSound(0, 0, 0, 1085)
    end

    if imgui.Button(faicons("CAR") .. " VEÍCULOS", buttonSize) then
        config.active_tab[0] = 3
        addOneOffSound(0, 0, 0, 1085)
    end

    if imgui.Button(faicons("EYE") .. " ESP", buttonSize) then
        config.active_tab[0] = 4
        addOneOffSound(0, 0, 0, 1085)
    end

    if imgui.Button(faicons("CROSSHAIRS") .. " AIMBOT", buttonSize) then
        config.active_tab[0] = 5
        addOneOffSound(0, 0, 0, 1085)
    end

    imgui.EndChild()
    imgui.SameLine()

    imgui.BeginChild("Painel", imgui.ImVec2(imgui.GetWindowWidth() - 180 * MDS, imgui.GetWindowHeight() - 50 * MDS), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)

    if config.active_tab[0] == 1 then
        player_tabs()
    elseif config.active_tab[0] == 2 then
        armas_tabs()
    elseif config.active_tab[0] == 3 then
        veiculos_tabs()
    elseif config.active_tab[0] == 4 then
        esp_tabs()
    elseif config.active_tab[0] == 5 then
        aimbot_tabs()
    end

    imgui.EndChild()
    imgui.End()
end)

function aimbot_tabs()
    imgui.Separator()
    imgui.Text("Selecione onde o aimbot deve acertar:")
    imgui.CustomCheckbox("CABEÇA", sulist.cabecaAIM)
    imgui.CustomCheckbox("PEITO", sulist.peitoAIM)
    imgui.CustomCheckbox("BRAÇO ESQUERDO", sulist.bracoAIM)
    imgui.CustomCheckbox("BRAÇO DIREITO", sulist.braco2AIM)
    imgui.CustomCheckbox("VIRILHA", sulist.virilhaAIM)
    imgui.CustomCheckbox("PERNA ESQUERDA", sulist.pernaAIM)
    imgui.CustomCheckbox("PERNA DIREITA", sulist.perna2AIM)

    imgui.Separator()
    imgui.Text("CONFIGURAÇÕES DO AIMBOT:")
    imgui.SliderFloat("FOV", slide.fovvaimbotcirculo, 0, 500)
    imgui.SliderFloat("SUAVIZAÇÃO", slide.aimSmoothhhh, 0.1, 10.0)
end

function player_tabs()
    imgui.CustomCheckbox("GOD MOD", config.godmod)
    imgui.CustomCheckbox(u8'ANTI CAM SNIPER', config.teste72)
    if imgui.CustomCheckbox("UNFREEZER", config.ANTICONGELAR) then
    end
    imgui.CustomCheckbox('NÃO RECARREGAR', config.noreload)
    if imgui.CustomCheckbox("AIR BREAK", isPedAirBrakeCheckboxActive) then
        ped_airbrake_enabled = isPedAirBrakeCheckboxActive[0]
        if not ped_airbrake_enabled and not isCharInAnyCar(PLAYER_PED) then
            freezeCharPosition(PLAYER_PED, false)
            setCharCollision(PLAYER_PED, true)
        end

        if ped_airbrake_enabled then
            printStringNow("~g~Pedestrian AirBrake: on", 1000)
        else
            printStringNow("~r~Pedestrian AirBrake: off", 1000)
        end
    end
    imgui.CustomCheckbox("ADM NAO PUXAR", config.naotelaradm)
    imgui.CustomCheckbox("ATRAVESSAR PLAYER", config.atrplay_enabled)
    if imgui.CustomCheckbox("FOV", config.ativarfov) then
    end

    if config.ativarfov[0] then     
        imgui.SliderFloat("", config.alterarfov, 0.0, 150, "%.1f")
    end
    if imgui.CustomCheckbox("AUTO REGENERAÇÃO", autoRegenerarVida) then
        if autoRegenerarVida[0] then
            regenerarVida()
        end
    end
    imgui.CustomCheckbox('CHECAR JOGADORES PERTO', aim.CheckBox.teste73)
    
end

function armas_tabs()
    if imgui.CustomCheckbox("BYPASS", isActive) then
                if not isActive[0] then
                    for _, weaponID in pairs(weaponList) do
                        removeWeaponFromChar(PLAYER_PED, weaponID)
                    end
                    weaponList = {}
                end
                sendMessagebypass(isActive[0] and "{00ff00}ON" or "{ff0000}OFF")
            end
            
            if imgui.CustomCheckbox('NAO RESETAR ARMA', config.noreset) then            
            end                        
            imgui.CustomCheckbox(' FAST RELOAD', fastreload)
            imgui.CustomCheckbox(' ANT STUN', config.nostun)
            imgui.CustomCheckbox("CBUG", cbugs.shootingEnabled1) 
            if cbugs.shootingEnabled1[0] then
            imgui.SliderFloat("DEMORA DO CBUG", cbugs.clearAnimTime, 100, 1000)
            end    
            imgui.CustomCheckbox("CBUG/LIFE FOOT 2 TIROS", cbugs.shootingEnabled)
            imgui.CustomCheckbox("LIFE FOOT 1 TIRO", cbugs.lifefoot1)
            imgui.CustomCheckbox('LIFE FOOT 2 TIRO', cbugs.lifefoot)
                            
            imgui.InputInt('ID DA ARMA', weapon_id)
            imgui.InputInt('MUNIÇÃO', ammo)
            if imgui.Button('PUXAR ARMA') then
                giveGun(weapon_id[0], ammo[0])
            end            
            imgui.SameLine()
            if imgui.Button("REMOVER ARMAS") then
                removeAllCharWeapons(PLAYER_PED)
            end                  
end

function veiculos_tabs()           
            imgui.CustomCheckbox('GOD MOD CARRO', config.godcar)
            imgui.CustomCheckbox('MOTOR CARROS ON', config.motorcar)
            imgui.CustomCheckbox('ATRAVESSAR CARROS', config.pesadocar)
            imgui.CustomCheckbox('DIRIGIR SEM GASOLINA', config.dirsemcombus)            
            if imgui.CustomCheckbox("REPARAR VEÍCULO AUTOMATICAMENTE", reparar) then
            if not reparar[0] then
            reparar[0] = false
          end
         end
         if imgui.CustomCheckbox("CARRO ARCO-ÍRIS", rainbow) then
        if not rainbow[0] then
            rainbowSpeed = 500 
        end
    end
end

function esp_tabs()
    imgui.CustomCheckbox('ESP LINHA PLAYER', config.esp_enabled)
    imgui.CustomCheckbox('ESP ESQUELETO', config.ESP_ESQUELETO)
    imgui.CustomCheckbox('ESP NOME/VIDA/COLETE', config.wallhack_enabled)         
    imgui.CustomCheckbox('ESP LINHA CARRO', config.espcar_enabled)
    imgui.CustomCheckbox('ESP BOX CARRO', config.espcarlinha_enablade)
    imgui.CustomCheckbox('ESP INFO CARRO', config.espinfo_enabled)
    imgui.CustomCheckbox('ESP PLATAFORMA', config.espplataforma)
    imgui.ColorEdit4("ESP COR", config.espcores)
end

--[LOGICAS]

function imgui.CustomCheckbox(str_id, bool, a_speed)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local label = str_id:gsub("##.+", "") or ""
    local h = imgui.GetTextLineHeightWithSpacing() + 2
    local speed = a_speed or 0.2
    local function bringVec2To(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return imgui.ImVec2(from.x + (count * (to.x - from.x) / 100), from.y + (count * (to.y - from.y) / 100)), true
        end
        return (timer > duration) and to or from, false
    end
    local function bringVec4To(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return imgui.ImVec4(
                from.x + (count * (to.x - from.x) / 100),
                from.y + (count * (to.y - from.y) / 100),
                from.z + (count * (to.z - from.z) / 100),
                from.w + (count * (to.w - from.w) / 100)
            ), true
        end
        return (timer > duration) and to or from, false
    end
    local c = {
        {0.18536826495, 0.42833250947},
        {0.44109925858, 0.70010380622},
        {0.38825341901, 0.70010380622},
        {0.81248970176, 0.28238693976}
    }
    if UI_CUSTOM_CHECKBOX == nil then
        UI_CUSTOM_CHECKBOX = {}
    end
    if UI_CUSTOM_CHECKBOX[str_id] == nil then
        UI_CUSTOM_CHECKBOX[str_id] = {
            lines = {
                {
                    from = imgui.ImVec2(0, 0),
                    to = imgui.ImVec2(h * c[1][1], h * c[1][2]),
                    start = 0,
                    anim = false
                },
                {
                    from = imgui.ImVec2(0, 0),
                    to = bool[0] and imgui.ImVec2(h * c[2][1], h * c[2][2]) or imgui.ImVec2(h * c[1][1], h * c[1][2]),
                    start = 0,
                    anim = false
                },
                {
                    from = imgui.ImVec2(0, 0),
                    to = imgui.ImVec2(h * c[3][1], h * c[3][2]),
                    start = 0,
                    anim = false
                },
                {
                    from = imgui.ImVec2(0, 0),
                    to = bool[0] and imgui.ImVec2(h * c[4][1], h * c[4][2]) or imgui.ImVec2(h * c[3][1], h * c[3][2]),
                    start = 0,
                    anim = false
                }
            },
            hovered = false,
            h_start = 0
        }
    end
    local pool = UI_CUSTOM_CHECKBOX[str_id]
    imgui.BeginGroup()
    imgui.InvisibleButton(str_id, imgui.ImVec2(h, h))
    imgui.SameLine()
    local pp = imgui.GetCursorPos()
    imgui.SetCursorPos(imgui.ImVec2(pp.x, pp.y + h / 2 - imgui.CalcTextSize(label).y / 2))
    imgui.Text(label)
    imgui.EndGroup()
    local clicked = imgui.IsItemClicked()
    if pool.hovered ~= imgui.IsItemHovered() then
        pool.hovered = imgui.IsItemHovered()
        local timer = os.clock() - pool.h_start
        if timer <= speed and timer >= 0 then
            pool.h_start = os.clock() - (speed - timer)
        else
            pool.h_start = os.clock()
        end
    end
    if clicked then
        local isAnim = false
        for i = 1, 4 do
            if pool.lines[i].anim then
                isAnim = true
            end
        end
        if not isAnim then
            bool[0] = not bool[0]
            pool.lines[1].from = imgui.ImVec2(h * c[1][1], h * c[1][2])
            pool.lines[1].to =
                bool[0] and imgui.ImVec2(h * c[1][1], h * c[1][2]) or imgui.ImVec2(h * c[2][1], h * c[2][2])
            pool.lines[1].start = bool[0] and 0 or os.clock()
            pool.lines[2].from =
                bool[0] and imgui.ImVec2(h * c[1][1], h * c[1][2]) or imgui.ImVec2(h * c[2][1], h * c[2][2])
            pool.lines[2].to =
                bool[0] and imgui.ImVec2(h * c[2][1], h * c[2][2]) or imgui.ImVec2(h * c[2][1], h * c[2][2])
            pool.lines[2].start = bool[0] and os.clock() or 0
            pool.lines[3].from = imgui.ImVec2(h * c[3][1], h * c[3][2])
            pool.lines[3].to =
                bool[0] and imgui.ImVec2(h * c[3][1], h * c[3][2]) or imgui.ImVec2(h * c[4][1], h * c[4][2])
            pool.lines[3].start = bool[0] and 0 or os.clock() + speed
            pool.lines[4].from =
                bool[0] and imgui.ImVec2(h * c[3][1], h * c[3][2]) or imgui.ImVec2(h * c[4][1], h * c[4][2])
            pool.lines[4].to = imgui.ImVec2(h * c[4][1], h * c[4][2]) or imgui.ImVec2(h * c[4][1], h * c[4][2])
            pool.lines[4].start = bool[0] and os.clock() + speed or 0
        end
    end
    local pos = {}
    for i = 1, 4 do
        pos[i], pool.lines[i].anim =
            bringVec2To(p + pool.lines[i].from, p + pool.lines[i].to, pool.lines[i].start, speed)
    end
    local color = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    local c = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    local colorHovered =
        bringVec4To(
        pool.hovered and imgui.ImVec4(c.x, c.y, c.z, 0) or imgui.ImVec4(c.x, c.y, c.z, 0.2),
        pool.hovered and imgui.ImVec4(c.x, c.y, c.z, 0.2) or imgui.ImVec4(c.x, c.y, c.z, 0),
        pool.h_start,
        speed
    )
    DL:AddRectFilled(p, imgui.ImVec2(p.x + h, p.y + h), imgui.GetColorU32Vec4(colorHovered), h / 15, 15)
    DL:AddRect(p, imgui.ImVec2(p.x + h, p.y + h), imgui.GetColorU32Vec4(color), h / 15, 15, 1.5)
    DL:AddLine(pos[1], pos[2], imgui.GetColorU32Vec4(color), h / 10)
    DL:AddLine(pos[3], pos[4], imgui.GetColorU32Vec4(color), h / 10)
    return clicked
end

function sampev.onResetPlayerWeapons()
    if config.godmod[0] then
        return false
    end
end
function sampev.onBulletSync()
    if config.godmod[0] then
        return false
    end
end
function repararVeiculo()
    local vehicle = getCarCharIsUsing(PLAYER_PED)
    if vehicle ~= 0 then
        fixCar(vehicle)
        setCarHealth(vehicle, 1000.0)
    end
end
function sampev.onSetCameraBehind()
    if config.godmod[0] then
        return false
    end
end
function sampev.onTogglePlayerControllable()
    if config.godmod[0] then
        return false
    end
end
function sampev.onSetPlayerHealth(health)
    if config.godmod[0] then
        return false
    end
end
function sampev.onSendPlayerSync(data)
    if config.godmod[0] then
        data.health = 100
    end
end
function sampev.onSendVehicleSync(data)
    if config.godmod[0] then
        data.playerHealth = 100
    end
  end
function sampev.onSendRequestClass(classId)
    if config.godmod[0] then
        return false
    end
end
function sampev.onSendPlayerSync(arg_234_0)
	if config.teste72[0] then
		arg_234_0.specialAction = 3
	end
end
function getMoveSpeed(heading, speed)
    return math.sin(-math.rad(heading)) * speed, math.cos(-math.rad(heading)) * speed
  end
  
  function setPlayerCarCoordinatesFixed(x, y, z)
    local ox, oy, oz = getCharCoordinates(PLAYER_PED)
    setCharCoordinates(PLAYER_PED, ox, oy, oz)
    local nx, ny, nz = getCharCoordinates(PLAYER_PED)
    local xoff = nx - ox
    local yoff = ny - oy
    local zoff = nz - oz
  
    setCharCoordinates(PLAYER_PED, x - xoff, y - yoff, z - zoff)
  end
  function sampev.onSendVehicleSync(data)
    if car_airbrake_enabled then
      local mx, my = getMoveSpeed(getCharHeading(PLAYER_PED), speed > 2 and 2 or speed)
      data.moveSpeed.x = mx
      data.moveSpeed.y = my
    end
  end
  
  function processSpecialWidgets()
    local delta = 0
    if isWidgetPressed(WIDGET_ZOOM_IN) then
      delta = delta + speed / 2
    end
    if isWidgetPressed(WIDGET_ZOOM_OUT) then
      delta = delta - speed / 2
    end
    if isWidgetPressed(WIDGET_VIDEO_POKER_ADD_COIN) then
      speed = speed + 0.01
      if speed > 3.5 then speed = 3.5 end
      printStringNow('Speed: ' .. string.format("%.2f", speed), 500)
    end
    if isWidgetPressed(WIDGET_VIDEO_POKER_REMOVE_COIN) then
      speed = speed - 0.01
      if speed < 0.1 then speed = 0.1 end
      printStringNow('Speed: ' .. string.format("%.2f", speed), 500)
    end
  
    return delta
  end
  
  function processCarAirBrake()
    local x1, y1, z1 = getActiveCameraCoordinates()
    local x, y, z = getActiveCameraPointAt()
    local angle = -math.rad(getHeadingFromVector2d(x - x1, y - y1))
  
    if isCharInAnyCar(PLAYER_PED) then
      local car = storeCarCharIsInNoSave(PLAYER_PED)
      if car ~= last_car and last_car ~= nil and doesVehicleExist(last_car) and was_in_car then
        freezeCarPosition(last_car, false)
        setCarCollision(last_car, true)
      end
      was_in_car = true
      last_car = car
      freezeCarPosition(car, true)
      setCarCollision(car, false)
  
      local result, var_1, var_2 = isWidgetPressedEx(WIDGET_VEHICLE_STEER_ANALOG, 0)
      if not result then
        var_1 = 0
        var_2 = 0
      end
      local intensity_x = var_1 / 127
      local intensity_y = var_2 / 127
  
      local cx, cy, cz = getCharCoordinates(PLAYER_PED)
      cx = cx - (math.sin(angle) * speed * intensity_y)
      cy = cy - (math.cos(angle) * speed * intensity_y)
      cx = cx + (math.cos(angle) * speed * intensity_x)
      cy = cy - (math.sin(angle) * speed * intensity_x)
      cz = cz + processSpecialWidgets()
  
      setPlayerCarCoordinatesFixed(cx, cy, cz)
      setCarHeading(car, math.deg(-angle))
  
      if intensity_x ~= 0 then
        restoreCameraJumpcut()
      end
    else
      if was_in_car and last_car ~= nil and doesVehicleExist(last_car) then
        freezeCarPosition(last_car, false)
        setCarCollision(last_car, true)
      end
      was_in_car = false
      freezeCharPosition(PLAYER_PED, true)
      setCharCollision(PLAYER_PED, false)
    end
  end
  
  function processPedAirBrake()
    local x1, y1, z1 = getActiveCameraCoordinates()
    local x, y, z = getActiveCameraPointAt()
    local angle = -math.rad(getHeadingFromVector2d(x - x1, y - y1))
  
    if not isCharInAnyCar(PLAYER_PED) then
      local result, var_1, var_2 = isWidgetPressedEx(WIDGET_PED_MOVE, 0)
      if not result then
        var_1 = 0
        var_2 = 0
      end
      local intensity_x = var_1 / 127
      local intensity_y = var_2 / 127
  
      local cx, cy, cz = getCharCoordinates(PLAYER_PED)
      cx = cx - (math.sin(angle) * speed * intensity_y)
      cy = cy - (math.cos(angle) * speed * intensity_y)
      cx = cx + (math.cos(angle) * speed * intensity_x)
      cy = cy - (math.sin(angle) * speed * intensity_x)
      cz = cz + processSpecialWidgets()
  
      setCharCoordinatesNoOffset(PLAYER_PED, cx, cy, cz)
      setCharHeading(PLAYER_PED, math.deg(-angle))
  
      if intensity_x ~= 0 then
        restoreCameraJumpcut()
      end
    end
  end
  function atrplay()
    for playerId = 0, sampGetMaxPlayerId(true) do
        if sampIsPlayerConnected(playerId) then
            local result, playerPed = sampGetCharHandleBySampPlayerId(playerId)
            
            if result and isCharOnScreen(playerPed) and not isCharInAnyCar(playerPed) then
                local playerCoords = { getCharCoordinates(PLAYER_PED) }
                local targetCoords = { getCharCoordinates(playerPed) }
                
                local distance = math.sqrt(math.pow(targetCoords[1] - playerCoords[1], 2) +
                                           math.pow(targetCoords[2] - playerCoords[2], 2) +
                                           math.pow(targetCoords[3] - playerCoords[3], 2))
                
                if distance < 1 then
                    setCharCollision(playerPed, false)
                else
                    setCharCollision(playerPed, true)
                end
            end
        end
    end
end
function sampEvents.onSendPlayerSync(syncData)
    if isActive[0] then
        syncData.weapon = 0
    end
end
function ev.onResetPlayerWeapons()
    if config.noreset[0] then    
    return false
    end
end
function drawSkeletonESP()
    local playerPed = PLAYER_PED
    local px, py, pz = getCharCoordinates(playerPed)

    local function convertColorToHex(color)
        local r = math.floor(color[0] * 255)
        local g = math.floor(color[1] * 255)
        local b = math.floor(color[2] * 255)
        local a = math.floor(color[3] * 255)
        return (a * 16777216) + (r * 65536) + (g * 256) + b
    end

    local espcor = convertColorToHex(config.espcores)

    for _, char in ipairs(getAllChars()) do
        if char ~= playerPed then
            local result, id = sampGetPlayerIdByCharHandle(char)
            if result and isCharOnScreen(char) then
                for _, bone in ipairs(bones) do
                    local x1, y1, z1 = getBonePosition(char, bone)
                    local x2, y2, z2 = getBonePosition(char, bone + 1)
                    local r1, sx1, sy1 = convert3DCoordsToScreenEx(x1, y1, z1)
                    local r2, sx2, sy2 = convert3DCoordsToScreenEx(x2, y2, z2)
                    if r1 and r2 then
                        renderDrawLine(sx1, sy1, sx2, sy2, 3, espcor)
                    end
                end
            end
        end
    end
end

function renderWallhack()
    if not var_0_10 then
        var_0_10 = createFont() 
        if not var_0_10 then
            return
        end
    end

    local var_0_21 = config.wallhack_enabled
    if var_0_21[0] then
        local var_6_0 = getAllChars()

        for iter_6_0, iter_6_1 in ipairs(var_6_0) do
            if iter_6_1 ~= PLAYER_PED then
                local var_6_1, var_6_2 = sampGetPlayerIdByCharHandle(iter_6_1)

                if var_6_1 and isCharOnScreen(iter_6_1) then
                    local var_6_3, var_6_4, var_6_5 = getOffsetFromCharInWorldCoords(iter_6_1, 0, 0, 0)
                    local var_6_6, var_6_7 = convert3DCoordsToScreen(var_6_3, var_6_4, var_6_5 + 1)
                    local var_6_8, var_6_9 = convert3DCoordsToScreen(var_6_3, var_6_4, var_6_5 - 1)
                    local var_6_10 = math.abs((var_6_7 - var_6_9) * 0.25)
                    local var_6_11 = sampGetPlayerNickname(var_6_2) .. " (" .. tostring(var_6_2) .. ")"

                    if sampIsPlayerPaused(var_6_2) then
                        var_6_11 = "[AFK] " .. var_6_11
                    end

                    local var_6_12 = sampGetPlayerHealth(var_6_2)
                    local var_6_13 = sampGetPlayerArmor(var_6_2)
                    local var_6_14 = "{FF0000}" .. string.format("%.0f", var_6_12) .. "hp "
                    local var_6_15 = "{BBBBBB}" .. string.format("%.0f", var_6_13) .. "ap"
                    local var_6_16 = bit.bor(bit.band(sampGetPlayerColor(var_6_2), 16777215), 4278190080)

                    renderFontDrawText(var_0_10, var_6_11, var_6_6 - renderGetFontDrawTextLength(var_0_10, var_6_11) / 2, var_6_7 - renderGetFontDrawHeight(var_0_10) * 3.8, var_6_16)
                    renderDrawBoxWithBorder(var_6_6 - 24, var_6_7 - 45, 50, 6, 4278190080, 1, 4278190080)
                    renderDrawBoxWithBorder(var_6_6 - 24, var_6_7 - 45, var_6_12 / 2, 6, 4294901760, 1, 0)

                    if var_6_13 > 0 then
                        renderDrawBoxWithBorder(var_6_6 - 24, var_6_7 + renderGetFontDrawHeight(var_0_10) - 50, 50, 6, 4278190080, 1, 4278190080)
                        renderDrawBoxWithBorder(var_6_6 - 24, var_6_7 + renderGetFontDrawHeight(var_0_10) - 50, var_6_13 / 2, 6, 4294967295, 1, 0)
                    end
                end
            end
        end
    end
end

function esplinhacarro()
    local function convertColorToHex(color)
        local r = math.floor(color[0] * 255)
        local g = math.floor(color[1] * 255)
        local b = math.floor(color[2] * 255)
        local a = math.floor(color[3] * 255)
        return (a * 16777216) + (r * 65536) + (g * 256) + b
    end

    local espcor = convertColorToHex(config.espcores)
    local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
    local x, y = convert3DCoordsToScreen(playerX, playerY, playerZ)
        for k, i in ipairs(getAllVehicles()) do
        if isCarOnScreen(i) then
            local carX, carY, carZ = getCarCoordinates(i)
            local px, py = convert3DCoordsToScreen(carX, carY, carZ)                        
            local thickness = 2 
            renderDrawLine(x, y, px, py, thickness, espcor)
        end
    end
end

function renderESP()
    if not var_0_10 then
        var_0_10 = createFont() 
        if not var_0_10 then
            return 
        end
    end
    
    local function convertColorToHex(color)
        local r = math.floor(color[0] * 255)
        local g = math.floor(color[1] * 255)
        local b = math.floor(color[2] * 255)
        local a = math.floor(color[3] * 255)
        return (a * 16777216) + (r * 65536) + (g * 256) + b
    end

    local espcor = convertColorToHex(config.espcores)

    local var_0_25 = config.esp_enabled
    if var_0_25[0] then
        local var_6_41, var_6_42, var_6_43 = getCharCoordinates(PLAYER_PED)

        for iter_6_4 = 0, 999 do
            local var_6_44, var_6_45 = sampGetCharHandleBySampPlayerId(iter_6_4)

            if var_6_44 and doesCharExist(var_6_45) and isCharOnScreen(var_6_45) then
                local var_6_46, var_6_47, var_6_48 = getCharCoordinates(PLAYER_PED)
                local var_6_49, var_6_50, var_6_51 = getCharCoordinates(var_6_45)
                local var_6_52 = math.floor(getDistanceBetweenCoords3d(var_6_41, var_6_42, var_6_43, var_6_49, var_6_50, var_6_51))

                local colory
                if isLineOfSightClear(var_6_46, var_6_47, var_6_48, var_6_49, var_6_50, var_6_51, true, true, false, true, true) then
                    colory = espcor
                else
                    colory = 4294901760
                end

                if var_6_52 <= 1000 then
                    local var_6_53, var_6_54 = convert3DCoordsToScreen(var_6_41, var_6_42, var_6_43)
                    local var_6_55, var_6_56 = convert3DCoordsToScreen(var_6_49, var_6_50, var_6_51)

                    renderDrawLine(var_6_53, var_6_54, var_6_55, var_6_56, 2, colory)

                    local var_6_57 = string.format("%.1f", var_6_52)
                    renderFontDrawText(var_0_10, var_6_57 .. "m", var_6_55, var_6_56, espcor, false)
                end
            end
        end
    end
end
function espcarlinha()
    local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
    local x, y = convert3DCoordsToScreen(playerX, playerY, playerZ)
    
    local function convertColorToHex(color)
        local r = math.floor(color[0] * 255)
        local g = math.floor(color[1] * 255)
        local b = math.floor(color[2] * 255)
        local a = math.floor(color[3] * 255)
        return (a * 16777216) + (r * 65536) + (g * 256) + b
    end

    local espcor = convertColorToHex(config.espcores)

    for _, vehicle in ipairs(getAllVehicles()) do
        if isCarOnScreen(vehicle) then
            local carX, carY, carZ = getCarCoordinates(vehicle)
            local px, py = convert3DCoordsToScreen(carX, carY, carZ)
            local thickness = 2

            local corners = {
                { x = 1.5, y = 3, z = 1 }, 
                { x = 1.5, y = -3, z = 1 }, 
                { x = -1.5, y = -3, z = 1 },
                { x = -1.5, y = 3, z = 1 },
                { x = 1.5, y = 3, z = -1 },
                { x = 1.5, y = -3, z = -1 },
                { x = -1.5, y = -3, z = -1 },
                { x = -1.5, y = 3, z = -1 }
            }

            local boxCorners = {}
            for _, offset in ipairs(corners) do
                local worldX, worldY, worldZ = getOffsetFromCarInWorldCoords(vehicle, offset.x, offset.y, offset.z)
                local screenX, screenY = convert3DCoordsToScreen(worldX, worldY, worldZ)
                table.insert(boxCorners, { x = screenX, y = screenY })
            end

            for i = 1, 4 do
                local nextIndex = (i % 4 == 0 and i - 3) or (i + 1)
                renderDrawLine(boxCorners[i].x, boxCorners[i].y, boxCorners[nextIndex].x, boxCorners[nextIndex].y, thickness, espcor)
                renderDrawLine(boxCorners[i].x, boxCorners[i].y, boxCorners[i + 4].x, boxCorners[i + 4].y, thickness, espcor)
            end

            for i = 5, 8 do
                local nextIndex = (i % 4 == 0 and i - 3) or (i + 1)
                renderDrawLine(boxCorners[i].x, boxCorners[i].y, boxCorners[nextIndex].x, boxCorners[nextIndex].y, thickness, espcor)
            end
        end
    end
end

rainbowSpeed = 100

function getRainbowColor(timeOffset)
    local t = (os.clock() + timeOffset) * 0.5
    local r = math.sin(t * 2 * math.pi) * 0.5 + 0.5
    local g = math.sin((t + 0.33) * 2 * math.pi) * 0.5 + 0.5
    local b = math.sin((t + 0.66) * 2 * math.pi) * 0.5 + 0.5
    return math.floor(r * 126), math.floor(g * 126)
end

function carroArcoIris()
    if isCharInAnyCar(PLAYER_PED) then
        local vehicle = storeCarCharIsInNoSave(PLAYER_PED)
        if vehicle ~= 0 then
            rainbowSpeed = 100
            for t = 0, 1, 0.1 do
                local cor1, cor2 = getRainbowColor(t)
                changeCarColour(vehicle, cor1, cor2)
                wait(rainbowSpeed)
                rainbowSpeed = math.max(50, rainbowSpeed - 5)
            end
        end
    end
end

function espplataforma()
    local peds = getAllChars()
    
    local function convertColorToHex(color)
        local r = math.floor(color[0] * 255)
        local g = math.floor(color[1] * 255)
        local b = math.floor(color[2] * 255)
        local a = math.floor(color[3] * 255)
        return (a * 16777216) + (r * 65536) + (g * 256) + b
    end

    local espcor = convertColorToHex(config.espcores)
    
    for i = 2, #peds do
        local _, id = sampGetPlayerIdByCharHandle(peds[i])
        if peds[i] ~= nil and isCharOnScreen(peds[i]) and not sampIsPlayerNpc(id) then
            local x, y, z = getCharCoordinates(peds[i])
            local xs, ys = convert3DCoordsToScreen(x, y, z)
            if players[id] ~= nil then
                renderFontDrawText(font, players[id], xs - 23, ys, espcor)
            end
        end
    end
end

function events.onUnoccupiedSync(id, data)
    players[id] = "PC"
end

function events.onPlayerSync(id, data)
    if data.keysData == 160 then
        players[id] = "PC"
    end
    if data.specialAction ~= 0 and data.specialAction ~= 1 then
        players[id] = "PC"
    end
    if data.leftRightKeys ~= nil then
        if data.leftRightKeys ~= 128 and data.leftRightKeys ~= 65408 then
            players[id] = "Mobile"
        else
            if players[id] ~= "Mobile" then
                players[id] = "PC"
            end
        end
    end
    if data.upDownKeys ~= nil then
        if data.upDownKeys ~= 128 and data.upDownKeys ~= 65408 then
            players[id] = "Mobile"
        else
            if players[id] ~= "Mobile" then
                players[id] = "PC"
            end
        end
    end
end

function events.onVehicleSync(id, vehid, data)
    if data.leftRightKeys ~= 0 then
        if data.leftRightKeys ~= 128 and data.leftRightKeys ~= 65408 then
            players[id] = "Mobile"
        end
    end
end

function events.onPlayerQuit(id)
    players[id] = nil
end

function espinfo()
    for result, v in ipairs(getAllVehicles()) do   
        if v ~= nil and isCarOnScreen(v) then 
            local font = renderCreateFont("Arial", 12, 4, FCR_BOLD + FCR_BORDER)     
            local carX, carY, carZ = getCarCoordinates(v)        
            local carId = getCarModel(v)        
            local _, vehicleServerId = sampGetVehicleIdByCarHandle(v)
            local hp = getCarHealth(v)
            local carSpeed = getCarSpeed(v)
            local carinf1 = getNumberOfPassengers(v)
            local carinf4 = isCarEngineOn(v)
            local carcolor = getCarColours(v)
            local X, Y = convert3DCoordsToScreen(carX, carY, carZ + 1)
            
            local function convertColorToHex(color)
                local r = math.floor(color[0] * 255)
                local g = math.floor(color[1] * 255)
                local b = math.floor(color[2] * 255)
                local a = math.floor(color[3] * 255)
                return (a * 16777216) + (r * 65536) + (g * 256) + b
            end

            local espcor = convertColorToHex(config.espcores)
        
            local infoText = string.format("CARRO: %d (ID: %d)\nLataria: %d\nVelocidade: %.2f", 
                carId, vehicleServerId, hp, carSpeed)        
            renderFontDrawText(font, infoText, X, Y, espcor) 
        end
    end
end
function giveGun(weapon_id, ammo)
    if isCharInAnyCar(PLAYER_PED) then
        sendMessage("Você não pode puxar armas dentro de veículos.")
        return
    end
    local model_id = getWeapontypeModel(weapon_id)
    requestModel(model_id)
    loadAllModelsNow()
    giveWeaponToChar(PLAYER_PED, weapon_id, ammo)
end        
function matararea()
    areasafe = not areasafe
end
function lifefootmob()
    if cbugs.lifefoot[0] and isCharShooting(PLAYER_PED) then
        shotCount = shotCount + 1
        if shotCount % 2 == 0 then
            currentWeaponID = getCurrentCharWeapon(PLAYER_PED) 
            setCurrentCharWeapon(PLAYER_PED, 0) 
            wait(300)
            setCurrentCharWeapon(PLAYER_PED, currentWeaponID)
        end
    end
end
function lifefootmob1()
    if cbugs.lifefoot1[0] and isCharShooting(PLAYER_PED) then
        shotCount = shotCount + 1
        if shotCount % 1 == 0 then
            currentWeaponID = getCurrentCharWeapon(PLAYER_PED) 
            setCurrentCharWeapon(PLAYER_PED, 0) 
            wait(300)
            setCurrentCharWeapon(PLAYER_PED, currentWeaponID)
        end
    end
end
function checkPlayerShooting()
    if cbugs.shootingEnabled[0] and isCharShooting(PLAYER_PED) then
        shotCount = shotCount + 1
        if shotCount % 2 == 0 then
            currentWeaponID = getCurrentCharWeapon(PLAYER_PED) 
            setCurrentCharWeapon(PLAYER_PED, 0) 
            wait(300)
            setCurrentCharWeapon(PLAYER_PED, currentWeaponID)
        end
        
        wait(200)
        clearCharTasksImmediately(PLAYER_PED)
    end
end
function checkPlayerShooting1()
    if cbugs.shootingEnabled1[0] and isCharShooting(PLAYER_PED) then
        wait(cbugs.clearAnimTime[0])
        clearCharTasksImmediately(PLAYER_PED)
    end
end
function getNearCharToCenter()
    local closestId = -1
    local closestDist = 99999

    for i = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) then
            local result, ped = sampGetCharHandleBySampPlayerId(i)
            if result and not shouldIgnorePlayer(i) then
                local px, py, pz = getCharCoordinates(ped)
                local cx, cy, cz = getCharCoordinates(PLAYER_PED)
                local dist = getDistanceBetweenCoords3d(px, py, pz, cx, cy, cz)
                if dist < closestDist then
                    closestDist = dist
                    closestId = i
                end
            end
        end
    end

    return closestId
end

function Aimbot()
    function getCameraRotation()
        local horizontalAngle = camera.aCams[0].fHorizontalAngle
        local verticalAngle = camera.aCams[0].fVerticalAngle
        return horizontalAngle, verticalAngle
    end

    function setCameraRotation(configaimbotHorizontal, configaimbotVertical)
        camera.aCams[0].fHorizontalAngle = configaimbotHorizontal
        camera.aCams[0].fVerticalAngle = configaimbotVertical
    end

    function convertCartesianCoordinatesToSpherical(configaimbot)
        local coordsDifference = configaimbot - vector3d(getActiveCameraCoordinates())
        local length = coordsDifference:length()
        local angleX = math.atan2(coordsDifference.y, coordsDifference.x)
        local angleY = math.acos(coordsDifference.z / length)

        if angleX > 0 then
            angleX = angleX - math.pi
        else
            angleX = angleX + math.pi
        end

        local angleZ = math.pi / 2 - angleY
        return angleX, angleZ
    end

    function getCrosshairPositionOnScreen()
        local screenWidth, screenHeight = getScreenResolution()
        local crosshairX = screenWidth * slide.posiX[0]
        local crosshairY = screenHeight * slide.posiY[0]
        return crosshairX, crosshairY
    end

    function getCrosshairRotation(configaimbot)
        configaimbot = configaimbot or 5
        local crosshairX, crosshairY = getCrosshairPositionOnScreen()
        local worldCoords = vector3d(convertScreenCoordsToWorld3D(crosshairX, crosshairY, configaimbot))
        return convertCartesianCoordinatesToSpherical(worldCoords)
    end

    function aimAtPointWithM16(configaimbot)
        local sphericalX, sphericalY = convertCartesianCoordinatesToSpherical(configaimbot)
        local cameraRotationX, cameraRotationY = getCameraRotation()
        local crosshairRotationX, crosshairRotationY = getCrosshairRotation()
        local newRotationX = cameraRotationX + (sphericalX - crosshairRotationX) * slide.aimSmoothhhh[0]
        local newRotationY = cameraRotationY + (sphericalY - crosshairRotationY) * slide.aimSmoothhhh[0]
        setCameraRotation(newRotationX, newRotationY)
    end

    function aimAtPointWithSniperScope(configaimbot)
        local sphericalX, sphericalY = convertCartesianCoordinatesToSpherical(configaimbot)
        setCameraRotation(sphericalX, sphericalY)
    end

    function getNearCharToCenter(configaimbot)
    local nearChars = {}
    local screenWidth, screenHeight = getScreenResolution()

    for _, char in ipairs(getAllChars()) do
        -- Obter o ID do jogador
        local res, playerId = sampGetPlayerIdByCharHandle(char)
        if res and isCharOnScreen(char) and char ~= PLAYER_PED and not isCharDead(char) and not shouldIgnorePlayer(playerId) then
            local charX, charY, charZ = getCharCoordinates(char)
            local screenX, screenY = convert3DCoordsToScreen(charX, charY, charZ)
            local distance = getDistanceBetweenCoords2d(screenWidth / 1.923 + slide.posiX[0], screenHeight / 2.306 + slide.posiY[0], screenX, screenY)

            if isCurrentCharWeapon(PLAYER_PED, 34) then
                distance = getDistanceBetweenCoords2d(screenWidth / 2, screenHeight / 2, screenX, screenY)
            end

            if distance <= tonumber(configaimbot and configaimbot or screenHeight) then
                table.insert(nearChars, {
                    distance,
                    char
                })
            end
        end
    end

    if #nearChars > 0 then
        table.sort(nearChars, function(a, b)
            return a[1] < b[1]
        end)
        return nearChars[1][2]
    end

    return nil
end

    local distancia = slide.DistanciaAIM[0]
    local nMode = camera.aCams[0].nMode
    local nearChar = getNearCharToCenter(slide.fovvaimbotcirculo[0] + 1.923)
    
    if nearChar then
            local boneX, boneY, boneZ = getBonePosition(nearChar, 5)
        if boneX and boneY and boneZ then
            local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
            local distanceToBone = getDistanceBetweenCoords3d(playerX, playerY, playerZ, boneX, boneY, boneZ)
    
            if not sulist.aimbotparede[0] then
                local targetX, targetY, targetZ = boneX, boneY, boneZ
                local hit, colX, colY, colZ, entityHit = processLineOfSight(playerX, playerY, playerZ, targetX, targetY, targetZ, true, true, false, true, false, false, false, false)
                if hit and entityHit ~= nearChar then
                    return
                end
            else
                local targetX, targetY, targetZ = boneX, boneY, boneZ
            end
    
            if distanceToBone < distancia then
                local point
    
                if sulist.cabecaAIM[0] then
                    local headX, headY, headZ = getBonePosition(nearChar, 5)
                    point = vector3d(headX, headY, headZ)
                end
    
                if sulist.peitoAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 3)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.virilhaAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 1)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.bracoAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 33)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.braco2AIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 23)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.pernaAIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 52)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.perna2AIM[0] then
                    local chestX, chestY, chestZ = getBonePosition(nearChar, 42)
                    point = vector3d(chestX, chestY, chestZ)
                end
                
                if sulist.lockAIM[0] then
                    local partX, partY, partZ = getBonePosition(nearChar, miraAtual)
                    point = vector3d(partX, partY, partZ)

                    local parts = {}

                    if sulist.cabecaAIM[0] then
                        table.insert(parts, 5)
                    end
                    if sulist.peitoAIM[0] then
                        table.insert(parts, 3)
                    end
                    if sulist.virilhaAIM[0] then
                        table.insert(parts, 1)
                    end
                    if sulist.bracoAIM[0] then
                        table.insert(parts, 33)
                    end
                    if sulist.braco2AIM[0] then
                        table.insert(parts, 23)
                    end
                    if sulist.pernaAIM[0] then
                        table.insert(parts, 52)
                    end
                    if sulist.perna2AIM[0] then
                        table.insert(parts, 42)
                    end

                    if not miraAtualIndex then
                        miraAtualIndex = 1
                    end

                    if #parts > 0 then
                        if isCharShooting(PLAYER_PED) then
                            tiroContador = tiroContador + 1

                            if tiroContador >= slide.aimCtdr[0] then
                                tiroContador = 0
                                miraAtualIndex = (miraAtualIndex % #parts) + 1
                                miraAtual = parts[miraAtualIndex]
                            end
                        end

                        local partX, partY, partZ = getBonePosition(nearChar, miraAtual)
                        point = vector3d(partX, partY, partZ)
                    end
                end
    
                if point then
                    if nMode == 7 then
                        aimAtPointWithSniperScope(point)
                    elseif nMode == 53 then
                        aimAtPointWithM16(point)
                    end
                end
            end
        end
    end
end

function drawCircle(x, y, radius, color)
    local segments = 300 * DPI
    local angleStep = (2 * math.pi) / segments
    local lineWidth = 1.5 * DPI

    for i = 0, segments - 0 do
        local angle1 = i * angleStep
        local angle2 = (i + 1) * angleStep
        
        local x1 = x + (radius - lineWidth / 2) * math.cos(angle1)
        local y1 = y + (radius - lineWidth / 2) * math.sin(angle1)
        local x2 = x + (radius - lineWidth / 2) * math.cos(angle2)
        local y2 = y + (radius - lineWidth / 2) * math.sin(angle2)
        
        renderDrawLine(x1, y1, x2, y2, lineWidth, color)
    end
end

function isPlayerInFOV(playerX, playerY)
    local dx = playerX - slide.fovX[0]
    local dy = playerY - slide.fovY[0]
    local distanceSquared = dx * dx + dy * dy
    return distanceSquared <= slide.FoVVHG[0] * slide.FoVVHG[0]
end

function colorToHex(r, g, b, a)
    return bit.bor(bit.lshift(math.floor(a * 255), 24), bit.lshift(math.floor(r * 255), 16), bit.lshift(math.floor(g * 255), 8), math.floor(b * 255))
end

function getBonePosition(ped, bone)
  local pedptr = ffi.cast('void*', getCharPointer(ped))
  local posn = ffi.new('RwV3d[1]')
  gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
  return posn[0].x, posn[0].y, posn[0].z
end

function fix(angle)
    if angle > math.pi then
        angle = angle - (math.pi * 2)
    elseif angle < -math.pi then
        angle = angle + (math.pi * 2)
    end
    return angle
end

function getDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
lua_thread.create(
    function()
        while true do
            wait(0)
            if config.godmod[0] then
                setCharHealth(PLAYER_PED, 120)
                setCharProofs(PLAYER_PED, true, true, true, true, true)
            else
                setCharProofs(PLAYER_PED, false, false, false, false, false)
            end
        end
    end
)

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    repeat wait(0) until isSampAvailable()

    sampRegisterChatCommand("jucamenu", function()
        window[0] = not window[0]
    end)

    while true do
        wait(0)
        
        -- Abre/Fecha Menu ao deslizar o radar para a esquerda
        if isWidgetSwipedLeft(WIDGET_RADAR) then
            window[0] = not window[0]
        end

        -- Renderiza jogadores perto
        if aim.CheckBox.teste73[0] then
            local instream = 'Jogadores Perto\n'
            local count = 0
            for i = 0, 1001 do
                if sampIsPlayerConnected(i) then
                    local playerHandle = sampGetCharHandleBySampPlayerId(i)
                    if playerHandle then
                        instream = instream .. sampGetPlayerNickname(i) .. '[' .. i .. ']\n'
                        count = count + 1
                    end
                end
            end
            instream = instream .. 'Contador: ' .. count
            local sw, sh = getScreenResolution()
            renderFontDrawText(font2, instream, sw - minusX, sh - minusY, -1)
        end

        lua_thread.create(Aimbot)
        imgui.Process = window

        -- Anti-Congelamento
        if config.ANTICONGELAR and config.ANTICONGELAR[0] then
            freezeCharPosition(PLAYER_PED, false)
        end

        -- Evita congelamento em teletransportes
        sampev.onSetPlayerPos = function()
            return not config.naotelaradm[0]
        end

        -- FOV Dinâmico
        if config.ativarfov[0] then
            cameraSetLerpFov(config.alterarfov[0], 101, 1000, true)
        end

        -- Funções adicionais
        if config.matararea_enabled then matararea() end
        if car_airbrake_enabled then processCarAirBrake() end
        checkPlayerShooting1()
        checkPlayerShooting()
        lifefootmob()
        lifefootmob1()

        -- Fast Reload
        if fastreload[0] then
            setPlayerFastReload(playerHandle, true)
            local anims = {
                "TEC_RELOAD", "buddy_reload", "buddy_crouchreload", "colt45_reload",
                "colt45_crouchreload", "sawnoff_reload", "python_reload", "python_crouchreload",
                "RIFLE_load", "RIFLE_crouchload", "Silence_reload", "CrouchReload", 
                "UZI_reload", "UZI_crouchreload"
            }
            for _, anim in ipairs(anims) do
                setCharAnimSpeed(PLAYER_PED, anim, 20)
            end
        else
            setPlayerFastReload(playerHandle, false)
        end

        -- No Stun
        if config.nostun[0] then
            local anims = {
                "DAM_armL_frmBK", "DAM_armL_frmFT", "DAM_armL_frmLT", "DAM_armR_frmBK",
                "DAM_armR_frmFT", "DAM_armR_frmRT", "DAM_LegL_frmBK", "DAM_LegL_frmFT",
                "DAM_LegL_frmLT", "DAM_LegR_frmBK", "DAM_LegR_frmFT", "DAM_LegR_frmRT",
                "DAM_stomach_frmBK", "DAM_stomach_frmFT", "DAM_stomach_frmLT", "DAM_stomach_frmRT"
            }
            for _, anim in ipairs(anims) do
                setCharAnimSpeed(PLAYER_PED, anim, 999)
            end
        end

        -- Motor sem combustível
        if config.dirsemcombus[0] and isCharInAnyCar(PLAYER_PED) and bp then
            switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
        end

        -- Motor automático
        if config.motorcar[0] and isCharInAnyCar(PLAYER_PED) then
            switchCarEngine(storeCarCharIsInNoSave(PLAYER_PED), true)
        end

        -- Carro Godmode
        if config.godcar[0] and isCharInAnyCar(PLAYER_PED) then
            local vehicle = getCarCharIsUsing(PLAYER_PED)
            setCarProofs(vehicle, true, true, true, true, true)
            setCanBurstCarTires(vehicle, false)
            setCarHealth(vehicle, 1000)
        end

        -- Pesado Carro
        if config.pesadocar[0] and isCharInAnyCar(PLAYER_PED) then
            local car = getCarCharIsUsing(PLAYER_PED)
            for _, handle in ipairs(getAllVehicles()) do
                if handle ~= car then
                    setCarCollision(handle, false)
                end
            end
        end

        -- Reparar Veículo
        if reparar[0] then repararVeiculo() end

        -- Carro Arco-Íris
        if rainbow[0] then carroArcoIris() end

        -- Airbrake
        if ped_airbrake_enabled then processPedAirBrake() end

        -- ATR Play
        if config.atrplay_enabled[0] then atrplay() end
        
        if config.noreload[0] then
            local weap = getCurrentCharWeapon(PLAYER_PED)
            local nbs = raknetNewBitStream()
            raknetBitStreamWriteInt32(nbs, weap)
            raknetBitStreamWriteInt32(nbs, 0)
            raknetEmulRpcReceiveBitStream(22, nbs)
            raknetDeleteBitStream(nbs)
        end


        if config.esp_enabled[0] then renderESP() end
        if config.ESP_ESQUELETO[0] then drawSkeletonESP() end
        if config.wallhack_enabled[0] then renderWallhack() end
        if config.espcar_enabled[0] then esplinhacarro() end
        if config.espcarlinha_enablade[0] then espcarlinha() end
        if config.espinfo_enabled[0] then espinfo() end
        if config.espplataforma[0] then espplataforma() end

        local circuloFOVAIM = sulist.cabecaAIM[0] or sulist.peitoAIM[0] or sulist.virilhaAIM[0]
                                or sulist.bracoAIM[0] or sulist.braco2AIM[0] or sulist.pernaAIM[0] or sulist.lockAIM[0] or sulist.perna2AIM[0]
        
        local screenWidth, screenHeight = getScreenResolution()
        local circleX = screenWidth / 1.923
        local circleY = screenHeight / 2.306

        if circuloFOVAIM then
            if isCurrentCharWeapon(PLAYER_PED, 34) then
                local newCircleX = screenWidth / 2
                local newCircleY = screenHeight / 2
                local newRadius = slide.fovvaimbotcirculo[0]
                local colorHex = colorToHex(slide.fovCorAimmm[0], slide.fovCorAimmm[1], slide.fovCorAimmm[2], slide.fovCorAimmm[3])
                drawCircle(newCircleX, newCircleY, newRadius, colorHex)
            elseif not isCurrentCharWeapon(PLAYER_PED, 0) then
                local radius = slide.fovvaimbotcirculo[0]
                local colorHex = colorToHex(slide.fovCorAimmm[0], slide.fovCorAimmm[1], slide.fovCorAimmm[2], slide.fovCorAimmm[3])
                drawCircle(circleX, circleY, radius, colorHex)
            end
        end
    end
end

        