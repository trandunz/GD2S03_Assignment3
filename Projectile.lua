local Projectile = {};

function Projectile:new(_projectile)
  _projectile = _projectile or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Direction = require("Vec2"):new(), Speed, IsFriendly = true,
  Destroy = false, Damage = 1, AudioManager = require("AudioManager"):new(), Type, CanParry = false, ParryTimer = 0, ParryLeway = 0.05, Collided = false, ParryAnimTimer = 0,
ParticleSystem = require("ParticleSystem"):new(), ParticleEmitTimer = 0, ParticleEmitInterval = 0.1};
  setmetatable(_projectile, self);
  self.__index = self;
  return _projectile;
end

function Projectile:Create(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _friendly, _damage, _type, _canParry)
  self.IsFriendly = _friendly;
  self.Speed = _speed;
  self.Direction.x = _DirectionX;
  self.Direction.y = _DirectionY;
  self.Direction:Normalize();
  self.Damage = _damage;
  _type = _type or "PeaShooter";
  _canParry = _canParry or false;
  self.CanParry = _canParry;
  self.Type = _type;

  self.ParticleSystem:Create("Resources/Textures/Peashooter/Dust.png",10000, _xPos, _yPos);
  self.ParticleEmitTimer = 0.05;

  if _type == "Seed" then
    self.Sprite:Create("Resources/Textures/Lober/Seed.png", _xPos, _yPos, 70 ,73);
    self.Sprite:AddAnimation('1-8', 0.05);
  elseif _type == "PeaShooter" then
    self:CreatePeashot(_xPos, _yPos);
  elseif _type == "Tear" then
    self:CreateTear(_xPos, _yPos);
  elseif _type == "TutorialBall" then
    self:CreateTutorialBall(_xPos, _yPos);
  end
  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize - 30, self.Sprite.yFrameSize - 30, "dynamic", 0, "projectile", 0, 0, true, self);
  self.Sprite.CurrentAnimation = 1;

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
  elseif self.Type == "TutorialBall"then
    return nil;
  end
end

function Projectile:CreatePeashot(_xPos, _yPos)
  math.randomseed(os.time());
  local randomSound = math.random(1,2);
  self.AudioManager:CreateSound("Peashot", "Resources/Sounds/Peashooter/Shot" .. randomSound .. ".wav", true, false);
  self.Sprite:Create("Resources/Textures/PeaShooter.png", _xPos, _yPos, 158 ,47);
  self.Sprite:AddAnimation('1-14', 0.05);
end

function Projectile:CreateTear(_xPos, _yPos)
  math.randomseed(os.time());
  local randomSound = math.random(1,6);
  self.AudioManager:CreateSound("TearDrop", "Resources/Sounds/Onion/Tear (" .. randomSound .. ").wav", true, false);
  self.Sprite:Create("Resources/Textures/Onion/Tear.png", _xPos, _yPos, 47 ,78);
  self.Sprite:AddAnimation('1-3', 0.1);
end

function Projectile:CreateTutorialBall(_xPos, _yPos)
  self.Sprite:Create("Resources/Textures/Tutorial/ParrySphere.png", _xPos, _yPos, 73 , 71);
  self.Sprite:AddAnimation('1-2', 0.1);
  self.Sprite:AddAnimation('3-4', 0.1);
end

function Projectile:StartParryLeway()
  self.ParryTimer = self.ParryLeway;
end

function Projectile:Update(_dt)
  self.AudioManager:Update();

  if self.Type == "PeaShooter" then
    if self.ParticleEmitTimer <= 0 then
      self.ParticleSystem:SetPosition(self.Sprite.XPos, self.Sprite.YPos);
      self.ParticleSystem:Emit();
      self.ParticleEmitTimer = self.ParticleEmitInterval;
    else
      self.ParticleEmitTimer = self.ParticleEmitTimer - _dt;
    end
    self.ParticleSystem:Update(_dt);
  end

  if self.Destroy == false then
    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;

    if self.ParryAnimTimer > 0 then
      self.ParryAnimTimer = self.ParryAnimTimer - _dt;
      self.Sprite.CurrentAnimation = 2;
    else
      self.Sprite.CurrentAnimation = 1;
    end

    if self.ParryTimer > 0 then
      self.ParryTimer = self.ParryTimer - _dt;
    elseif self.CanParry == true and self.Collided == true and self.Damage > 0 then
      self.Collided = false;
      self.Destroy = true;
    end

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

function Projectile:GetPosition()
  return self.RigidBody:GetPosition();
end

function Projectile:Cleanup()
  self.RigidBody:Destroy();
  self.AudioManager:ForceCleanup();
  self.ParticleSystem:SetTexture("Resources/Textures/Peashooter/ExplosionDust.png");
  self.ParticleSystem:Emit();
end

function Projectile:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
    self.ParticleSystem:Draw();
  end
end

return Projectile;
