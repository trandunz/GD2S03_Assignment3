local Scene = {};
ProjectileManager = require("ProjectileManager");
EnemyManager = require("EnemyManager");
STI = require("STI/sti");

function Scene:new(_scene)
  _scene = _scene or {World = require("World"):new(), Player = require("Player"), Floor = require("RigidBody"):new(), BG = require("Sprite"):new(), Sky = require("Sprite"):new(),
Map = STI("Resources/Tilemaps/LevelOne.lua"), Platforms = {}};
  setmetatable(_scene, self);
  self.__index = self;
  return _scene;
end

function Scene:Start()
  self.World:InitWorld();
  EnemyManager.Init(self.World.world);

  self.BG:Create("Resources/Textures/SpudBG.png", WindowSize.x/2, WindowSize.y/2 + 150);
  self.BG:SetScale(1.5, 1.5);

  self.Sky:Create("Resources/Textures/SpudSky.png", WindowSize.x/2, WindowSize.y/2 - 100);
  self.Sky:SetScale(1.5, 1.5);

  self.Floor:SetWorld(self.World.world);
  self.Floor:CreateCube(WindowSize.x / 2, WindowSize.y - 50, WindowSize.x, 50, "static", 0, "floor");

  self.Player.Create(love.graphics.getWidth()/2, love.graphics.getHeight()/2, self.World.world);
  EnemyManager.CreateLober(WindowSize.x / 2 + 300, WindowSize.y - 180);

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

  self.Map:update(_dt);

  self.World:Update(_dt);
  self.Player.GrabInput();
  self.Player.Update(_dt);

  ProjectileManager.Update(_dt);
  EnemyManager.Update(_dt);
end

function Scene:KeyEvents( key, scancode, isrepeat )
  self.Player.KeyEvents(key, scancode, isrepeat);
end

function Scene:Draw()
  self.Sky:Draw();
  self.BG:Draw();
  self.Map:drawLayer(self.Map.layers["Tile Layer 1"]);
  for i, v in pairs(self.Platforms) do
    v:Draw();
  end
  EnemyManager.Draw();
  self.Player.Draw();
  self.Floor:Draw();

  ProjectileManager.Draw();
end

return Scene;
