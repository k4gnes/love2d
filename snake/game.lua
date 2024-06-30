--set up the new game
function game_start()
  state = GameStates.running
  --directions from the keypress event default is up
  left, right, up, down = false, false, true, false 
  dirX=0
  dirY=-1
  --position for snake's head in center
  head={width/2,(height-1)/2}
  --table for the snake's tail 
  tail = {}
  speed=0.25
  timer=0
   --add food to the game
  --table for the apple
  apple={}
  apple=getFreePos()
end

--returnn with a random free coordinates for the new apple
function getFreePos()
  freepos={}
  local free=true
  for i=0 , width-1 do
    for j=0 , height-1 do
      if apple[1]==i and apple[2]==j then
        free=false
      end
      --this is the same position, because only check when feeding
      if head[1]==i and head[2]==j then
        free=false
      end
      for _,v in ipairs (tail) do
        if v[1]==i and v[2]==j then
          free=false
        end
      end
      if free then
        table.insert(freepos,{i,j})       
      else
        free=true
      end      
    end
  end
  --if no free coordinate because the snake is too big
  if #freepos==0 then
    state = GameStates.game_over
    return {0,0}
  else
    randompos=math.random(#freepos)
    return freepos[randompos]
  end  
end


--draw
function game_draw()
  --draw the sneak's head rounded rectangle with size (width and height also equals unit) 
  love.graphics.setColor(0,0.8,0)
  love.graphics.rectangle("fill", head[1]*unit,head[2]*unit, unit, unit,5,5)
  
  --draw the tail rounded rectangle (like head)
  love.graphics.setColor(0,0.8,0)
  for i,v in ipairs( tail) do 
    love.graphics.rectangle("fill", v[1]*unit,v[2]*unit, unit, unit,5,5);
  end
  
  --draw the apple rounded rectangle just like head and tail
  love.graphics.setColor(0.8,0,0)
  love.graphics.rectangle( "fill", apple[1]*unit,apple[2]*unit,unit,unit,5,5)
end

--update
function game_update(dt)
  
--time limit for speed of snake 
    timer=timer+dt
    if timer>=speed then
     --set direction of the snake change its direction back only if has no tail
      if up and (dirY==0 or #tail==0) then
        dirX,dirY = 0,-1       
      elseif down and (dirY==0 or #tail==0) then
        dirX,dirY = 0,1     
      elseif left and (dirX==0 or #tail==0) then
        dirX,dirY = -1,0    
      elseif right and (dirX==0 or #tail==0) then
        dirX,dirY = 1,0      
      end
    
      -- Movement
      --moving the snake's head 
      head[1] = head[1] + dirX
      head[2] = head[2] + dirY
    
      --check food
      if head[1]==apple[1] and head[2]==apple[2] then
        --add_apple()
        apple=getFreePos()
        table.insert(tail,{head[1]-dirX,head[2]-dirY})     
      end
    
      --set snake tail parts
      --from tail end to second 
      for i = #tail, 2 ,-1 do
        tail[i]=tail[i-1]
      end    
      --first tail part behind the head
      if #tail > 0 then
        tail[1] = {head[1] - dirX,head[2] - dirY}
      end
        
      --check if game is over
      --because snake'a head is out of the screen
      if head[1] <0 or head[2]<0 or head[1]>width-1 or head[2]>height-1   then
        --game is over
        state = GameStates.game_over
      end
    
      --because snake's head is in the tail
      for i,v in ipairs(tail) do
        if head[1]==v[1] and head[2]==v[2] and i~=1 then
        --game is over
          state = GameStates.game_over
        end
      end
      timer=0
    end
 end




    
  
