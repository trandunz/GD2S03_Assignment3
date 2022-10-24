local Bullseye = {};

function Bullseye:new(_bullseye)
  _bullseye = _bullseye or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Health = 10, Destroy = false, DamageTimer = 0, DamageInterval = 0.2};
  setmetatable(_bullseye, self);
  self.__index = self;
  return _bullseye;
end

function Bullseye:Create(_xPos, _yPos, _world)
  self.Sprite:Create("Resources/Textures/Tutorial/Target.png", _xPos, _yPos, 77 ,91);
  self.Sprite:AddAnimation('1-5', 0.06);
  self.Sprite.CurrentAnimation = 1;

  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize, self.Sprite.yFrameSize, "static", 0, "enemy", 0, 0, false, self);
  self.RigidBody:SetFixedToRotation(true);
end

function Bullseye:Update(_dt)
  if self.Destroy == false then
    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;
    self.Sprite:Update(_dt);

    if self.DamageTimer > 0 then
      self.DamageTimer = self.DamageTimer - _dt;
    end

    if self.Health <= 0 then
      self.Destroy = true;
    end
  end
end

function Bullseye:TakeDamage(_amount)
  if self.Health > 0 then
    if self.DamageTimer <= 0 then
      self.Health = self.Health - _amount;
      self.DamageTimer = self.DamageInterval;
      if self.Health < 0 then
        self.Health = 0;
      end
    end
  end
end

function Bullseye:Cleanup()
  self.RigidBody:Destroy();
end

function Bullseye:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
  end
end

return Bullseye;
