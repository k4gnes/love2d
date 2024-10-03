missingpart = 0
game15 = {}
normallove = false
love.window.setTitle("puzzle15")
--start/restart game

function love.load()
    -- initialize random number generator
    if (G == nil) then
        G = love.graphics
        love.window.setMode(1024, 600)
        normallove = true
    else
        normallove = false
    end
    start()
end

function running()
    love.draw = runningDraw
    love.update = runningUpdate
    love.keypressed = runningKeypressed
end

function runningDraw()
    --draw game area 4x4 square
    G.setColor(0.8, 0, 0)

    for i = 1, 16 do
        if (i % 4 > 0) then
            x = (math.floor(i / 4) + 1) * 100
            y = (i % 4 - 1) * 100 + 10
        else
            x = i / 4 * 100
            y = 310
        end
        G.rectangle("line", x, y, 100, 100)
    end

    --draw numbers 
    G.setNewFont(20)
    G.setColor(1, 1, 1)
    for i = 1, 16 do
        if (i % 4 > 0) then
            x = (i % 4) * 100 + 50
            y = math.floor(i / 4) * 100 + 50
        else
            x = 450
            y = (i / 4 - 1) * 100 + 50
        end

        if (game15[i] == i) then
            G.setColor(1, 0, 0)
        else
            G.setColor(1, 1, 1)
        end
        G.print(game15[i], x, y, 0)
    end

    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [SPACE] for a new game", 0, 500, 500, "center")
end

function runningUpdate()
    cnt = 0
    for i = 1, 15 do
        if (game15[i] == i) then
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
        if missingpart % 4 > 0 then
            game15[missingpart] = game15[missingpart + 1]
            game15[missingpart + 1] = ""
            missingpart = missingpart + 1
        end
    end,

    right = function()
        if (missingpart + 3) % 4 > 0 then
            game15[missingpart] = game15[missingpart - 1]
            game15[missingpart - 1] = ""
            missingpart = missingpart - 1
        end
    end,

    up = function()
        if missingpart < 13 then
            game15[missingpart] = game15[missingpart + 4]
            game15[missingpart + 4] = ""
            missingpart = missingpart + 4
        end

    end,

    down = function()
        if missingpart > 4 then
            game15[missingpart] = game15[missingpart - 4]
            game15[missingpart - 4] = ""
            missingpart = missingpart - 4
        end
    end
}

function gameover()
    love.draw = gameoverDraw
    love.keypressed = gameoverKeypressed
end

function gameoverDraw()
    runningDraw()
    G.setColor(1, 1, 1)
    G.printf("PUZZLE SOLVED\nPress [SPACE] for a new game", 0, 500, 500, "center")
end

function gameoverKeypressed(key)
    if key == "space" then
        start()
    end
end
function fillGame()
    cnt = 0
    while cnt < 16 do
        random = math.random(15)
        neednew = false
        for i = 1, 15 do
            if game15[i] == random then
                neednew = true
            end
        end
        if not neednew then
            game15[cnt] = random
            cnt = cnt + 1
        end
    end
    game15[16] = game15[missingpart]
    game15[missingpart] = ""

end
function start()
    math.randomseed(os.time())

    running()
    --position of the hole
    missingpart = math.random(16)
    game15 = {}
    fillGame()
end

if (normallove == false) then
    start()
end