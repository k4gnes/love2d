require "game"

GameStates ={ running= 'running', game_over='game over' }


function love.load()
  math.randomseed(os.time())
  unit=10
  width=128
  height=75  
  game_start()
end

function love.draw()
  game_draw()
  if state==GameStates.game_over then
    --draw the game over screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(20)
    love.graphics.printf("GAME OVER\nPress [SPACE] for a new game", 0, 750 / 2 - 50, 1280, "center")    
  end  
end

function love.update(dt)
  if state==GameStates.running then
    game_update(dt)
  end
end

function love.keypressed(key)
  if key == "left" and state==GameStates.running then
    left,right,up,down = true,false,false,false
  elseif key == "right" and state==GameStates.running then
    left,right,up,down = false, true, false, false
  elseif key == "up" and state==GameStates.running then
    left, right, up, down = false, false, true, false
  elseif key == "down" and state==GameStates.running then
    left, right, up, down = false, false, false, true
  elseif key == "space" and state == GameStates.game_over then
    game_start()
  end
 
end
