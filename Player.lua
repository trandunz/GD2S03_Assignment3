local Player = {Sprite = require("AnimatedSprite"):new(), MoveSpeed = 20, JumpHeight = 3500, MoveInput = require("Vec2"):new(), RigidBody, IsGrounded = false, DashDuration = 0.34, DashTimer = 0, DashSpeed = 50, IsCrouched = false, CrouchDuration = 0.28, CrouchTimer = 0};

function Player.Create(_xPos, _yPos, _world)
  Player.Sprite:Create("Resources/Textures/Player.png", _xPos, _yPos, 326 ,169);
  Player.Sprite:AddAnimation('1-9', 0.059);
  Player.Sprite:AddAnimation('10-25', 0.04);
  Player.Sprite:AddAnimation('26-33', 0.03);
  Player.Sprite:AddAnimation('34-41', 0.05);
  Player.Sprite:AddAnimation('42-49', 0.05);
  Player.Sprite:AddAnimation('50-54', 0.08);
  Player.Sprite.CurrentAnimation = 1;

  Player.RigidBody = require("RigidBody"):new();
  Player.RigidBody:SetWorld(_world);
  Player.RigidBody:CreateCube(_xPos, _yPos, Player.Sprite.xFrameSize - 230, Player.Sprite.yFrameSize - 20, "dynamic", 0, "player");
  Player.RigidBody:SetFixedToRotation(true);
end

function Player.GrabInput()
  Player.MoveInput.x = 0.0;
  Player.MoveInput.y = 0.0;

  if love.keyboard.isDown("up") and Player.IsCrouched == false then
    Player.MoveInput.y = Player.MoveInput.y - 1;
  end
  if love.keyboard.isDown("down") then
    Player.IsCrouched = true;
  else
    Player.RigidBody:ResetSize();
    Player.IsCrouched = false;
  end
  if love.keyboard.isDown("left") and Player.IsCrouched == false then
    Player.MoveInput.x = Player.MoveInput.x - 1;
  end
  if love.keyboard.isDown("right") and Player.IsCrouched == false then
    Player.MoveInput.x = Player.MoveInput.x + 1;
  end

  --Player.MoveInput:Normalize();
end

function Player.KeyEvents( key, scancode, isrepeat )
  if key == "up" and Player.IsGrounded == true then
    Player.ApplyLinearImpulse(0, -Player.JumpHeight);
  end
  if key == "down" then
    Player.RigidBody:SetSize(Player.Sprite.xFrameSize - 230, Player.Sprite.yFrameSize - 100, 0, 40);
    Player.CrouchTimer = Player.CrouchDuration;
  end
  if key == "space" and Player.DashTimer <= 0 then
    Player.Dash();
  end
end

function Player.Update(_dt)
  Player.Sprite.XPos = Player.RigidBody:GetPosition().x;
  Player.Sprite.YPos = Player.RigidBody:GetPosition().y;
  Player.Sprite:Update(_dt);

  if Player.DashTimer <= 0 then
    Player.DashTimer = 0;
    Player.SetXVelocity(Player.MoveInput.x * Player.MoveSpeed);
  else
    Player.SetYVelocity(0);
    Player.DashTimer = Player.DashTimer - _dt;
  end

  if Player.IsCrouched == true then
  end

  if Player.DashTimer > 0.1 then
    Player.Sprite.CurrentAnimation = 4;
  elseif Player.IsGrounded == false then
    Player.Sprite.CurrentAnimation = 3;
  elseif Player.IsCrouched == true then
    if Player.CrouchTimer > 0 then
      Player.Sprite.CurrentAnimation = 5;
      Player.CrouchTimer = Player.CrouchTimer - _dt;
    else
      Player.CrouchTimer = 0;
      Player.Sprite.CurrentAnimation = 6;
    end
  elseif Player.RigidBody:GetXSpeed() > 0.01 then
    Player.Sprite.CurrentAnimation = 2;
  else
    Player.Sprite.CurrentAnimation = 1;
  end

  if Player.RigidBody:GetVelocity().x < 0 then
    Player.Sprite:SetScale(-1,1);
  elseif Player.RigidBody:GetVelocity().x > 0 then
    Player.Sprite:SetScale(1,1);
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

function Player.Dash()
  Player.DashTimer = Player.DashDuration;
  Player.SetXVelocity(Player.Sprite.XScale * Player.DashSpeed);
end

function Player.Draw()
  Player.Sprite:Draw();
  Player.RigidBody:Draw();
end

return Player;
