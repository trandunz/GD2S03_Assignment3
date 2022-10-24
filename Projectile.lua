local Projectile = {};

function Projectile:new(_projectile)
  _projectile = _projectile or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Direction = require("Vec2"):new(), Speed, IsFriendly = true,
  Destroy = false, Damage = 1, AudioManager = require("AudioManager"):new(), Type};
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
  self.Type = _type;

  if _type == "Seed" then
    self.Sprite:Create("Resources/Textures/Lober/Seed.png", _xPos, _yPos, 70 ,73);
    self.Sprite:AddAnimation('1-8', 0.05);
  elseif _type == "PeaShooter" then
    self:CreatePeashot();
  elseif _type == "Tear" then
    self:CreateTear();
  end
  self.Sprite.CurrentAnimation = 1;

  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize - 30, self.Sprite.yFrameSize - 30, "dynamic", 0, "projectile", 0, 0, true, self);
  self.RigidBody:SetFixedToRotation(true);
  self.RigidBody:SetGravity(0);
end

function Projectile:GetOnHitSound()
  if self.Type == "Seed" then
    return nil;
  elseif self.Type == "PeaShooter" then
    return "Resources/Sounds/Peashooter/Hit.wav";
  elseif self.Type == "Tear" then
    return nil;
  end
end

function Projectile:CreatePeashot()
  math.randomseed(os.time());
  local randomSound = math.random(1,2);
  self.AudioManager:CreateSound("Peashot", "Resources/Sounds/Peashooter/Shot" .. randomSound .. ".wav", true, false);
  self.Sprite:Create("Resources/Textures/PeaShooter.png", _xPos, _yPos, 158 ,47);
  self.Sprite:AddAnimation('1-14', 0.05);
end

function Projectile:CreateTear()
  math.randomseed(os.time());
  local randomSound = math.random(1,6);
  self.AudioManager:CreateSound("TearDrop", "Resources/Sounds/Onion/Tear (" .. randomSound .. ").wav", true, false);
  self.Sprite:Create("Resources/Textures/Onion/Tear.png", _xPos, _yPos, 47 ,78);
  self.Sprite:AddAnimation('1-3', 0.1);
end

function Projectile:Update(_dt)
  self.AudioManager:Update();
  if self.Destroy == false then
    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;

    if self.Type == "PeaShooter" then
      if self.Direction.x > 0 and self.Direction.y == 0 then
        self.Sprite:SetRotation(math.rad(0));
        self.RigidBody:SetRotation(math.rad(0));
      elseif self.Direction.x < 0 and self.Direction.y == 0 then
        self.Sprite:SetRotation(math.rad(180));
        self.RigidBody:SetRotation(math.rad(180));
      elseif self.Direction.y < 0 and self.Direction.x == 0 then
        self.Sprite:SetRotation(math.rad(-90));
        self.RigidBody:SetRotation(math.rad(-90));
      elseif self.Direction.y > 0 and self.Direction.x == 0 then
        self.Sprite:SetRotation(math.rad(90));
        self.RigidBody:SetRotation(math.rad(90));
      elseif self.Direction.x > 0 and self.Direction.y < 0 then
        self.Sprite:SetRotation(math.rad(-45));
        self.RigidBody:SetRotation(math.rad(-45));
      elseif self.Direction.x > 0 and self.Direction.y > 0 then
        self.Sprite:SetRotation(math.rad(45));
        self.RigidBody:SetRotation(math.rad(45));
      elseif self.Direction.x < 0 and self.Direction.y < 0 then
        self.Sprite:SetRotation(math.rad(-135));
        self.RigidBody:SetRotation(math.rad(-135));
      elseif self.Direction.x < 0 and self.Direction.y > 0 then
        self.Sprite:SetRotation(math.rad(135));
        self.RigidBody:SetRotation(math.rad(135));
      end
    end

    self.Sprite:Update(_dt);

    self.RigidBody:SetVelocity(self.Direction.x * self.Speed, self.Direction.y * self.Speed);
  end
end

function Projectile:Cleanup()
  self.RigidBody:Destroy();
  self.AudioManager:ForceCleanup();
end

function Projectile:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
  end
end

return Projectile;
