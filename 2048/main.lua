function love.load()
    -- initialize random number generator
    if (G == nil) then
        G = love.graphics
        love.window.setMode(1024, 600)
        love.window.setTitle("2048")
        normallove = true
    else
        normallove = false
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
    rnd = math.random(16)
    while (notinlist(numlist, rnd) == false) do
        rnd = math.random(16)
    end
    game15[rnd] = 2
end
direction = {
    left = function()
        addNewNumber()
    end,

    right = function()
        addNewNumber()
    end,

    up = function()
        print("pressed up, status", status, #numlist)
        --filltheline(game15[1],game15[5],game15[9],game15[13])
        game15[1] = game15[1] + game15[5] + game15[9] + game15[13]
        game15[5] = 0
        game15[9] = 0
        game15[13] = 0
        if (game15[1] > 0 and notinlist(numlist, 1)) then
            table.insert(numlist, 1)
            table.remove(numlist, getpos(numlist, 5))
            table.remove(numlist, getpos(numlist, 9))
            table.remove(numlist, getpos(numlist, 13))
        end
        game15[2] = game15[2] + game15[6] + game15[10] + game15[14]
        game15[6] = 0
        game15[10] = 0
        game15[14] = 0
        if (game15[2] > 0 and notinlist(numlist, 2)) then
            table.insert(numlist, 2)
            table.remove(numlist, getpos(numlist, 6))
            table.remove(numlist, getpos(numlist, 10))
            table.remove(numlist, getpos(numlist, 14))
        end
        game15[3] = game15[3] + game15[7] + game15[11] + game15[15]
        game15[7] = 0
        game15[11] = 0
        game15[15] = 0
        if (game15[3] > 0 and notinlist(numlist, 3)) then
            table.insert(numlist, 3)
            table.remove(numlist, getpos(numlist, 7))
            table.remove(numlist, getpos(numlist, 11))
            table.remove(numlist, getpos(numlist, 15))
        end
        game15[4] = game15[4] + game15[8] + game15[12] + game15[16]
        game15[8] = 0
        game15[12] = 0
        game15[16] = 0
        if (game15[4] > 0 and notinlist(numlist, 4)) then
            table.insert(numlist, 4)
            table.remove(numlist, getpos(numlist, 8))
            table.remove(numlist, getpos(numlist, 12))
            table.remove(numlist, getpos(numlist, 16))
        end
        addNewNumber()
    end,

    down = function()
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

if normallove then
else
    start()
end

