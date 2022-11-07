--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Scene_RunAndGun.lua
--Description : Scene_RunAndGun Implementation File
--Author : Will Inman

local Scene = {};
ProjectileManager = require("ProjectileManager");
EnemyManager = require("EnemyManager");
local STI = require("STI/sti");
local HUMP = require("hump/camera");
local GUI = require("GUI");
Player = require("Player");

function Scene:new(_scene)
  _scene = _scene or {World = require("World"):new(), Sky = require("Sprite"):new(),
Map = STI("Resources/Tilemaps/Tutorial.lua"), Platforms = {}, Floor = {}, Destructables = {}, Interactables = {},AudioManager = require("AudioManager"):new(), GameOver = false,
PauseMenu};
  setmetatable(_scene, self);
  self.__index = self;
  return _scene;
end

function Scene:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();
  ProjectileManager.ForceCleanup();
  EnemyManager.ForceCleanup();
  ProjectileManager = nil;
  EnemyManager = nil;
  GUI = nil;
  Player = nil;
end

function Scene:Start()
  GUI = require("GUI"):new();
  ProjectileManager = require("ProjectileManager");
  EnemyManager = require("EnemyManager");
  Player = require("Player");

  self.AudioManager:CreateMusic("Music", "Resources/Music/ForestFollies.mp3", true, true, "stream");

  GUI:CreateImage("Health", "Resources/Textures/GUI/3HP.png", 50, WindowSize.y - 25);
  GUI.Elements.Health:SetScale(1,1);

  self.camera = HUMP();
  self.camera:lookAt(WindowSize.x / 2, WindowSize.y / 2 + 300);

  self.World:InitWorld();
  EnemyManager.Init(self.World.world);

  self.Sky:Create("Resources/Textures/Tutorial/BG.png", WindowSize.x/2, WindowSize.y/2);
  self.Sky:SetScale(1.35, 1.35);

  Player.Create(WindowSize.x/2 - 400, WindowSize.y/2 + 400, self.World.world);
  EnemyManager.CreateBullseye(WindowSize.x / 2 + 2450, WindowSize.y - 200);

  ProjectileManager.CreateProjectile(WindowSize.x / 2 + 2750, WindowSize.y - 150, Player.RigidBody:GetWorld(), 0, 0, 0, false, 0, "TutorialBall", true);
  ProjectileManager.CreateProjectile(WindowSize.x / 2 + 3000, WindowSize.y - 150, Player.RigidBody:GetWorld(), 0, 0, 0, false, 0, "TutorialBall", true);
  ProjectileManager.CreateProjectile(WindowSize.x / 2 + 3250, WindowSize.y - 150, Player.RigidBody:GetWorld(), 0, 0, 0, false, 0, "TutorialBall", true);

  for i, obj in pairs(self.Map.layers["Floor"].objects) do
    local rigidBody = require("RigidBody"):new();
    rigidBody:SetWorld(self.World.world);
    rigidBody:CreateCube(obj.x, obj.y, obj.width, obj.height, "static", 0, "floor", obj.width / 2, obj.height / 2);
    table.insert(self.Floor, rigidBody);
  end
  for i, obj in pairs(self.Map.layers["Platforms"].objects) do
    local rigidBody = require("RigidBody"):new();
    rigidBody:SetWorld(self.World.world);
    rigidBody:CreateCube(obj.x, obj.y, obj.width, obj.height, "static", 0, "floor", obj.width / 2, obj.height / 2);
    table.insert(self.Platforms, rigidBody);
  end
  for i, obj in pairs(self.Map.layers["Destructable"].objects) do
    local rigidBody = require("RigidBody"):new();
    rigidBody:SetWorld(self.World.world);
    rigidBody:CreateCube(obj.x, obj.y, obj.width, obj.height, "static", 0, "destructable", obj.width / 2, obj.height / 2);
    table.insert(self.Destructables, rigidBody);
  end
  for i, obj in pairs(self.Map.layers["Interactables"].objects) do
    local rigidBody = require("RigidBody"):new();
    rigidBody:SetWorld(self.World.world);
    rigidBody:CreateCube(obj.x, obj.y, obj.width, obj.height, "static", 0, "tutorialDoor", obj.width / 2, obj.height / 2, true);
    table.insert(self.Interactables, rigidBody);
  end
end

function Scene:Update(_dt)
  EnemyManager.CleanupDestroyedEnemies();
  ProjectileManager.CleanupDestroyedProjectiles();
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  if love.keyboard.isDown("down") then
    for i, v in pairs(self.Platforms) do
      v:ToggleCollision(false);
    end
  else
    for i, v in pairs(self.Platforms) do
      v:ToggleCollision(true);
    end
  end

  self.Map:update(_dt);

  self.World:Update(_dt);
  if self.GameOver == false and not self.PauseMenu then
    Player.GrabInput();
    Player.Update(_dt);
    if Player.GetPosition().x >= WindowSize.x /2 and Player.GetPosition().x <= 4450 then
      self.camera:lookAt(Player.GetPosition().x, WindowSize.y / 2 + 300);
    end
  end
  self:UpdatePlayerHPGUI();

  ProjectileManager.Update(_dt);
  EnemyManager.Update(_dt);

  if self.PauseMenu then
    self.PauseMenu:Update(_dt);
  end
  self:CheckForPauseMenuClosed();
  self:CheckForPlayerDeath();
end

function Scene:KeyEvents( key, scancode, isrepeat )
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

function Scene:CheckForPauseMenuClosed()
  if self.PauseMenu then
    if self.PauseMenu.Destroy == true then
      self.PauseMenu:Cleanup();
      self.PauseMenu =  nil;
    end
  end
end

function Scene:CheckForPlayerDeath()
  if Player then
    if Player.Destroy == true and self.GameOver == false then
      self.GameOver = true;
      LevelLoader:LoadLevel("Scene_YouLoose");
      Player.Cleanup();
    end
  end
end

function Scene:UpdatePlayerHPGUI()
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

function Scene:Draw()
  self.Sky:Draw();

  self.camera:attach();

  love.graphics.setScissor(  32, 30, WindowSize.x - 74, WindowSize.y );

  self.Map:drawLayer(self.Map.layers["Tile Layer 3"]);
  self.Map:drawLayer(self.Map.layers["Tile Layer 2"]);
  if EnemyManager.EnemyCount > 0 then
    self.Map:drawLayer(self.Map.layers["Tile Layer 4"]);
  else
    if self.Destructables[1] then
      self.Destructables[1]:Destroy();
    end
    self.Destructables[1] = nil;
  end
  for i, v in pairs(self.Floor) do
    v:Draw();
  end
  EnemyManager.Draw();

  if Player then
    Player.Draw();
  end

  ProjectileManager.Draw();

  love.graphics.setScissor( 0, 0, WindowSize.x, WindowSize.y )

  self.camera:detach();

  GUI:Draw();

  if self.PauseMenu then
    self.PauseMenu:Draw();
  end
end

return Scene;
