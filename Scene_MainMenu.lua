--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Scene_MainMenu.lua
--Description : Scene_MainMenu Implementation File
--Author : Will Inman

local MainMenu = {};

local GUI = require("GUI");

-- returns a new instance of main menu
function MainMenu:new(_mainMenu)
  _mainMenu = _mainMenu or {BG = require("Sprite"):new(), Play = require("Text"):new(),Options = require("Text"):new(),Exit = require("Text"):new(), MenuSelection = 0,
AudioManager = require("AudioManager"):new(), OptionsMenu};
  setmetatable(_mainMenu, self);
  self.__index = self;
  return _mainMenu;
end

-- cleans up the scene
function MainMenu:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();

  if self.OptionsMenu then
    self.OptionsMenu:Cleanup();
    self.OptionsMenu = nil;
  end
end

-- initializes the scene
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

-- updates the scene
function MainMenu:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  if self.OptionsMenu then
    self.OptionsMenu:Update(_dt);

    if self.OptionsMenu.Destroy then
      self.OptionsMenu:Cleanup();
      self.OptionsMenu = nil;
    end
  else
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
end

-- recieves key events from love key callback
function MainMenu:KeyEvents( key, scancode, isrepeat )
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
        self.OptionsMenu = require("OptionsMenu"):new();
        self.OptionsMenu:Create();
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
end

-- draws the scene
function MainMenu:Draw()
    self.BG:Draw()

    if self.OptionsMenu then
      self.OptionsMenu:Draw();
    else
      GUI:Draw();
    end
end

return MainMenu;
