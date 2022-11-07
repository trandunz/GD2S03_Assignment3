--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Scene_Boss.lua
--Description : Scene_Boss Implementation File
--Author : Will Inman

local Scene_Boss = {};

ProjectileManager = require("ProjectileManager");
EnemyManager = require("EnemyManager");
local STI = require("STI/sti");
local GUI = require("GUI");
Player = require("Player");

function Scene_Boss:new(_scene)
  _scene = _scene or {World = require("World"):new(), Sky = require("Sprite"):new(), BG = require("Sprite"):new(), Floor = require("RigidBody"):new(),
LeftBound = require("RigidBody"):new(), RightBound = require("RigidBody"):new(), AudioManager = require("AudioManager"):new(), GameOver = false};
  setmetatable(_scene, self);
  self.__index = self;
  return _scene;
end

function Scene_Boss:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();
  ProjectileManager.ForceCleanup();
  EnemyManager.ForceCleanup();
  ProjectileManager = nil;
  EnemyManager = nil;
  GUI = nil;
  Player = nil;
end

function Scene_Boss:Start()
  GUI = require("GUI"):new();
  ProjectileManager = require("ProjectileManager");
  EnemyManager = require("EnemyManager");
  Player = require("Player");

  self.AudioManager:CreateMusic("Botanic", "Resources/Music/Botanic.mp3", true, true, "stream");

  GUI:CreateImage("Health", "Resources/Textures/GUI/3HP.png", 50, WindowSize.y - 25);
  GUI.Elements.Health:SetScale(1,1);

  self.World:InitWorld();
  EnemyManager.Init(self.World.world);

  self.Sky:Create("Resources/Textures/Botanic/Sky.png", WindowSize.x/2, WindowSize.y/2 - 90);
  self.Sky:SetScale(1.5, 1.5);

  self.BG:Create("Resources/Textures/Botanic/Floor.png", WindowSize.x/2, WindowSize.y - 200)
  self.BG:SetScale(1.5, 1.5);

  self.Floor:SetWorld(self.World.world);
  self.Floor:CreateCube(WindowSize.x/2, WindowSize.y - 50, WindowSize.x, 10, "static", 0, "floor", 0, 0, false);
  self.Floor:SetFixedToRotation(true);

  self.LeftBound:SetWorld(self.World.world);
  self.LeftBound:CreateCube(0, WindowSize.y / 2, 20, WindowSize.y, "static", 0);

  self.RightBound:SetWorld(self.World.world);
  self.RightBound:CreateCube( WindowSize.x, WindowSize.y / 2, 20, WindowSize.y, "static", 0);

  Player.Create(100, WindowSize.y/2, self.World.world);
  EnemyManager.CreateOnion(WindowSize.x / 2, WindowSize.y - 300);
end

function Scene_Boss:Update(_dt)
  EnemyManager.CleanupDestroyedEnemies();
  ProjectileManager.CleanupDestroyedProjectiles();
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  self.World:Update(_dt);
  if self.GameOver == false and not self.PauseMenu then
    Player.GrabInput();
    Player.Update(_dt);
  end
  self:UpdatePlayerHPGUI();

  ProjectileManager.Update(_dt);
  EnemyManager.Update(_dt);

  if self.PauseMenu then
    self.PauseMenu:Update(_dt);
  end

  self:CheckForPauseMenuClosed();
  self:CheckForPlayerDeath();
  self:CheckForPlayerWin();
end

function Scene_Boss:KeyEvents( key, scancode, isrepeat )
  if self.PauseMenu then
    self.PauseMenu:KeyEvents(key, scancode, isrepeat);
  else
    if Player then
      Player.KeyEvents(key, scancode, isrepeat);
    end
  end

  if key == "escape" then
    if self.PauseMenu then
      self.PauseMenu:Cleanup();
      self.PauseMenu = nil;
    else
      self.PauseMenu = require("PauseMenu"):new();
      self.PauseMenu:Create();
    end
  end
end

function Scene_Boss:CheckForPauseMenuClosed()
  if self.PauseMenu then
    if self.PauseMenu.Destroy == true then
      self.PauseMenu:Cleanup();
      self.PauseMenu =  nil;
    end
  end
end

function Scene_Boss:CheckForPlayerWin()
  if EnemyManager.GetEnemyCount() <= 0 and Player.Destroy == false then
    self.GameOver = true;
    LevelLoader:LoadLevel("Scene_YouWin");
    Player.Cleanup();
  end
end

function Scene_Boss:CheckForPlayerDeath()
  if Player then
    if Player.Destroy == true and self.GameOver == false then
      self.GameOver = true;
      LevelLoader:LoadLevel("Scene_YouLoose");
      Player.Cleanup();
    end
  end
end

function Scene_Boss:UpdatePlayerHPGUI()
  if Player ~= nil then
    if Player.Health >= 3 then
      GUI.Elements.Health:SetImage("Resources/Textures/GUI/3HP.png");
    elseif Player.Health >= 2 then
      GUI.Elements.Health:SetImage("Resources/Textures/GUI/2HP.png");
    elseif Player.Health >= 1 then
      GUI.Elements.Health:SetImage("Resources/Textures/GUI/1HP.png");
    else
      GUI.Elements.Health:SetImage("Resources/Textures/GUI/0HP.png");
    end
  end
end

function Scene_Boss:Draw()
  self.Sky:Draw();

  self.BG:Draw();
  EnemyManager.Draw();
  self.Floor:Draw();

  if Player then
    Player.Draw();
  end

  ProjectileManager.Draw();

  GUI:Draw();
  if self.PauseMenu then
    self.PauseMenu:Draw();
  end
end

return Scene_Boss;
