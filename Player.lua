local Player = {Sprite, MoveSpeed = 20, JumpHeight = 3500, MoveInput, Input, RigidBody, IsGrounded = false, DashDuration = 0.34, DashTimer = 0, DashSpeed = 50, IsCrouched = false,
CrouchDuration = 0.28, CrouchTimer = 0, ShootDuration = 0.24, ShootTimer = 0, Health = 3, IntroTimer = 1.62, DamageTimer = 0, DamageInterval = 0.24, ElapsedTime = 0,
AudioManager, Destroy = false, DeathTimer = 0.64, AimLock = false};

function Player.Create(_xPos, _yPos, _world)
  Player.Sprite = require("AnimatedSprite"):new();
  Player.MoveInput = require("Vec2"):new();
  Player.Input = require("Vec2"):new();
  Player.RigidBody = require("RigidBody"):new();
  Player.AudioManager = require("AudioManager"):new();
  Player.Health = 3;
  Player.MoveSpeed = 20;
  Player.JumpHeight = 3500;
  Player.IsGrounded = false;
  Player.DashTimer = 0;
  Player.IsCrouched = false;
  Player.CrouchTimer = 0;
  Player.ShootTimer = 0;
  Player.IntroTimer = 1.62;
  Player.DamageTimer = 0;
  Player.ElapsedTime = 0;
  Player.Destroy = false;
  Player.DeathTimer = 0.64;
  Player.AimLock = false

  Player.Sprite:Create("Resources/Textures/Cuphead/Player_Everything.png", _xPos, _yPos, 326 ,188);
  Player.Sprite:AddAnimation('1-9', 0.059, 0, 0);
  Player.Sprite:AddAnimation('1-16', 0.04, 0, 188);
  Player.Sprite:AddAnimation('1-8', 0.03, 0, 188 * 2);
  Player.Sprite:AddAnimation('1-7', 0.05, 0, 188 * 3);
  Player.Sprite:AddAnimation('1-9', 0.05, 0, 188 * 4);
  Player.Sprite:AddAnimation('1-8', 0.08, 0, 188 * 5);
  Player.Sprite:AddAnimation('1-5', 0.041, 0, 188 * 6);
  Player.Sprite:AddAnimation('1-27', 0.05, 0, 188 * 7);
  Player.Sprite:AddAnimation('1-16', 0.06, 0, 188 * 8);
  Player.Sprite:AddAnimation('1-6', 0.04, 0, 188 * 9);
  Player.Sprite:AddAnimation('1-16', 0.04, 0, 188 * 10);
  Player.Sprite:AddAnimation('1-9', 0.04, 0, 188 * 11);
  Player.Sprite:AddAnimation('1-9', 0.04, 0, 188 * 12);
  Player.Sprite:AddAnimation('1-9', 0.04, 0, 188 * 13);
  Player.Sprite:AddAnimation('1-9', 0.04, 0, 188 * 14);
  Player.Sprite:AddAnimation('1-9', 0.04, 0, 188 * 15);
  Player.Sprite:AddAnimation('1-4', 0.04, 0, 188 * 16);
  Player.Sprite:AddAnimation('1-4', 0.04, 0, 188 * 17);
  Player.Sprite:AddAnimation('1-4', 0.04, 0, 188 * 18);
  Player.Sprite:AddAnimation('1-4', 0.04, 0, 188 * 19);
  Player.Sprite:AddAnimation('5-8', 0.04, 0, 188 * 19);
  Player.Sprite.CurrentAnimation = 1;

  Player.RigidBody:SetWorld(_world);
  Player.RigidBody:CreateCube(_xPos, _yPos, Player.Sprite.xFrameSize - 230, Player.Sprite.yFrameSize - 50, "dynamic", 0, "player", 0, 15, false, self);
  Player.RigidBody:SetFixedToRotation(true);

  Player.AudioManager:CreateSound("Intro", "Resources/Sounds/Player/Intro.wav", true, false);
end

function Player.GrabInput()
  Player.MoveInput.x = 0;
  Player.MoveInput.y = 0;
  Player.Input.x = 0;
  Player.Input.y = 0;
  Player.Input:Normalize();

  if love.keyboard.isDown("up") then
    Player.Input.y = Player.Input.y - 1;

    if Player.IsCrouched == false then
      Player.MoveInput.y = Player.MoveInput.y - 1;
    end
  end

  if love.keyboard.isDown("down") then
    Player.Input.y = Player.Input.y + 1;

    if Player.DashTimer <= 0 then
      Player.IsCrouched = true;
    else
      Player.RigidBody:ResetSize();
      Player.IsCrouched = false;
      Player.CrouchTimer = Player.CrouchDuration;
    end
  else
    Player.RigidBody:ResetSize();
    Player.IsCrouched = false;
  end

  if love.keyboard.isDown("left") then
    Player.Input.x = Player.Input.x - 1;
    Player.MoveInput.x = Player.MoveInput.x - 1;
    if Player.RigidBody:GetVelocity().x < 0 or Player.IsCrouched == true or Player.AimLock == true then
      Player.Sprite:SetScale(-1,1);
    end
  end

  if love.keyboard.isDown("right") then
    Player.Input.x = Player.Input.x + 1;
    Player.MoveInput.x = Player.MoveInput.x + 1;

    if Player.RigidBody:GetVelocity().x > 0 or Player.IsCrouched == true or Player.AimLock == true then
      Player.Sprite:SetScale(1,1);
    end
  end

  if love.keyboard.isDown("c") and Player.ShootTimer <= 0  then
    Player.Shoot();
  end

  if love.keyboard.isDown("v") and Player.DashTimer <= 0 then
    Player.AimLock = true;
  else
    Player.AimLock = false;
  end
end

function Player.KeyEvents( key, scancode, isrepeat )
  if key == "up" and Player.IsGrounded == true then
    Player.Jump();
  end
  if key == "down" then
    Player.CrouchTimer = Player.CrouchDuration;
  end
  if key == "space" then
    Player.Dash();
  end
end

function Player.TakeDamage(_amount)
  if Player.Health > 0  and Player.DamageTimer <= 0 then
    math.randomseed(os.time());
    local randomSound = math.random(1,5);
    Player.AudioManager:CreateSound("Hit", "Resources/Sounds/Player/Hit (".. randomSound .. ").wav", true, false);

    Player.Health = Player.Health - _amount;
    Player.DamageTimer = Player.DamageInterval;
    if Player.Health <= 0 then
      Player.Health = 0;
    else
      Player.ShootTimer = 0;
      Player.CrouchTimer = 0;
      Player.DashTimer = 0;
      Player.ApplyLinearImpulse(0, -1500);
    end
  end
end

function Player.Jump()
  if Player.IntroTimer <= 0 and Player.Destroy == false and Player.DamageTimer <= 0 and Player.AimLock == false then
    math.randomseed(os.time());
    local randomSound = math.random(1,3);
    Player.AudioManager:CreateSound("Jump", "Resources/Sounds/Player/Jump (".. randomSound .. ").wav", true, false);

    Player.ApplyLinearImpulse(0, -Player.JumpHeight);
  end
end

function Player.Shoot()
  if Player.IntroTimer <= 0 and Player.Destroy == false and Player.DamageTimer <= 0 then
    if Player.AimLock == false then
      ProjectileManager.CreateProjectile(Player.RigidBody:GetCenter().x, Player.RigidBody:GetCenter().y, Player.RigidBody:GetWorld(), Player.Sprite.XScale, 0, 2000, true, 1);
    else
      if Player.Input:Mag() == 0 then
        ProjectileManager.CreateProjectile(Player.RigidBody:GetCenter().x, Player.RigidBody:GetCenter().y, Player.RigidBody:GetWorld(), Player.Sprite.XScale, 0, 2000, true, 1);
      else
        ProjectileManager.CreateProjectile(Player.RigidBody:GetCenter().x, Player.RigidBody:GetCenter().y, Player.RigidBody:GetWorld(), Player.Input.x, Player.Input.y, 2000, true, 1);
      end
    end
    Player.ShootTimer = Player.ShootDuration;
  end
end

function Player.AlphaFlashSin()
  return (math.sin(math.rad(Player.ElapsedTime * 4000)) * 125/2) + 125/2;
end

function Player.Cleanup()
  Player.Destroy = true;
  Player.AudioManager:ForceCleanup();

  math.randomseed(os.time());
  local randomSound = math.random(1,2);
  Player.AudioManager:CreateSound("Death", "Resources/Sounds/Player/Death (".. randomSound .. ").wav", true, false);
end

function Player.Update(_dt)
  Player.ElapsedTime = Player.ElapsedTime + _dt;
  Player.Sprite.XPos = Player.RigidBody:GetPosition().x;
  Player.Sprite.YPos = Player.RigidBody:GetPosition().y;
  Player.Sprite:Update(_dt);

  if Player.DamageTimer > 0 then
    Player.DamageTimer = Player.DamageTimer - _dt;
    Player.SetXVelocity(0);
    Player.Sprite:SetColor(255,255,255,125 + Player.AlphaFlashSin());
  else
    Player.Sprite:SetColor(255,255,255,255);
  end

  if Player.IntroTimer > 0 or Player.Destroy == true or Player.DamageTimer > 0 then
    -- Do nothing
  elseif (Player.IsCrouched == true and Player.IsGrounded == true) or Player.AimLock == true then
    Player.SetXVelocity(0);
  elseif Player.DashTimer <= 0 then
    Player.DashTimer = 0;
    Player.SetXVelocity(Player.MoveInput.x * Player.MoveSpeed);
  else
    Player.SetYVelocity(0);
    Player.DashTimer = Player.DashTimer - _dt;
  end

  if Player.ShootTimer > 0 then
    Player.ShootTimer = Player.ShootTimer - _dt;
  end

  if Player.IntroTimer > 0 then
    Player.IntroTimer = Player.IntroTimer - _dt;
    Player.Sprite.CurrentAnimation = 8;
  elseif Player.DamageTimer > 0 then
    Player.Sprite.CurrentAnimation = 10;
  elseif Player.DashTimer > 0.001 then
    Player.Sprite.CurrentAnimation = 4;
  elseif Player.AimLock == true then
    Player.HandleAimLockAnims();
  elseif Player.IsGrounded == false then
    Player.RigidBody:SetSize(Player.Sprite.xFrameSize - 230, Player.Sprite.yFrameSize - 100, 0, 40);
    Player.Sprite.CurrentAnimation = 3;
  elseif Player.IsCrouched == true then
    Player.RigidBody:SetSize(Player.Sprite.xFrameSize - 230, Player.Sprite.yFrameSize - 100, 0, 40);
    if Player.CrouchTimer > 0 then
      Player.Sprite.CurrentAnimation = 5;
      Player.CrouchTimer = Player.CrouchTimer - _dt;
    else
      Player.CrouchTimer = 0;
      Player.Sprite.CurrentAnimation = 6;
    end
    if Player.ShootTimer > 0 then
      Player.Sprite.CurrentAnimation = 7;
    end
  elseif Player.ShootTimer > 0 then
    if Player.RigidBody:GetXSpeed() > 0.01 then
      Player.Sprite.CurrentAnimation = 9;
    else
      Player.Sprite.CurrentAnimation = 17;
    end
  elseif Player.RigidBody:GetXSpeed() > 0.01 then
    Player.Sprite.CurrentAnimation = 2;
  else
    Player.Sprite.CurrentAnimation = 1;
  end

  if Player.Health <= 0 then
    if Player.DeathTimer > 0 then
      Player.DeathTimer = Player.DeathTimer - _dt;
      Player.Sprite.CurrentAnimation = 11;
      Player.SetYVelocity(0);
      Player.SetXVelocity(0);
    else
      Player.Destroy = true;
    end
  end
end

function Player.HandleAimLockAnims()
  if Player.ShootTimer <= 0 then
    if Player.Input.x ~= 0 and Player.Input.y == 0 then
      Player.Sprite.CurrentAnimation = 12;
    elseif Player.Input.y < 0 and Player.Input.x == 0 then
      Player.Sprite.CurrentAnimation = 13;
    elseif Player.Input.y > 0 and Player.Input.x == 0 then
      Player.Sprite.CurrentAnimation = 14;
    elseif Player.Input.x ~= 0 and Player.Input.y < 0 then
      Player.Sprite.CurrentAnimation = 15;
    elseif Player.Input.x ~= 0 and Player.Input.y > 0 then
      Player.Sprite.CurrentAnimation = 16;
    end
  else
    if Player.Input.x ~= 0 and Player.Input.y == 0 then
      Player.Sprite.CurrentAnimation = 17;
    elseif Player.Input.y < 0 and Player.Input.x == 0 then
      Player.Sprite.CurrentAnimation = 18;
    elseif Player.Input.y > 0 and Player.Input.x == 0 then
      Player.Sprite.CurrentAnimation = 19;
    elseif Player.Input.x ~= 0 and Player.Input.y < 0 then
      Player.Sprite.CurrentAnimation = 20;
    elseif Player.Input.x ~= 0 and Player.Input.y > 0 then
      Player.Sprite.CurrentAnimation = 21;
    end
  end
end

function Player.SetVelocity(_amount)
  Player.RigidBody:SetVelocity(_amount.x * Player.MoveSpeed, _amount.y * Player.MoveSpeed);
end

function Player.SetXVelocity(_amount)
  Player.RigidBody:SetVelocity(_amount * Player.MoveSpeed,  Player.RigidBody:GetVelocity().y);
end

function Player.SetYVelocity(_amount)
  Player.RigidBody:SetVelocity(Player.RigidBody:GetVelocity().x,  _amount * Player.MoveSpeed);
end

function Player.ApplyLinearImpulse(_amount)
  Player.RigidBody:ApplyLinearImpulse(_amount.x, _amount.y);
end

function Player.ApplyLinearImpulse(_x, _y)
  Player.RigidBody:ApplyLinearImpulse(_x, _y);
end

function Player.GetPosition()
  return Player.Sprite:GetPosition();
end

function Player.Dash()
  if  Player.DashTimer <= 0 and Player.IntroTimer <= 0 and Player.Destroy == false and Player.DamageTimer <= 0 then
    math.randomseed(os.time());
    local randomSound = math.random(1,3);
    Player.AudioManager:CreateSound("Dash", "Resources/Sounds/Player/Dash (".. randomSound .. ").wav", true, false);

    Player.AimLock = false;
    Player.DashTimer = Player.DashDuration;
    Player.SetXVelocity(Player.Sprite.XScale * Player.DashSpeed);
  end
end

function Player.Draw()
  Player.Sprite:Draw();
  Player.RigidBody:Draw();
end

return Player;
