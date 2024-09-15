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

function runningDraw()
    --draw game area 4x4 square
    love.graphics.setColor(1, 0, 0)

    for i = 1, 16 do
        if (i % 4 > 0) then
            x = (math.floor(i / 4) + 1) * 100
            y = (i % 4 - 1) * 100 + 10
        else
            x = i / 4 * 100
            y = 310
        end
        love.graphics.rectangle("line", x, y, 100, 100)
    end

    --draw numbers 
    love.graphics.setNewFont(20)
    love.graphics.setColor(1, 1, 1)
    for i = 1, 16 do
        if (i % 4 > 0) then
            x = (i % 4) * 100 + 50
            y = math.floor(i / 4) * 100 + 50
        else
            x = 450
            y = (i / 4 - 1) * 100 + 50
        end

        if (game[i] == i) then
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(game[i], x, y, 0)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press [ESC] to leave\nPress [SPACE] for a new game", 0, 500, 500, "center")
end

function runningUpdate()
    cnt = 0
    for i = 1, 15 do
        if (game[i] == i) then
            cnt = cnt + 1
        end
    end
    if cnt == 15 then
        gameover()
    end

end

function runningKeypressed(key)
    if direction[key] then
        direction[key]()
    end
    if key == "space" then
        start()
    end
    if key == "escape" then
        love.event.quit()
    end
end

direction = {
    left = function()
        if index % 4 > 0 then
            game[index] = game[index + 1]
            game[index + 1] = ""
            index = index + 1
        end
    end,

    right = function()
        if (index + 3) % 4 > 0 then
            game[index] = game[index - 1]
            game[index - 1] = ""
            index = index - 1
        end
    end,

    up = function()
        if index < 13 then
            game[index] = game[index + 4]
            game[index + 4] = ""
            index = index + 4
        end

    end,

    down = function()
        if index > 4 then
            game[index] = game[index - 4]
            game[index - 4] = ""
            index = index - 4
        end
    end
}

function gameover()
    love.draw = gameoverDraw
    love.keypressed = gameoverKeypressed
end

function gameoverDraw()
    runningDraw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PUZZLE SOLVED\nPress [SPACE] for a new game", 0, 500, 500, "center")
end

function gameoverKeypressed(key)
    if key == "space" then
        start()
    end
end

function start()
    running()
    --position of the hole
    index = math.random(16)
    game = {}
    fillGame()
end

function fillGame()
    cnt = 0;
    while cnt < 16 do
        random = math.random(15)
        neednew = false
        for i = 1, 15 do
            if game[i] == random then
                neednew = true
            end
        end
        if not neednew then
            game[cnt] = random
            cnt = cnt + 1
        end
    end
    game[16] = game[index]
    game[index] = ""

end

