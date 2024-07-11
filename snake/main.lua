function love.load()
    -- initialize random number generator
    math.randomseed(os.time())
    --start/restart game
    start()
end

function runningState()
    love.draw = runningDraw
    love.update = runningUpdate
    love.keypressed = runningKeypressed
end

function gameoverState()
    love.draw = gameoverDraw
    love.update = gameoverUpdate
    love.keypressed = gameoverKeypressed
end

function runningDraw()
    --draw the snake's head rounded rectangle with size (width and height also equals unit)
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", head[1] * unit, head[2] * unit, unit, unit, 5, 5)

    --draw the tail rounded rectangle (like head)
    love.graphics.setColor(0, 0.8, 0)
    for _, v in ipairs(tail) do
        love.graphics.rectangle("fill", v[1] * unit, v[2] * unit, unit, unit, 5, 5);
    end

    --draw the apple rounded rectangle just like head and tail
    love.graphics.setColor(0.8, 0, 0)
    love.graphics.rectangle("fill", apple[1] * unit, apple[2] * unit, unit, unit, 5, 5)
end

function gameoverDraw()
    runningDraw()
    --draw the game over screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(20)
    love.graphics.printf("GAME OVER\nPress [SPACE] for a new game", 0, height * 10 / 2 - 50, width * 10, "center")
end

function runningUpdate(dt)
    --time limit for speed of snake
    timer = timer + dt
    if timer < speed then
        return
    end
    --set direction of the snake change its direction back only if has no tail
    if up and (dirY == 0 or #tail == 0) then
        dirX, dirY = 0, -1
    elseif down and (dirY == 0 or #tail == 0) then
        dirX, dirY = 0, 1
    elseif left and (dirX == 0 or #tail == 0) then
        dirX, dirY = -1, 0
    elseif right and (dirX == 0 or #tail == 0) then
        dirX, dirY = 1, 0
    end

    -- Movement
    --moving the snake's head
    head[1] = head[1] + dirX
    head[2] = head[2] + dirY

    --check food
    if head[1] == apple[1] and head[2] == apple[2] then
        --add food and increase the snake
        apple = getfreepos()
        table.insert(tail, { head[1] - dirX, head[2] - dirY })
    end

    --set snake tail parts
    --from tail end to second
    for i = #tail, 2, -1 do
        tail[i] = tail[i - 1]
    end
    --first tail part behind the head
    if #tail > 0 then
        tail[1] = { head[1] - dirX, head[2] - dirY }
    end

    --check if game is over
    --because snake's head is out of the screen
    if head[1] < 0 or head[2] < 0 or head[1] > width - 1 or head[2] > height - 1 then
        --game is over
        gameoverState()
    end

    --because snake's head is in the tail
    for i, v in ipairs(tail) do
        if head[1] == v[1] and head[2] == v[2] and i ~= 1 then
            --game is over
            gameoverState()
        end
    end
    timer = 0
end

function gameoverUpdate(dt)
end

heading = {}

function heading.left()
    left, right, up, down = true, false, false, false
end

function heading.right()
        left, right, up, down = false, true, false, false
end

function heading.up()
        left, right, up, down = false, false, true, false
end

function heading.down()
        left, right, up, down = false, false, false, true
end

function runningKeypressed(key)
    if heading[key] then
        heading[key]()
    end
end

function gameoverKeypressed(key)
    if key == "space" then
        start()
    end
end

function start()
    runningState()
    --directions from the keypressed event default is up
    left, right, up, down = false, false, true, false
    dirX = 0
    dirY = -1
    --position for snake's head in center
    head = { width / 2, (height - 1) / 2 }
    --table for the snake's tail
    tail = {}
    --set speed and timer
    speed = 0.25
    timer = 0
    --table for the apple
    apple = {}
    apple = getfreepos()
end

function getfreepos()
    --random number total game area minus the snake
    local randompos = math.random(width * height - (#tail + 1))
    --free flag and counter
    local free = true
    local cnt = 0
    --iterate in game area, when snake free variable set to false
    for i = 0, width - 1 do
        for j = 0, height - 1 do
            --the snake's head
            if head[1] == i and head[2] == j then
                free = false
            end
            --the snake's tail
            for _, v in ipairs(tail) do
                if v[1] == i and v[2] == j then
                    free = false
                end
            end
            if free then
                cnt = cnt + 1
                if cnt == randompos then
                    --if counter catch the random number return with the free position
                    return { i, j }
                end
            else
                free = true
            end
        end
    end
end
