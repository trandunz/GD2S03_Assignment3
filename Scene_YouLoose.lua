Scene_YouLoose = {};

function Scene_YouLoose:new(_youLoose)
  _youLoose = _youLoose or {BG = require("Sprite"):new(), Retry = require("Sprite"):new(),Options = require("Sprite"):new(),Exit = require("Sprite"):new(), MenuSelection = 0};
  setmetatable(_youLoose, self);
  self.__index = self;
  return _youLoose;
end

function Scene_YouLoose:Cleanup()
end

function Scene_YouLoose:Start()
    AudioManager.CreateSound("DeathSound", "Resources/Sounds/Death.mp3", true);

    self.Retry:Create("Resources/Textures/GUI/Retry.png", WindowSize.x/2, (WindowSize.y/2) - 50);
    self.Retry:SetColor(255,255,255);
    self.Options:Create("Resources/Textures/GUI/Options.png", WindowSize.x/2, WindowSize.y/2);
    self.Options:SetColor(150,150,150);
    self.Exit:Create("Resources/Textures/GUI/Exit.png", WindowSize.x/2, (WindowSize.y/2) + 50);
    self.Exit:SetColor(150,150,150);

    self.BG:Create("Resources/Textures/MM.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(0.91,0.91);
end

function Scene_YouLoose:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.Retry:SetColor(150,150,150);
  self.Options:SetColor(150,150,150);
  self.Exit:SetColor(150,150,150);

  if self.MenuSelection == 0 then
    self.Retry:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    self.Options:SetColor(255,255,255);
  elseif self.MenuSelection == 2 then
    self.Exit:SetColor(255,255,255);
  end
end

function Scene_YouLoose:KeyEvents( key, scancode, isrepeat )
  if key == "up" then
    self.MenuSelection = self.MenuSelection - 1;
  end
  if key == "down" then
    self.MenuSelection = self.MenuSelection + 1;
  end
  if key == "return" then
    if self.MenuSelection == 0 then
      LevelLoader:LoadLevel("Scene");
    elseif self.MenuSelection == 1 then
    elseif self.MenuSelection == 2 then
      LevelLoader:LoadLevel("Scene_MainMenu");
    end
  end

  if self.MenuSelection < 0 then
    self.MenuSelection = 0;
  elseif self.MenuSelection > 2 then
    self.MenuSelection = 2;
  end
end

function Scene_YouLoose:Draw()
    self.BG:Draw();
    self.Retry:Draw();
    self.Options:Draw();
    self.Exit:Draw();
end

return Scene_YouLoose;
