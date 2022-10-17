Scene = {World = require("World"):new(), Player = require("Player"), Text = require("Text"), Floor};

function Scene:new(_scene)
  _scene = _scene or {};
  setmetatable(_scene, self);
  self.__index = self;
  return _scene;
end

function Scene:Start()
  self.World:InitWorld();

  self.Floor = require("RigidBody"):new();
  self.Floor:SetWorld(self.World.world);
  self.Floor:CreateCube(400, 400, 600, 50, "static");

  self.Player.Create(love.graphics.getWidth()/2, love.graphics.getHeight()/2, self.World.world);
  self.Text.Create("Yay!");
end

function Scene:Update(_dt)
  self.World:Update(_dt);
  self.Player.GrabInput();
  self.Player.Update(_dt);
end

function Scene:Draw()
  self.Player.Draw();
  self.Text.Draw();
  self.Floor:Draw();
end

return Scene;
