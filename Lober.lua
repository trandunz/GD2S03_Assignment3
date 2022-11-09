--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Lober.lua
--Description : Lober Implementation File
--Author : Will Inman

local Lober = {};

-- returns a new instance of a Lober enemy
function Lober:new(_lober)
  _lober = _lober or {Sprite = require("AnimatedSprite"):new(), RigidBody = require("RigidBody"):new(), Health = 10, Destroy = false, DamageTimer = 0, DamageInterval = 0.2, AttackTimer = 0, AttackInterval = 3,
AttackRange = 600};
  setmetatable(_lober, self);
  self.__index = self;
  return _lober;
end

-- initialize the lober enemy
function Lober:Create(_xPos, _yPos, _world)
  self.Sprite:Create("Resources/Textures/Lober/Idle.png", _xPos, _yPos, 141 ,247);
  self.Sprite:AddAnimation('1-26', 0.0416666);
  self.Sprite:AddAnimation('27-41', 0.0416666);
  self.Sprite.CurrentAnimation = 1;

  self.RigidBody:SetWorld(_world);
  self.RigidBody:CreateCube(_xPos, _yPos, self.Sprite.xFrameSize, self.Sprite.yFrameSize - 80, "static", 0, "enemy", 0, 40, true, self);
  self.RigidBody:SetFixedToRotation(true);
end

-- Updates the lober every frame
function Lober:Update(_dt)
  if self.Destroy == false then
    self.Sprite.XPos = self.RigidBody:GetPosition().x;
    self.Sprite.YPos = self.RigidBody:GetPosition().y;
    self.Sprite:Update(_dt);

    self:Attack(_dt);

    if self.DamageTimer > 0 then
      self.DamageTimer = self.DamageTimer - _dt;
    end

    if self.Health <= 0 then
      self.Destroy = true;
    end

    if self.AttackTimer > self.AttackInterval - 0.624999 then
      self.Sprite.CurrentAnimation = 2;
    else
      self.Sprite.CurrentAnimation = 1;
    end
  end
end

-- handles the lobers attacking
function Lober:Attack(_dt)
  if self.AttackTimer <= 0 then
    if Player then
      if Math:Distance(Player.GetPosition(), self.Sprite:GetPosition()) <= self.AttackRange then
        self.AttackTimer = self.AttackInterval;
        local dirToPlayer = Player.GetPosition() - self.Sprite:GetPosition();
        ProjectileManager.CreateProjectile(self.Sprite:GetPosition().x, self.Sprite:GetPosition().y, self.RigidBody:GetWorld(), dirToPlayer.x, dirToPlayer.y, 600, false, 1, "Seed")
      end
    end
  else
    self.AttackTimer = self.AttackTimer - _dt;
  end
end

-- Allows the lober to take the specified amount of damage
function Lober:TakeDamage(_amount)
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

-- Cleans up the lober
function Lober:Cleanup()
  self.RigidBody:Destroy();
end

-- draws the lober
function Lober:Draw()
  if self.Destroy == false then
    self.Sprite:Draw();
    self.RigidBody:Draw();
  end
end

return Lober;
