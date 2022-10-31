local PauseMenu = {};

local GUI = require("GUI");

function PauseMenu:new(_pauseMenu)
  _pauseMenu = _pauseMenu or {AudioManager = require("AudioManager"):new(), MenuSelection = 0, Destroy = false};
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

function PauseMenu:KeyEvents( key, scancode, isrepeat )
  math.randomseed(os.time());
  local randomSound = math.random(1,3);

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

function PauseMenu:Cleanup()
  TimeScale = 1;
  GUI:Cleanup();
  self.AudioManager:ForceCleanup();
end

function PauseMenu:Draw()
    self.BG:Draw()
    GUI:Draw();
end

return PauseMenu;
