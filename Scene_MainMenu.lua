local MainMenu = {};

local GUI = require("GUI");

function MainMenu:new(_mainMenu)
  _mainMenu = _mainMenu or {BG = require("Sprite"):new(), Play = require("Text"):new(),Options = require("Text"):new(),Exit = require("Text"):new(), MenuSelection = 0,
AudioManager = require("AudioManager"):new()};
  setmetatable(_mainMenu, self);
  self.__index = self;
  return _mainMenu;
end

function MainMenu:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();
end

function MainMenu:Start()
    GUI = require("GUI"):new()

    self.AudioManager:CreateMusic("Music", "Resources/Music/LastCourse.mp3", true, true, "stream");

    GUI:CreateText("Play", "Play", WindowSize.x/2, (WindowSize.y/2) - 50, "center", 0, 32);
    GUI.Elements.Play:SetScale(2,2);

    GUI:CreateText("Options", "Options", WindowSize.x/2, WindowSize.y/2, "center", 0, 32);
    GUI.Elements.Options:SetScale(2,2);

    GUI:CreateText("Exit", "Exit",  WindowSize.x/2, (WindowSize.y/2) + 50, "center", 0, 32);
    GUI.Elements.Exit:SetScale(2,2);

    self.BG:Create("Resources/Textures/MainMenu.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(1,1);
end

function MainMenu:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  GUI.Elements.Play:SetColor(150,150,150);
  GUI.Elements.Options:SetColor(150,150,150);
  GUI.Elements.Exit:SetColor(150,150,150);

  if self.MenuSelection == 0 then
    GUI.Elements.Play:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    GUI.Elements.Options:SetColor(255,255,255);
  elseif self.MenuSelection == 2 then
    GUI.Elements.Exit:SetColor(255,255,255);
  end
end

function MainMenu:KeyEvents( key, scancode, isrepeat )
  math.randomseed(os.time());
  local randomSound = math.random(1,3);

  if key == "6" then
    LevelLoader:LoadLevel("Scene_YouWin");
  end

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
      LevelLoader:LoadLevel("Scene_Overworld");
    elseif self.MenuSelection == 1 then
    elseif self.MenuSelection == 2 then
      love.event.quit();
    end
  end

  if self.MenuSelection < 0 then
    self.MenuSelection = 0;
  elseif self.MenuSelection > 2 then
    self.MenuSelection = 2;
  end
end

function MainMenu:Draw()
    self.BG:Draw()
    GUI:Draw();
end

return MainMenu;
