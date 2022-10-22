local MainMenu = {Play = require("Sprite"):new(),Options = require("Sprite"):new(),Exit = require("Sprite"):new(), MenuSelection = 0};

function MainMenu:new(_mainMenu)
  _mainMenu = _mainMenu or {};
  setmetatable(_mainMenu, self);
  self.__index = self;
  return _mainMenu;
end

function MainMenu:Start()
    self.Play:Create("Resources/Textures/Start.png", 400, 350);
    self.Play:SetColor(255,255,255);
    self.Options:Create("Resources/Textures/Options.png", 400, 400);
    self.Options:SetColor(150,150,150);
    self.Exit:Create("Resources/Textures/Exit.png", 400, 450);
    self.Exit:SetColor(150,150,150);
end

function MainMenu:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.Play:SetColor(150,150,150);
  self.Options:SetColor(150,150,150);
  self.Exit:SetColor(150,150,150);

  if self.MenuSelection == 0 then
    self.Play:SetColor(255,255,255);
  elseif self.MenuSelection == 1 then
    self.Options:SetColor(255,255,255);
  elseif self.MenuSelection == 2 then
    self.Exit:SetColor(255,255,255);
  end
end

function MainMenu:KeyEvents( key, scancode, isrepeat )
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
    self.Play:Draw();
    self.Options:Draw();
    self.Exit:Draw();
end

return MainMenu;
