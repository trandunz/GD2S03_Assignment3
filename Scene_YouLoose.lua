--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Scene_YouLoose.lua
--Description : Scene_YouLoose Implementation File
--Author : Will Inman

local Scene_YouLoose = {};

function Scene_YouLoose:new(_youLoose)
  _youLoose = _youLoose or {BG = require("Sprite"):new(), Retry = require("Sprite"):new(),Options = require("Sprite"):new(),Exit = require("Sprite"):new(), MenuSelection = 0,
AudioManager = require("AudioManager"):new()};
  setmetatable(_youLoose, self);
  self.__index = self;
  return _youLoose;
end

function Scene_YouLoose:Cleanup()
  self.AudioManager:ForceCleanup();
end

function Scene_YouLoose:Start()
    self.AudioManager:CreateMusic("DeathMusic", "Resources/Music/Botanic_Death.mp3", true, true, "stream");

    self.Retry:Create("Resources/Textures/GUI/Retry.png", WindowSize.x/2, (WindowSize.y/2) - 25);
    self.Retry:SetColor(255,255,255);

    self.Exit:Create("Resources/Textures/GUI/Return.png", WindowSize.x/2, (WindowSize.y/2) + 25);
    self.Exit:SetColor(150,150,150);

    self.BG:Create("Resources/Textures/DeathImage.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(0.91,0.91);
end

function Scene_YouLoose:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  self.Retry:SetColor(150,150,150);
  self.Exit:SetColor(150,150,150);

  if self.MenuSelection == 0 then
    self.Retry:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    self.Exit:SetColor(255,255,255);
  end
end

function Scene_YouLoose:KeyEvents( key, scancode, isrepeat )
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
      LevelLoader:LoadPreviousLevel();
    elseif self.MenuSelection == 1 then
      LevelLoader:LoadLevel("Scene_Overworld");
    end
  end

  if self.MenuSelection < 0 then
    self.MenuSelection = 0;
  elseif self.MenuSelection > 1 then
    self.MenuSelection = 1;
  end
end

function Scene_YouLoose:Draw()
    self.BG:Draw();
    self.Retry:Draw();
    self.Exit:Draw();
end

return Scene_YouLoose;
