local Projectile = {};

function Projectile:new(_projectile)
  _projectile = _projectile or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Direction = require("Vec2"):new(), Speed, IsFriendly = true, Destroy = false, Damage = 1};
  setmetatable(_projectile, self);
  self.__index = self;
  return _projectile;
end

function Projectile:Create(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _friendly, _damage, _type)
  self.IsFriendly = _friendly;
  self.Speed = _speed;
  self.Direction.x = _DirectionX;
  self.Direction.y = _DirectionY;
  self.Direction:Normalize();
  self.Damage = _damage;
  _type = _type or "PeaShooter";

  if _type == "Seed" then
    self.Sprite:Create("Resources/Textures/Lober/Seed.png", _xPos, _yPos, 70 ,73);
    self.Sprite:AddAnimation('1-8', 0.05);
  elseif _type == "PeaShooter" then
    self.Sprite:Create("Resources/Textures/PeaShooter.png", _xPos, _yPos, 158 ,47);
    self.Sprite:AddAnimation('1-14', 0.05);
  end
  self.Sprite.CurrentAnimation = 1;

  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize, self.Sprite.yFrameSize - 30, "dynamic", 0, "projectile", 0, 0, true, self);
  self.RigidBody:SetFixedToRotation(true);
  self.RigidBody:SetGravity(0);
end

function Projectile:Update(_dt)
  if self.Destroy == false then
    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;

    if self.Direction.x < 0 then
      self.Sprite:SetScale(-1, 1);
    end

    self.Sprite:Update(_dt);

    self.RigidBody:SetVelocity(self.Direction.x * self.Speed, self.Direction.y * self.Speed);
  end
end

function Projectile:Cleanup()
  self.RigidBody:Destroy();
end

function Projectile:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
  end
end

return Projectile;
