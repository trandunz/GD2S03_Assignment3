--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Onion.lua
--Description : Onion Implementation File
--Author : Will Inman

local Onion = {};

function Onion:new(_onion)
  _onion = _onion or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Health = 100,
  Destroy = false, DamageTimer = 0, DamageInterval = 0.1, AttackTimer = 0, AttackInterval = 0.5, ElapsedTime = 0, AttackIntroTimer = 0.4,
AudioManager = require("AudioManager"):new(), DeathTimer = 1.5};
  setmetatable(_onion, self);
  self.__index = self;
  return _onion;
end

function Onion:Create(_xPos, _yPos, _world)
  self.Sprite:Create("Resources/Textures/Onion/Onion_Small.png", _xPos, _yPos, 284 ,328);
  self.Sprite:AddAnimation('1-24', 0.05);
  self.Sprite:AddAnimation('25-54', 0.05);
  self.Sprite:AddAnimation('55-63', 0.05);
  self.Sprite:AddAnimation('64-70', 0.05);
  self.Sprite:AddAnimation('71-101', 0.05);
  self.Sprite:SetScale(1.5,1.5);
  self.Sprite.CurrentAnimation = 1;

  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize, self.Sprite.yFrameSize, "static", 0, "enemy", 0, 80, true, self);
  self.RigidBody:SetFixedToRotation(true);

  self.AudioManager:CreateSound("OnionRise", "Resources/Sounds/Onion/Rise.wav", true, false);
end

function Onion:Update(_dt)
  self.AudioManager:Update();
  if self.Destroy == false then
    self.ElapsedTime = self.ElapsedTime + _dt;

    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;
    self.Sprite:Update(_dt);

    self:Attack(_dt);

    if self.DamageTimer > 0 then
      self.DamageTimer = self.DamageTimer - _dt;
      self.Sprite:SetColor(255, 255, 255);
    else
      self.Sprite:SetColor(220, 220, 220);
    end

    if self.Health <= 0 then
      self.Health = 0;
      if self.DeathTimer == 1.5 then
        self.AudioManager:ForceCleanup();
        self.AudioManager:CreateSound("OnionDie", "Resources/Sounds/Onion/Die.wav", true, false);
      elseif self.DeathTimer > 0 then
        self.Sprite.CurrentAnimation = 5;
      else
        self.Destroy = true;
      end
      self.DeathTimer = self.DeathTimer - _dt;
    end

    if self.ElapsedTime > 1.2 and self.Sprite.CurrentAnimation == 1 then
      self.Sprite.CurrentAnimation = 2;
    end

  end
end

function Onion:Attack(_dt)
  if self.Health < 100 and self.Health > 0 then
      self.Sprite.CurrentAnimation = 3;
      if self.AttackIntroTimer > 0 then
        self.AttackIntroTimer = self.AttackIntroTimer - _dt;
      else
        self.Sprite.CurrentAnimation = 4;
      end
  end

  self.AttackTimer = self.AttackTimer - _dt;

  if self.Sprite.CurrentAnimation == 4 and Player then
    if self.AttackTimer <= 0 then
      self.AttackTimer = self.AttackInterval;
      math.randomseed(_dt);
      ProjectileManager.CreateProjectile(math.random(Player.GetPosition().x - 75,Player.GetPosition().x + 75), -20, self.RigidBody:GetWorld(), 0, 1, 800, false, 1, "Tear");
    end
  end
end

function Onion:TakeDamage(_amount)
  if self.Health > 0 then
    if self.DamageTimer <= 0 then
      if self.Health == 100 then
        self.AudioManager:CreateSound("Cry", "Resources/Sounds/Onion/Cry.wav", true, true);
      end
      self.Health = self.Health - _amount;
      self.DamageTimer = self.DamageInterval;
      if self.Health < 0 then
        self.Health = 0;
      end
    end
  end
end

function Onion:Cleanup()
  self.RigidBody:Destroy();
  self.AudioManager:ForceCleanup();
end

function Onion:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
  end
end

return Onion;
