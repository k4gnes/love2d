function love.load()
    -- initialize random number generator
    math.randomseed(os.time())
    --start/restart game
    start()
end

function running()
    love.draw = runningDraw
    love.update = runningUpdate
    love.keypressed = runningKeypressed
end

function gameover()
    love.draw = gameoverDraw
    love.update = gameoverUpdate
    love.keypressed = gameoverKeypressed
end

direction = {
    up = function()
        head.y = head.y - 1
    end,
    down = function()
        head.y = head.y + 1
    end,
    left = function()
        head.x = head.x - 1
    end,
    right = function()
        head.x = head.x + 1
    end
}

function runningDraw()
    --draw the snake's head rounded rectangle with size (width and height also equals unit)
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", head.x * unit, head.y * unit, unit, unit, 5, 5)

    --draw the tail rounded rectangle (like head)
    love.graphics.setColor(0, 0.8, 0)
    for _, tail_part in pairs(tail) do
        love.graphics.rectangle("fill", tail_part.x * unit, tail_part.y * unit, unit, unit, 5, 5);
    end

    --draw the apple rounded rectangle just like head and tail
    love.graphics.setColor(0.8, 0, 0)
    love.graphics.rectangle("fill", apple.x * unit, apple.y * unit, unit, unit, 5, 5)
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

    local last_head_position = { x = head.x, y = head.y }

    move()

    --check food
    if head.x == apple.x and head.y == apple.y then
        --add food and increase the snake
        apple = get_free_position()
        table.insert(tail, {  })
    end

    --set snake tail parts
    --from tail end to second
    for tail_pos = #tail, 2, -1 do
        tail[tail_pos] = tail[tail_pos - 1]
    end

    if #tail > 0 then
        tail[1] = last_head_position
    end

    --check if game is over
    --because snake's head is out of the screen
    if head.x < 0 or head.y < 0 or head.x > width - 1 or head.y > height - 1 then
        print("out of screen")
        --game is over
        gameover()
    end

    --because snake's head is in the tail
    for _, tail_part in pairs(tail) do
        if head.x == tail_part.x and head.y == tail_part.y then
            --game is over
            print("tail ")
            gameover()
        end
    end
    timer = 0
end

function gameoverUpdate(dt)
end

heading = {
    left = function()
        if direction.right ~= move then
            move = direction.left
        end
    end,

    right = function()
        if direction.left ~= move then
            move = direction.right
        end
    end,

    up = function()
        if direction.down ~= move then
            move = direction.up
        end
    end,

    down = function()
        if direction.up ~= move then
            move = direction.down
        end
    end
}

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
    running()
    move = direction.up
    --position for snake's head in center
    head = {
        x = width / 2,
        y = (height - 1) / 2
    }
    --table for the snake's tail
    tail = {}
    --set speed and timer
    -- speed = 0.25
    speed = 0.125
    timer = 0
    --table for the apple
    apple = get_free_position()
end

function get_free_position()
    --random number total game area minus the snake
    local randompos = math.random(width * height - (#tail + 1))
    --free flag and counter
    local free = true
    local cnt = 0
    --iterate in game area, when snake free variable set to false
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            --the snake's head
            if head.x == x and head.y == y then
                free = false
            end
            --the snake's tail
            for _, v in pairs(tail) do
                if v.x == x and v.y == y then
                    free = false
                end
            end
            if free then
                cnt = cnt + 1
                if cnt == randompos then
                    --if counter catch the random number return with the free position
                    return { x = x, y = y }
                end
            else
                free = true
            end
        end
    end
end
