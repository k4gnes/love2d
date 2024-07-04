--size for draw
unit = 10
--game area dimensions
width = 128
height = 75  

function love.conf(t)
  --set window width and height from the specification
  t.window.width = 1280
  t.window.height = 750
  t.window.title = "snake"
  t.window.console = true  
end
