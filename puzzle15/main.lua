function love.load()
    -- initialize random number generator
    if (G == nil) then
        G = love.graphics
        love.window.setMode(1024, 600)
        love.window.setTitle("puzzle15")
        normallove = true
    else
        normallove = false
    end
    start()
end
game={
    draw=runningDraw,
    keypressed=runningKeypressed,
    update=runningUpdate
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
function mixing()
    game.draw = mixingDraw
    game.update = mixingUpdate
    game.keypressed = mixingKeypressed
end
function solving()
    game.draw = solvingDraw
    game.update = solvingUpdate
    game.keypressed = solvingKeypressed
end
function randoming()
    game.draw = randomingDraw
    game.update = randomingUpdate
    game.keypressed = randomingKeypressed
end
function gameover()
    game.draw = gameoverDraw
    game.update = gameoverUpdate
    game.keypressed = gameoverKeypressed
end

function runningDraw()
    drawBoard()
    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [r] to random\nPress [s] to SOLVE\nPress [m] to MIX\nPress [t] to test", 0, 450, 500, "center")
end
function runningUpdate(dt)
    cnt = 0
    for i = 1, 15 do
        if (game15[i] == i) then
            cnt = cnt + 1
        end
    end
    if cnt == 15 then
        --     status = "gameover"
        --     gameover()
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
    if key == "s" then
        status = "solving"
        solving()
    end
    if key == "m" then
        status = "mixing"
        mixed = false
        steps = 0
        mixing()
    end
    if key == "r" then
        startRandom()
    end
    if key == "t" then
        game15 = {}
        movelist = {}
        --phase 0
        fillGameFix()
        solveRandom()
        print("movelist size", #movelist)
        for i = 1, #movelist do
            print("----->MOVELISt i: ", i, movelist[i])
        end
        status = "solving"
        solving()
    end
end

direction = {
    left = function()
        if missingpart % 4 > 0 then

            game15[missingpart] = game15[missingpart + 1]
            game15[missingpart + 1] = ""
            missingpart = missingpart + 1
            print(missingpart, #movelist)
            if status == "running" or status == "mixing" then
                print("insert left", status)
                table.insert(movelist, "left")
            end
        end
    end,

    right = function()
        if (missingpart + 3) % 4 > 0 then
            game15[missingpart] = game15[missingpart - 1]
            game15[missingpart - 1] = ""
            missingpart = missingpart - 1
            print(missingpart, #movelist)
            if status == "running" or status == "mixing" then
                print("insert right", status)
                table.insert(movelist, "right")
            end
        end
    end,

    up = function()
        print("pressed up, status", status)
        if missingpart < 13 then
            game15[missingpart] = game15[missingpart + 4]
            game15[missingpart + 4] = ""
            missingpart = missingpart + 4
            print(missingpart, status, #movelist)
            if status == "running" or status == "mixing" then
                print("insert up", status)
                table.insert(movelist, "up")
            end
        end

    end,

    down = function()
        if missingpart > 4 then
            game15[missingpart] = game15[missingpart - 4]
            game15[missingpart - 4] = ""
            missingpart = missingpart - 4
            print(missingpart, status, #movelist)
            if status == "running" or status == "mixing" then
                print("insert down", status)
                table.insert(movelist, "down")
            end
        end
    end
}

function mixingUpdate()
    if not mixed and status == "mixing" and steps == 0 then
        steps = math.random(80)
        print("mixing steps", steps)
        dir = 0
        last = 0
        cntr = 0
        old = 0
        size = #movelist
        old = last
        last = mix(last)
        if #movelist > size then
            cntr = cntr + 1
        else
            last = old
        end
    else
        if not mixed and status == "mixing" and cntr < steps then
            size = #movelist
            old = last
            last = mix(last)
            if #movelist > size then
                cntr = cntr + 1
            else
                last = old
            end
        else
            if not mixed and status == "mixing" and cntr == steps then
                mixed = true
            else
                cnt = 0
                for i = 1, 15 do
                    if (game15[i] == i) then
                        cnt = cnt + 1
                    end
                end
                if cnt == 15 then
                    gameover()
                    status = "gameover"
                end
            end
        end
    end
end

function mixingDraw()
    -- drawBoard()

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
        love.timer.sleep(1 / 100)
        G.print(game15[i], x, y, 0)
    end

    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [SPACE] to new game\nPress [s] to SOLVE", 0, 500, 500, "center")
end

function mixingKeypressed(key)
    if direction[key] then
        direction[key]()
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        start()
    end
    if key == "s" then
        status = "solving"
        solving()
    end
end

function solvingUpdate()
    print("solvingUpdate movelist size, status: ", #movelist, ", ", status)
    if #movelist > 0 and status == "solving" then
        solve()
    else
        if status == "randoming" then
            solveRandom()
            print("movelist size", #movelist)
            status = "solving"
        end
    end
    if #movelist == 0 then
        cnt = 0
        for i = 1, 15 do
            if (game15[i] == i) then
                cnt = cnt + 1
            end
        end
        if cnt == 15 then
            gameover()
            status = "gameover"
        end
    end
end
function solvingDraw()
    print("solvingDraw")
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
        love.timer.sleep(1 / 30)
        G.print(game15[i], x, y, 0)
    end

    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [SPACE] to new game", 0, 500, 500, "center")
end
function solvingKeypressed(key)
    if direction[key] then
        direction[key]()
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        start()
    end
end

function randomingUpdate()
    cnt = 0
    for i = 1, 15 do
        if (game15[i] == i) then
            cnt = cnt + 1
        end
    end
    if cnt == 15 then
        gameover()
        status = "gameover"
    end
end
function randomingDraw()

    drawBoard()
    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [SPACE] to new game\n--todo Press [s] to SOLVE", 0, 500, 500, "center")

end
function randomingKeypressed(key)
    if direction[key] then
        direction[key]()
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        start()
    end
    if key == "s" then
        solving()
    end
end

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

        if (game15[i] == i) then
            G.setColor(1, 0, 0)
        else
            G.setColor(1, 1, 1)
        end
        G.print(game15[i], x, y, 0)
    end

end

function mix(last)

    dir = math.random(4)
    --right
    if dir == 1 then
        if last ~= 2 then
            direction.right()
            return dir
        end

    end
    --left
    if dir == 2 then
        if last ~= 1 then
            direction.left()
            return dir
        end
    end
    --down
    if dir == 3 then
        if last ~= 4 then
            direction.down()
            return dir
        end
    end
    --up
    if dir == 4 then
        if last ~= 3 then
            direction.up()
            return dir
        end
    end

    print("called mix movelist size: ", #movelist, cnt, last)
    return last
end

function solve()
    if (status == "solving" and #movelist > 0) then
        print("solve movelist size start", #movelist, movelist[#movelist], missingpart)
        if movelist[#movelist] == "left" then
            direction.right()
        end
        if movelist[#movelist] == "right" then
            direction.left()
        end
        if movelist[#movelist] == "up" then
            direction.down()
        end
        if movelist[#movelist] == "down" then
            direction.up()
        end
        table.remove(movelist, #movelist)
        print("solve movelist size end", #movelist, missingpart)
    end
end

function solveRandom()
    --todo fill movelist

    gameSolved = {}
    gameSolved = fillPhaseZero(gameSolved)

end

function fillGame()
    cnt = 0
    for i = 1, 16 do
        game15[i] = 0
    end
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

function fillGameFix()
    game15[1] = 11
    game15[2] = 14
    game15[3] = 12
    game15[4] = 1

    game15[5] = 4
    game15[6] = 9
    game15[7] = 3
    game15[8] = 2

    game15[9] = 15
    game15[10] = 5
    game15[11] = 8
    game15[12] = 10

    game15[13] = 13
    game15[14] = 7
    game15[15] = 6
    game15[16] = ""
    missingpart = 16
end

function fillPhaseZero(tbl)
    for i = 1, 15 do
        tbl[i] = i
    end
    tbl[16] = ""
    return tbl
end

function getParity(number)
    oddmap = { 15, 12, 13, 10, 7, 4, 5, 2 }
    odd = false
    for i = 1, #oddmap do
        if oddmap[i] == number then
            odd = true
        end
    end
    if odd then
        return 1
    else
        return 0
    end
end

function getSortedParity()
    counter = 0
    swap = 0
    sorted = {}
    for i = 1, 16 do
        sorted[i] = game15[i]
    end
    sorted[missingpart] = 16
    for i = 1, 16 do
        for j = i, 16 do
            if sorted[j] == i then
                if i == j then
                    --   print(i, j, sorted[j])
                    break
                else
                    --   print(i, j, sorted[j])
                    swap = sorted[i]
                    sorted[i] = i
                    sorted[j] = swap
                    counter = counter + 1
                end
            end
        end
    end
    print(counter)
    return counter % 2
end

function start()
    math.randomseed(os.time())
    running()
    status = "running"
    --position of the hole
    game15 = {}
    movelist = {}
    --phase 0
    game15 = fillPhaseZero(game15)
    missingpart = 16
end

function startRandom()
    print("startRandom")
    game15 = {}
    movelist = {}
    --phase 1
    missingpart = math.random(16)
    parity = getParity(missingpart)
    gameParity = (parity + 1) % 2
    while (gameParity ~= parity) do
        fillGame()
        gameParity = getSortedParity()
        print(missingpart, parity, gameParity)
    end
    randoming()
    status = "randoming"
end

if normallove then
else
    start()
end

