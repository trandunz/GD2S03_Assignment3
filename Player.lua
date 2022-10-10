Player = {Sprite = require("Sprite"), MoveSpeed = 100, MoveInput = require("Vec2"):new(), RigidBody = require("RigidBody"):new()};

function Player.Create(_xPos, _yPos)
  Player.Sprite.Create("Resources/Textures/PatricStar.png", _xPos, _yPos);
  Player.RigidBody:CreateCube(_xPos, _yPos, Player.Sprite.GetWidth(), Player.Sprite.GetHeight(), "dynamic");
end

function Player.GrabInput()
  Player.MoveInput.x = 0;
  Player.MoveInput.y = 0;

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

  if Player.MoveInput:Mag() ~= 0 then
    print("Player Moved!");
    Player.Move(Player.MoveInput, _dt);
  end
end

function Player.Move(_amount, _dt)
  Player.RigidBody:Move(Player.Sprite.XPos + _amount.x * Player.MoveSpeed, Player.Sprite.YPos + _amount.y * Player.MoveSpeed);
end

function Player.Draw()
  Player.Sprite.Draw();
end

return Player;
