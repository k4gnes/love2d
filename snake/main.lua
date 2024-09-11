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
        snake[1].y = snake[1].y - 1
    end,
    down = function()
        snake[1].y = snake[1].y + 1
    end,
    left = function()
        snake[1].x = snake[1].x - 1
    end,
    right = function()
        snake[1].x = snake[1].x + 1
    end
}

function runningDraw()
    --draw the snake rounded rectangle
    love.graphics.setColor(0, 0.8, 0)
    for _, snake_part in pairs(snake) do
        love.graphics.rectangle("fill", snake_part.x * unit, snake_part.y * unit, unit, unit, 5, 5);
    end

    --draw the apple rounded rectangle just like snake
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

    local last_head_position = { x = snake[1].x, y = snake[1].y }
    move()

    --check food
    if snake[1].x == apple.x and snake[1].y == apple.y then
        --add food and increase the snake
        apple = get_free_position()
        table.insert(snake, {  })
    end

    --set snake snake parts
    --from snake end to second
    for snake_pos = #snake, 3, -1 do
        snake[snake_pos] = snake[snake_pos - 1]
    end

    if #snake > 1 then
        snake[2] = last_head_position
    end

    --check if game is over
    --because snake's head is out of the screen
    if snake[1].x < 0 or snake[1].y < 0 or snake[1].x > width - 1 or snake[1].y > height - 1 then
        --game is over
        gameover()
    end

    --because snake's head is in the snake
    for _, snake_part in pairs(snake) do
        if _ > 1 then
            if snake[1].x == snake_part.x and snake[1].y == snake_part.y then
                --game is over
                gameover()
            end
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
    --table for the snake
    snake = { {
                  x = width / 2,
                  y = (height - 1) / 2
              } }
    --set speed and timer
    speed = 0.25
    timer = 0
    --table for the apple
    apple = get_free_position()
end

function get_free_position()
    --random number total game area minus the snake
    randompos = math.random(width * height - (#snake))
    local cnt = 0
    --iterate in game area
    gamearea = {}
    for i = 0, width - 1 do
        for j = 0, height - 1 do
            --the snake
            gamearea[j * width + i] = true
        end
    end
    --when snake set to false
    for _, v in ipairs(snake) do
        gamearea[v.y * width + v.x] = false
    end
    --iterate again and return
    for i = 0, width - 1 do
        for j = 0, height - 1 do
            if gamearea[j * width + i] then
                cnt = cnt + 1
                if cnt == randompos then
                    return { x = i, y = j }
                end
            end
        end
    end
end