--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : PauseMenu.lua
--Description : PauseMenu Implementation File
--Author : Will Inman

local PauseMenu = {};

local GUI = require("GUI");

function PauseMenu:new(_pauseMenu)
  _pauseMenu = _pauseMenu or {AudioManager = require("AudioManager"):new(), MenuSelection = 0, Destroy = false,
OptionsMenu};
  setmetatable(_pauseMenu, self);
  self.__index = self;
  return _pauseMenu;
end

function PauseMenu:Create()
  TimeScale = 0;
  GUI = require("GUI"):new();
  self.BG = require("Sprite"):new();
  self.BG:Create("Resources/Textures/GUI/WinScreen/Board.png", WindowSize.x/2, WindowSize.y/2);

  GUI:CreateText("Resume", "Resume", WindowSize.x/2, (WindowSize.y/2) - 90, "center", 0, 32);
  GUI.Elements.Resume:SetScale(2,2);

  GUI:CreateText("Options", "Options", WindowSize.x/2, WindowSize.y/2 - 40, "center", 0, 32);
  GUI.Elements.Options:SetScale(2,2);

  GUI:CreateText("Exit", "Exit",  WindowSize.x/2, (WindowSize.y/2) + 10, "center", 0, 32);
  GUI.Elements.Exit:SetScale(2,2);
end

function PauseMenu:Update(_dt)
  self.AudioManager:Update();

  if self.OptionsMenu then
    self.OptionsMenu:Update(_dt);

    if self.OptionsMenu.Destroy then
      self.OptionsMenu:Cleanup();
      self.OptionsMenu = nil;
    end
  else
    GUI.Elements.Resume:SetColor(150,150,150);
    GUI.Elements.Options:SetColor(150,150,150);
    GUI.Elements.Exit:SetColor(150,150,150);

    if self.MenuSelection == 0 then
      GUI.Elements.Resume:SetColor(255,255,255);
    elseif self.MenuSelection == 1 then
      GUI.Elements.Options:SetColor(255,255,255);
    elseif self.MenuSelection == 2 then
      GUI.Elements.Exit:SetColor(255,255,255);
    end
  end
end

function PauseMenu:KeyEvents( key, scancode, isrepeat )
  math.randomseed(os.time());
  local randomSound = math.random(1,3);

  if self.OptionsMenu then
    self.OptionsMenu:KeyEvents(key, scancode, isrepeat);

    if key == "up" then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
    end
    if key == "down" then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
    end
    if key == "return" then
      self.AudioManager:CreateSound("Confirm", "Resources/Sounds/GUI/Confirm.wav", true, false);
    end
  else
    if key == "up" then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
      self.MenuSelection = self.MenuSelection - 1;
    end
    if key == "down" then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
      self.MenuSelection = self.MenuSelection + 1;
    end
    if key == "return" then
      self.AudioManager:CreateSound("Confirm", "Resources/Sounds/GUI/Confirm.wav", true, false);
      if self.MenuSelection == 0 then
        -- Close Pause Menu
        self.Destroy = true;
      elseif self.MenuSelection == 1 then
        self.OptionsMenu = require("OptionsMenu"):new();
        self.OptionsMenu:Create();
      elseif self.MenuSelection == 2 then
        LevelLoader:LoadLevel("Scene_Overworld");
        self:Cleanup();
      end
    end

    if self.MenuSelection < 0 then
      self.MenuSelection = 0;
    elseif self.MenuSelection > 2 then
      self.MenuSelection = 2;
    end
  end
end

function PauseMenu:Cleanup()
  TimeScale = 1;
  GUI:Cleanup();
  self.AudioManager:ForceCleanup();
  if self.OptionsMenu then
    self.OptionsMenu:Cleanup();
  end
end

function PauseMenu:Draw()
    if self.OptionsMenu then
      self.OptionsMenu:Draw();
    else
      self.BG:Draw()
      GUI:Draw();
    end
end

return PauseMenu;
