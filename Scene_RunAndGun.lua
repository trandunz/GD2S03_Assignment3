local Scene = {};
ProjectileManager = require("ProjectileManager");
EnemyManager = require("EnemyManager");
local STI = require("STI/sti");
local HUMP = require("hump/camera");
local GUI = require("GUI");
Player = require("Player");

function Scene:new(_scene)
  _scene = _scene or {World = require("World"):new(), Sky = require("Sprite"):new(),
Map = STI("Resources/Tilemaps/LevelOne.lua"), Platforms = {}, AudioManager = require("AudioManager"):new(), GameOver = false};
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

  self.World:InitWorld();
  EnemyManager.Init(self.World.world);

  self.Sky:Create("Resources/Textures/Botanic/Sky.png", WindowSize.x/2, WindowSize.y/2 - 90);
  self.Sky:SetScale(1.5, 1.5);

  Player.Create(WindowSize.x / 2, WindowSize.y/2, self.World.world);
  EnemyManager.CreateLober(WindowSize.x / 2 + 300, WindowSize.y - 245);
  EnemyManager.CreateLober(WindowSize.x / 2 + 930, WindowSize.y - 450);
  EnemyManager.CreateLober(200, WindowSize.y - 245);

  for i, obj in pairs(self.Map.layers["Platforms"].objects) do
    local rigidBody = require("RigidBody"):new();
    rigidBody:SetWorld(self.World.world);
    rigidBody:CreateCube(obj.x, obj.y, obj.width, obj.height, "static", 0, "floor", obj.width / 2, obj.height / 2);
    table.insert(self.Platforms, rigidBody);
  end
end

function Scene:Update(_dt)
  EnemyManager.CleanupDestroyedEnemies();
  ProjectileManager.CleanupDestroyedProjectiles();
  LevelLoader:HandleSceneStartTransition(_dt);

  self.AudioManager:Update();

  self.Map:update(_dt);

  self.World:Update(_dt);
  if self.GameOver == false then
    Player.GrabInput();
    Player.Update(_dt);
    self.camera:lookAt(Player.GetPosition().x, 280);
  end
  self:UpdatePlayerHPGUI();

  ProjectileManager.Update(_dt);
  EnemyManager.Update(_dt);

  self:CheckForPlayerDeath();
end

function Scene:KeyEvents( key, scancode, isrepeat )
  if Player then
    Player.KeyEvents(key, scancode, isrepeat);
  end

  if key == "1" then
    TimeScale = 0;
  elseif key == "2" then
    TimeScale = 1;
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

  self.Map:drawLayer(self.Map.layers["Tile Layer 1"]);
  for i, v in pairs(self.Platforms) do
    v:Draw();
  end
  EnemyManager.Draw();

  if Player then
    Player.Draw();
  end

  ProjectileManager.Draw();

  self.camera:detach();

  GUI:Draw();
end

return Scene;
