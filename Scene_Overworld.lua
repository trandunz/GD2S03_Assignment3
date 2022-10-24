local Overworld = {};

local GUI = require("GUI");

function Overworld:new(_overWorld)
  _overWorld = _overWorld or {BG = require("Sprite"):new(), Cuphead = require("AnimatedSprite"):new(), Mugman = require("AnimatedSprite"):new(),
  LevelOne = require("Sprite"):new(), LevelTwo = require("Sprite"):new(), LevelThree = require("Sprite"):new(),MenuSelection = 0, PreviousSelection = 0,
  Return = require("Sprite"):new(), AudioManager = require("AudioManager"):new()};
  setmetatable(_overWorld, self);
  self.__index = self;
  return _overWorld;
end

function Overworld:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();
end

function Overworld:Start()
    self.AudioManager:CreateMusic("Music", "Resources/Music/Inkwell.mp3", true, true, "stream");

    GUI = require("GUI"):new();

    self.BG:Create("Resources/Textures/MainMenu.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(1,1);

    GUI:CreateText("Return", "Return", WindowSize.x/2, (WindowSize.y/2) + 75, "center", 0, 32);
    GUI.Elements.Return:SetScale(2.5,2.5);

    self.Cuphead:Create("Resources/Textures/Cuphead_Title.png", 250, WindowSize.y - 250, 333 ,552);
    self.Cuphead:AddAnimation('1-25', 0.05);
    self.Cuphead.CurrentAnimation = 1;

    self.Mugman:Create("Resources/Textures/Mugman_Title.png", WindowSize.x - 250, WindowSize.y - 250, 389 ,568);
    self.Mugman:AddAnimation('1-25', 0.05);
    self.Mugman.CurrentAnimation = 1;

    self.LevelOne:Create("Resources/Textures/GUI/WorldStar.png", (WindowSize.x/2) - 150, WindowSize.y/2);
    self.LevelOne:SetColor(255,255,255);
    self.LevelOne:SetScale(1,1);
    GUI:CreateText("World1", "1", (WindowSize.x/2) - 150, WindowSize.y/2 - 20, "center", 0, 32, 0,0,0);

    self.LevelTwo:Create("Resources/Textures/GUI/WorldStar.png", (WindowSize.x/2), WindowSize.y/2);
    self.LevelTwo:SetColor(150,150,150);
    self.LevelTwo:SetScale(1,1);
    GUI:CreateText("World2", "2", (WindowSize.x/2), WindowSize.y/2- 20,"center", 0, 32, 0,0,0);

    self.LevelThree:Create("Resources/Textures/GUI/WorldStar.png", (WindowSize.x/2) + 150, WindowSize.y/2);
    self.LevelThree:SetColor(150,150,150);
    self.LevelThree:SetScale(1,1);
    GUI:CreateText("World3", "3", (WindowSize.x/2) + 150, WindowSize.y/2- 20, "center", 0, 32, 0,0,0);
end

function Overworld:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  self.Cuphead:Update(_dt);
  self.Mugman:Update(_dt);

  self.LevelOne:SetColor(150,150,150);
  self.LevelTwo:SetColor(150,150,150);
  self.LevelThree:SetColor(150,150,150);
  GUI.Elements.Return:SetColor(150,150,150);

  if self.MenuSelection == 0 then
    self.LevelOne:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    self.LevelTwo:SetColor(255,255,255);
  elseif self.MenuSelection == 2 then
    self.LevelThree:SetColor(255,255,255);
  elseif self.MenuSelection == 3 then
    GUI.Elements.Return:SetColor(255,255,255);
  end

end

function Overworld:KeyEvents( key, scancode, isrepeat )
  math.randomseed(os.time());
  local randomSound = math.random(1,3);

  if key == "left" then
    if self.MenuSelection ~= 3 then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
      self.MenuSelection = self.MenuSelection - 1;
      if self.MenuSelection >= 3 then
        self.MenuSelection = 2
      end
      self.PreviousSelection = self.MenuSelection;
    end
  end
  if key == "right" then
    if self.MenuSelection ~= 3 then
      self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
      self.MenuSelection = self.MenuSelection + 1;
      if self.MenuSelection >= 3 then
        self.MenuSelection = 2
      end
      self.PreviousSelection = self.MenuSelection;
    end
  end
  if key == "down" then
    self.MenuSelection = 3;
    self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
  end
  if key == "up" then
    self.MenuSelection = self.PreviousSelection;
    self.AudioManager:CreateSound("Select", "Resources/Sounds/GUI/Select (".. randomSound .. ").wav", true, false);
  end
  if key == "return" then
    self.AudioManager:CreateSound("Confirm", "Resources/Sounds/GUI/Confirm.wav", true, false);
    if self.MenuSelection == 0 then
      LevelLoader:LoadLevel("Scene_RunAndGun");
    elseif self.MenuSelection == 1 then
    elseif self.MenuSelection == 2 then
      LevelLoader:LoadLevel("Scene_Boss");
    elseif self.MenuSelection == 3 then
      LevelLoader:LoadLevel("Scene_MainMenu");
    end
  end

  if self.MenuSelection < 0 then
    self.MenuSelection = 0;
  elseif self.MenuSelection > 3 then
    self.MenuSelection = 3;
  end
end

function Overworld:Draw()
    self.BG:Draw();
    self.Cuphead:Draw();
    self.Mugman:Draw();
    self.LevelOne:Draw();
    self.LevelTwo:Draw();
    self.LevelThree:Draw();
    GUI:Draw();
end

return Overworld;
