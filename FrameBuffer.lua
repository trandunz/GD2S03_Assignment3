local Framebuffer = {Shader};
local Moonshine = require('moonshine')

function Framebuffer:InitFrameBuffer()
  Framebuffer.canvas = love.graphics.newCanvas(800, 800);

  love.graphics.setCanvas(Framebuffer.canvas);
  love.graphics.clear(0,0,0,0);
  love.graphics.setBlendMode("alpha");
  love.graphics.setCanvas();

  Framebuffer.Shader = Moonshine(Moonshine.effects.filmgrain).chain(Moonshine.effects.sketch).chain(Moonshine.effects.desaturate).chain(Moonshine.effects.vignette);
  Framebuffer.Shader.filmgrain.size = 2;
  Framebuffer.Shader.filmgrain.opacity = 1.0;
  Framebuffer.Shader.vignette.opacity = 1.0;
end

function Framebuffer:Bind()
  love.graphics.setCanvas(Framebuffer.canvas);
  love.graphics.clear(0,0,0,0);
  love.graphics.setBlendMode("alpha");
end

function Framebuffer:UnBind()
  love.graphics.setCanvas();
  Framebuffer.Shader(function()
    love.graphics.draw(Framebuffer.canvas, 0,0);
  end)
end

return Framebuffer;
