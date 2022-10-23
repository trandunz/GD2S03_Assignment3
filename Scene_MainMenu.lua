local MainMenu = {};

function MainMenu:new(_mainMenu)
  _mainMenu = _mainMenu or {BG = require("Sprite"):new(), Play = require("Sprite"):new(),Options = require("Sprite"):new(),Exit = require("Sprite"):new(), MenuSelection = 0};
  setmetatable(_mainMenu, self);
  self.__index = self;
  return _mainMenu;
end

function MainMenu:Cleanup()
end

function MainMenu:Start()
    AudioManager.CreateSound("Music", "Resources/Music/LastCourse.mp3", true, true, "stream");

    self.Play:Create("Resources/Textures/GUI/Start.png", WindowSize.x/2, (WindowSize.y/2) - 50);
    self.Play:SetColor(255,255,255);
    self.Options:Create("Resources/Textures/GUI/Options.png", WindowSize.x/2, WindowSize.y/2);
    self.Options:SetColor(150,150,150);
    self.Exit:Create("Resources/Textures/GUI/Exit.png", WindowSize.x/2, (WindowSize.y/2) + 50);
    self.Exit:SetColor(150,150,150);

    self.BG:Create("Resources/Textures/MM.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(0.91,0.91);
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
    self.BG:Draw();
    self.Play:Draw();
    self.Options:Draw();
    self.Exit:Draw();
end

return MainMenu;
