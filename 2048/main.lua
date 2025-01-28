is_compy = true
function love.load()
    -- initialize random number generator
    if (G == nil) then
        G = love.graphics
        love.window.setMode(1024, 600)
        love.window.setTitle("2048")
        is_compy = false
    end
    start()
end
game = {
    draw = runningDraw,
    keypressed = runningKeypressed,
    update = runningUpdate
}
function love.draw()
    game.draw()
end
function love.keypressed(key)
    game.keypressed(key)
end
function love.update(dt)
    game.update(dt)
end
function running()
    game.draw = runningDraw
    game.update = runningUpdate
    game.keypressed = runningKeypressed
end

function gameover()
    game.draw = gameoverDraw
    game.update = gameoverUpdate
    game.keypressed = gameoverKeypressed
end

function runningDraw()
    drawBoard()
    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [SPACE] to new game", 0, 450, 500, "center")
end
function runningUpdate(dt)


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
function notinlist(table, item)
    for i = 1, #table do
        if table[i] == item then
            return false
        end
    end
    return true
end
function getpos(table, item)
    for i = 1, #table do
        if (table[i] == item) then
            return i
        end
    end
    return 0
end
function addNewNumber()
    if (#numlist <= 16) then


        rnd = math.random(16)
        while (notinlist(numlist, rnd) == false) do
            rnd = math.random(16)
        end
        rnd2 = math.random(2)
        game15[rnd] = 2 * rnd2
    end
end

function filltheline(a, b, c, d)

    --calculate position a
    if (game15[a] > 0) then
        if (game15[b] > 0) then
            if (game15[a] == game15[b]) then
                game15[a] = game15[a] + game15[b]
                game15[b] = 0
                table.remove(numlist, getpos(numlist, b))
            end
        else
            if (game15[b] == 0) then
                if (game15[c] > 0) then
                    if (game15[a] == game15[c]) then
                        game15[a] = game15[a] + game15[c]
                        game15[c] = 0
                        table.remove(numlist, getpos(numlist, c))
                    end
                else
                    if (game15[c] == 0) then
                        if (game15[d] > 0) then
                            if (game15[a] == game15[d]) then
                                game15[a] = game15[a] + game15[d]
                                game15[d] = 0
                                table.remove(numlist, getpos(numlist, d))
                            end
                        end
                    end
                end
            end
        end
    else
        if (game15[a] == 0) then
            if (game15[b] > 0) then
                if (game15[c] > 0) then
                    if (game15[b] == game15[c]) then
                        game15[a] = game15[b] + game15[c]
                        game15[b] = 0
                        game15[c] = 0
                        table.remove(numlist, getpos(numlist, b))
                        table.remove(numlist, getpos(numlist, c))
                    else
                        game15[a] = game15[b]
                        game15[b] = 0
                        table.remove(numlist, getpos(numlist, b))
                    end
                else
                    if (game15[c] == 0) then
                        if (game15[d] > 0) then
                            if (game15[b] == game15[d]) then
                                game15[a] = game15[b] + game15[d]
                                game15[b] = 0
                                game15[d] = 0
                                table.remove(numlist, getpos(numlist, b))
                                table.remove(numlist, getpos(numlist, d))
                            else
                                game15[a] = game15[b]
                                game15[b] = 0
                                table.remove(numlist, getpos(numlist, b))
                            end
                        else
                            if (game15[d] == 0) then
                                game15[a] = game15[b]
                                game15[b] = 0
                                table.remove(numlist, getpos(numlist, b))
                            end
                        end
                    end
                end
            else
                if (game15[b] == 0) then
                    if (game15[c] > 0) then
                        if (game15[d] > 0) then
                            if (game15[c] == game15[d]) then
                                game15[a] = game15[c] + game15[d]
                                game15[c] = 0
                                game15[d] = 0
                                table.remove(numlist, getpos(numlist, c))
                                table.remove(numlist, getpos(numlist, d))
                            else
                                game15[a] = game15[c]
                                game15[c] = 0
                                table.remove(numlist, getpos(numlist, c))
                            end
                        else
                            if (game15[d] == 0) then
                                game15[a] = game15[c]
                                game15[c] = 0
                                table.remove(numlist, getpos(numlist, c))
                            end
                        end
                    else
                        if (game15[c] == 0) then
                            if (game15[d] > 0) then
                                game15[a] = game15[d]
                                game15[d] = 0
                                table.remove(numlist, getpos(numlist, d))
                            end
                        end
                    end
                end
            end
        end

    end
    if (game15[a] > 0 and notinlist(numlist, a)) then
        table.insert(numlist, a)
    end
    --calculate position b
    if (game15[b] > 0) then
        if (game15[c] > 0) then
            if (game15[b] == game15[c]) then
                game15[b] = game15[b] + game15[c]
                game15[c] = 0
                table.remove(numlist, getpos(numlist, c))
            end
        else
            if (game15[c] == 0) then
                if (game15[d] > 0) then
                    if (game15[b] == game15[d]) then
                        game15[b] = game15[b] + game15[d]
                        game15[d] = 0
                        table.remove(numlist, getpos(numlist, d))
                    end
                end
            end
        end
    else
        if (game15[b] == 0) then
            if (game15[c] > 0) then
                if (game15[d] > 0) then
                    if (game15[c] == game15[d]) then
                        game15[b] = game15[c] + game15[d]
                        game15[c] = 0
                        game15[d] = 0
                        table.remove(numlist, getpos(numlist, c))
                        table.remove(numlist, getpos(numlist, d))
                    else
                        game15[b] = game15[c]
                        game15[c] = 0
                        table.remove(numlist, getpos(numlist, c))
                    end
                else
                    if (game15[d] == 0) then
                        game15[b] = game15[c]
                        game15[c] = 0
                        table.remove(numlist, getpos(numlist, c))
                    end
                end
            else
                if (game15[c] == 0) then
                    if (game15[d] > 0) then
                        game15[b] = game15[d]
                        game15[d] = 0
                        table.remove(numlist, getpos(numlist, d))
                    end
                end
            end
        end
    end
    if (game15[b] > 0 and notinlist(numlist, b)) then
        table.insert(numlist, b)
    end
    --calculate position c
    if (game15[c] > 0) then
        if (game15[d] > 0) then
            if (game15[c] == game15[d]) then
                game15[c] = game15[c] + game15[d]
                game15[d] = 0
                table.remove(numlist, getpos(numlist, d))
            end
        else
            if (game15[d] == 0) then

            end
        end
    else
        if (game15[c] == 0) then
            if (game15[d] > 0) then
                game15[c] = game15[d]
                game15[d] = 0
                table.remove(numlist, getpos(numlist, d))
            end
        end
    end
    if (game15[c] > 0 and notinlist(numlist, c)) then
        table.insert(numlist, c)
    end
    --calculate position d

end
direction = {
    left = function()
        filltheline(1, 2, 3, 4)
        filltheline(5, 6, 7, 8)
        filltheline(9, 10, 11, 12)
        filltheline(13, 14, 15, 16)
        addNewNumber()
    end,

    right = function()
        filltheline(4, 3, 2, 1)
        filltheline(8, 7, 6, 5)
        filltheline(12, 11, 10, 9)
        filltheline(16, 15, 14, 13)
        addNewNumber()
    end,

    up = function()

        filltheline(1, 5, 9, 13)
        filltheline(2, 6, 10, 14)
        filltheline(3, 7, 11, 15)
        filltheline(4, 8, 12, 16)
        print(#numlist)
        addNewNumber()
    end,

    down = function()
        filltheline(13, 9, 5, 1)
        filltheline(14, 10, 6, 2)
        filltheline(15, 11, 7, 3)
        filltheline(16, 12, 8, 4)

        addNewNumber()
    end
}

function gameoverDraw()
    drawBoard()
    G.setColor(1, 1, 1)
    G.printf("PUZZLE SOLVED\nPress [SPACE] for a new game\n or [ESCAPE] for exit", 0, 500, 500, "center")
end
function gameoverUpdate()

end
function gameoverKeypressed(key)
    if key == "space" then
        start()
    end
    if key == "escape" then
        love.event.quit()
    end
end

function drawBoard()
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
        if game15[i] == 0 then
            G.print("", x, y, 0)

        else
            G.print(game15[i], x, y, 0)

        end
    end

end

function fillGame()

end

function fillPhaseZero(tbl)
    for i = 1, 16 do
        tbl[i] = 0
    end
    rnd = math.random(16)
    tbl[rnd] = 2
    table.insert(numlist, rnd)
    return tbl
end

function start()
    math.randomseed(os.time())
    running()
    status = "running"
    --position of the hole
    game15 = {}
    numlist = {}
    --phase 0
    game15 = fillPhaseZero(game15)
    missingpart = 16
end

if is_compy then
    start()
end

