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
function mixing()
    love.draw = mixingDraw
    love.update = mixingUpdate
    love.keypressed = mixingKeypressed
end
function solving()
    love.draw = solvingDraw
    love.update = solvingUpdate
    love.keypressed = solvingKeypressed
end
function randoming()
    love.draw = randomingDraw
    love.update = randomingUpdate
    love.keypressed = randomingKeypressed
end
function gameover()
    love.draw = gameoverDraw
    love.update = gameoverUpdate
    love.keypressed = gameoverKeypressed
end

function runningDraw()
    drawBoard()
    G.setColor(1, 1, 1)
    G.printf("Press [ESC] to leave\nPress [r] to random\nPress [s] to SOLVE\nPress [m] to MIX", 0, 500, 500, "center")
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
        mixing()
    end
    if key == "r" then
        startRandom()
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
    if not mixed then
        mix()
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
function mixingDraw()
    drawBoard()
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
        if status=="randoming" then
            solveRandom()
            status="solving"
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

function mix()
    steps = math.random(80)
    dir = 0
    last = 0
    cnt = 0
    while cnt < steps do
        dir = math.random(4)
        if last > 0 then
            if dir == 1 then
                if last ~= 2 then
                    size = #movelist
                    direction.right()
                    if #movelist > size then
                        cnt = cnt + 1
                        last = 1
                    end
                end
            end
            if dir == 2 then
                if last ~= 1 then
                    size = #movelist
                    direction.left()
                    if #movelist > size then
                        cnt = cnt + 1
                        last = 2
                    end
                end
            end
            if dir == 3 then
                if last ~= 4 then
                    size = #movelist
                    direction.down()
                    if #movelist > size then
                        cnt = cnt + 1
                        last = 3
                    end
                end
            end
            if dir == 4 then
                if last ~= 3 then
                    size = #movelist
                    direction.up()
                    if #movelist > size then
                        cnt = cnt + 1
                        last = 4
                    end
                end
            end
        else
            if dir == 1 then
                size = #movelist
                direction.right()
                if #movelist > size then
                    cnt = cnt + 1
                    last = 1
                end
            end
            if dir == 2 then
                size = #movelist
                direction.left()
                if #movelist > size then
                    cnt = cnt + 1
                    last = 2
                end
            end
            if dir == 3 then
                size = #movelist
                direction.down()
                if #movelist > size then
                    cnt = cnt + 1
                    last = 3
                end
            end
            if dir == 4 then
                size = #movelist
                direction.up()
                if #movelist > size then
                    cnt = cnt + 1
                    last = 4
                end
            end
        end
    end
    mixed = true
    print("called mix movelist size: ", #movelist)
end

function solve()
    if (status == "solving" and #movelist > 0) then
        print("solve movelist size start", #movelist, movelist[#movelist])
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
        print("solve movelist size end", #movelist)
    end
end
function solveRandom()
    --todo fill movelist
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
    game15[1] = 5
    game15[2] = 6
    game15[3] = 12
    game15[4] = 3

    game15[5] = ""
    game15[6] = 4
    game15[7] = 11
    game15[8] = 13

    game15[9] = 7
    game15[10] = 10
    game15[11] = 14
    game15[12] = 1

    game15[13] = 2
    game15[14] = 15
    game15[15] = 8
    game15[16] = 9
end

function fillPhaseZero()
    for i = 1, 15 do
        game15[i] = i
    end
    game15[16] = ""
    missingpart = 16
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
    fillPhaseZero()
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



