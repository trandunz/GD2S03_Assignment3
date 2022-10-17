Player = {Sprite = require("Sprite"), MoveSpeed = 100, MoveInput = require("Vec2"):new(), RigidBody};

function Player.Create(_xPos, _yPos, _world)
  Player.Sprite.Create("Resources/Textures/PatricStar.png", _xPos, _yPos);
  Player.RigidBody = require("RigidBody"):new();
  Player.RigidBody:SetWorld(_world);
  Player.RigidBody:CreateCube(0, 0, Player.Sprite.GetWidth()/2, Player.Sprite.GetHeight()/2, "dynamic");
  Player.RigidBody:SetFixedToRotation(true);
end

function Player.GrabInput()
  Player.MoveInput.x = 0.0;
  Player.MoveInput.y = 0.0;

  if love.keyboard.isDown("up") then
    Player.MoveInput.y = Player.MoveInput.y - 1;
  end
  if love.keyboard.isDown("down") then
    Player.MoveInput.y = Player.MoveInput.y + 1;
  end
  if love.keyboard.isDown("left") then
    Player.MoveInput.x = Player.MoveInput.x - 1;
  end
  if love.keyboard.isDown("right") then
    Player.MoveInput.x = Player.MoveInput.x + 1;
  end

  Player.MoveInput:Normalize();
end

function Player.Update(_dt)

  Player.Sprite.XPos = Player.RigidBody:GetPosition().x;
  Player.Sprite.YPos = Player.RigidBody:GetPosition().y;

  Player.ApplyLinearImpulse(Player.MoveInput * Player.MoveSpeed);
end

function Player.SetVelocity(_amount, _dt)
  Player.RigidBody:SetVelocity(_amount.x * Player.MoveSpeed, _amount.y * Player.MoveSpeed);
end

function Player.ApplyLinearImpulse(_amount)
  Player.RigidBody:ApplyLinearImpulse(_amount.x, _amount.y);
end

function Player.Draw()
  Player.Sprite.Draw();
  Player.RigidBody:Draw();
end

return Player;
