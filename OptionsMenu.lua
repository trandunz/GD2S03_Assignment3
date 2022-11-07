--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : OptionsMenu.lua
--Description : OptionsMenu Implementation File
--Author : Will Inman

local OptionsMenu = {};

local GUI = require("GUI");

function OptionsMenu:new(_optionsMenu)
  _optionsMenu = _optionsMenu or {AudioManager = require("AudioManager"):new(), MenuSelection = 0, Destroy = false};
  setmetatable(_optionsMenu, self);
  self.__index = self;
  return _optionsMenu;
end

function OptionsMenu:Create()
  GUI = require("GUI"):new();
  self.BG = require("Sprite"):new();
  self.BG:Create("Resources/Textures/GUI/WinScreen/Board.png", WindowSize.x/2, WindowSize.y/2);

  GUI:CreateText("VolumeHeader", "Volume", WindowSize.x/2, (WindowSize.y/2) - 100, "center", 0, 32);
  GUI.Elements.VolumeHeader:SetScale(1.5,1.5);

  GUI:CreateText("Return", "Return", WindowSize.x/2, (WindowSize.y/2) + 50, "center", 0, 32);
  GUI.Elements.Return:SetScale(0.8,0.8);

  GUI:CreateText("MasterVolume", "Master", WindowSize.x/2 - 90, (WindowSize.y/2) - 40, "left", 0, 32);
  GUI.Elements.MasterVolume:SetScale(0.8,0.8);
  GUI:CreateText("MasterCounter", "0.5", WindowSize.x/2 + 40, (WindowSize.y/2) - 40, "left", 0, 32);
  GUI.Elements.MasterCounter:SetScale(0.8,0.8);

  GUI:CreateText("MusicVolume", "Music", WindowSize.x/2 - 90, (WindowSize.y/2) - 10, "left", 0, 32);
  GUI.Elements.MusicVolume:SetScale(0.8,0.8);
  GUI:CreateText("MusicCounter", "0.5", WindowSize.x/2 + 40, (WindowSize.y/2) - 10, "left", 0, 32);
  GUI.Elements.MusicCounter:SetScale(0.8,0.8);

  GUI:CreateText("EffectsVolume", "Effects", WindowSize.x/2 - 90, (WindowSize.y/2) + 20, "left", 0, 32);
  GUI.Elements.EffectsVolume:SetScale(0.8,0.8);
  GUI:CreateText("EffectsCounter", "0.5", WindowSize.x/2 + 40, (WindowSize.y/2) + 20, "left", 0, 32);
  GUI.Elements.EffectsCounter:SetScale(0.8,0.8);
end

function OptionsMenu:Update(_dt)
  self.AudioManager:Update();

  GUI.Elements.MasterVolume:SetColor(150,150,150);
  GUI.Elements.MusicVolume:SetColor(150,150,150);
  GUI.Elements.EffectsVolume:SetColor(150,150,150);
  GUI.Elements.Return:SetColor(150,150,150);

  GUI.Elements.MasterCounter.String = tostring(MasterVolume);
  GUI.Elements.MusicCounter.String = tostring(MusicVolume);
  GUI.Elements.EffectsCounter.String = tostring(EffectVolume);

  if self.MenuSelection == 0 then
    GUI.Elements.MasterVolume:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    GUI.Elements.MusicVolume:SetColor(255,255,255);
  elseif self.MenuSelection == 2 then
    GUI.Elements.EffectsVolume:SetColor(255,255,255);
  elseif self.MenuSelection == 3 then
    GUI.Elements.Return:SetColor(255,255,255);
  end
end

function OptionsMenu:KeyEvents( key, scancode, isrepeat )
  math.randomseed(os.time());
  local randomSound = math.random(1,3);

  if key == "up" then
    self.MenuSelection = self.MenuSelection - 1;
  end
  if key == "down" then
    self.MenuSelection = self.MenuSelection + 1;
  end
  if key == "right" then
    self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
    if self.MenuSelection == 0 then
      MasterVolume = MasterVolume + 0.1;
      if MasterVolume > 0.9 then
        MasterVolume = 1;
      end
    elseif self.MenuSelection == 1 then
      MusicVolume = MusicVolume + 0.1;
      if MusicVolume > 0.9 then
        MusicVolume = 1;
      end

    elseif self.MenuSelection == 2 then
      EffectVolume = EffectVolume + 0.1;
      if EffectVolume > 0.9 then
        EffectVolume = 1;
      end
    end
  end
  if key == "left" then
    self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
    if self.MenuSelection == 0 then
      MasterVolume = MasterVolume - 0.1;
      if MasterVolume < 0.1 then
        MasterVolume = 0;
      end
    elseif self.MenuSelection == 1 then
      MusicVolume = MusicVolume - 0.1;
      if MusicVolume < 0.1 then
        MusicVolume = 0;
      end
    elseif self.MenuSelection == 2 then
      EffectVolume = EffectVolume - 0.1;
      if EffectVolume < 0.1 then
        EffectVolume = 0;
      end
    end
  end
  if key == "return" then
    if self.MenuSelection == 3 then
      self.Destroy = true;
    end
  end

  if self.MenuSelection < 0 then
    self.MenuSelection = 0;
  elseif self.MenuSelection > 3 then
    self.MenuSelection = 3;
  end
end

function OptionsMenu:Cleanup()
  GUI:Cleanup();
  self.AudioManager:ForceCleanup();
end

function OptionsMenu:Draw()
    self.BG:Draw()
    GUI:Draw();
end

return OptionsMenu;
