--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Framebuffer.lua
--Description : Framebuffer Implementation File
--Author : Will Inman

local Framebuffer = {Shader};
local Moonshine = require('moonshine')

-- Initializes the frame bufer and all chains all the post processing together
function Framebuffer:InitFrameBuffer()
  Framebuffer.canvas = love.graphics.newCanvas(WindowSize.x, WindowSize.y);

  love.graphics.setCanvas(Framebuffer.canvas);
  love.graphics.clear(0,0,0,0);
  love.graphics.setBlendMode("alpha");
  love.graphics.setCanvas();

  Framebuffer.Shader = Moonshine(Moonshine.effects.filmgrain).chain(Moonshine.effects.sketch).chain(Moonshine.effects.desaturate).chain(Moonshine.effects.vignette);
  Framebuffer.Shader.filmgrain.size = 2;
  Framebuffer.Shader.filmgrain.opacity = 1.0;
  Framebuffer.Shader.vignette.opacity = 1.0;
end

-- Bind the frame buffer
function Framebuffer:Bind()
  love.graphics.setCanvas(Framebuffer.canvas);
  love.graphics.clear(0,0,0,0);
  love.graphics.setBlendMode("alpha");
end

-- Unbind and draw the frame buffer
function Framebuffer:UnBind()
  love.graphics.setCanvas();
  Framebuffer.Shader(function()
    love.graphics.draw(Framebuffer.canvas, 0,0);
  end)
end

return Framebuffer;
