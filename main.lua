function love.load()

    -- Load game title
    love.window.setTitle("Space it till you make it")

    -- Load window resolution
    WINDOW_WIDTH = 800
    WINDOW_HEIGHT = 600
    
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    
    -- Load player
    player = {}
    player.width = 40
    player.height = 40
    player.speed = 50
    player.x = 25
    player.y = WINDOW_HEIGHT - player.height - 25

    -- Load goal zone
    goal = {}
    goal.width = 40
    goal.height = 40
    goal.x = WINDOW_WIDTH - goal.width - 25
    goal.y = 25

    -- load enemy
    enemy = {}
    enemy.width = 40
    enemy.height = 40
    enemy.speed = 50
    enemy.x = (WINDOW_WIDTH - enemy.width) / 2
    enemy.y = (WINDOW_HEIGHT - enemy.height) / 2

    -- Load random key
    randomKey = nil

    -- Load music
    -- "Mammoth" by congusbongus licensed OGA-BY 4.0, CC-BY 4.0: https://opengameart.org/content/mammoth
    music = love.audio.newSource("mammoth.ogg", "stream")

    -- Load gameOver boolean
    gameOver = false

    -- Load font size
    font = love.graphics.newFont(20)

end

-- Set random movement
function getRandomKey()
    keys = { "w", "s", "a", "d" }

    return keys[math.random(4)]
end

function love.keypressed(key)
    if key == "space" then
        randomKey = getRandomKey()
        enemyRandomKey = getRandomKey()
    end
    
end


function love.update(dt)

    if gameOver then
        return
    end

    -- Play music
    love.audio.play(music)

    -- Handle player movement
    if love.keyboard.isDown("space") then
        randomKey = getRandomKey()
        enemyRandomKey = getRandomKey()
    end

    if randomKey == "w" then
        if player.y - player.speed >= 0 then
            player.y = player.y - player.speed
            randomKey = nil
        end
    elseif randomKey == "s" then
        if player.y + player.speed <= WINDOW_HEIGHT - player.height then
            player.y = player.y + player.speed
            randomKey = nil
        end
    elseif randomKey == "a" then
        if player.x - player.speed >= 0 then
            player.x = player.x - player.speed
            randomKey = nil
        end
    elseif randomKey == "d" then
        if player.x + player.speed <= WINDOW_WIDTH - player.width then
            player.x = player.x + player.speed
            randomKey = nil
        end
    end

    -- Handle enemy movement
    if enemyRandomKey == "w" then
        if enemy.y - enemy.speed >= 0 then
            enemy.y = enemy.y - enemy.speed
            enemyRandomKey = nil
        end
    elseif enemyRandomKey == "s" then
        if enemy.y + enemy.speed <= WINDOW_HEIGHT - enemy.height then
            enemy.y = enemy.y + enemy.speed
            enemyRandomKey = nil
        end
    elseif enemyRandomKey == "a" then
        if enemy.x - enemy.speed >= 0 then
            enemy.x = enemy.x - enemy.speed
            enemyRandomKey = nil
        end
    elseif enemyRandomKey == "d" then
        if enemy.x + enemy.speed <= WINDOW_WIDTH - enemy.width then
            enemy.x = enemy.x + enemy.speed
            enemyRandomKey = nil
        end
    end

    -- Handle player collision with enemy
    if player.x < enemy.x + enemy.width and
    player.x + player.width > enemy.x and
    player.y < enemy.y + enemy.height and
    player.y + player.height > enemy.y then
        local hit = love.audio.newSource("hit.wav", "static")
        hit:play()
        player.x = 25
        player.y = WINDOW_HEIGHT - player.height - 25
    end

    -- Handle enemy collision with goal
    if enemy.x < goal.x + goal.width and
    enemy.x + enemy.width > goal.x and
    enemy.y < goal.y + goal.height and
    enemy.y + enemy.height > goal.y then
        local hit = love.audio.newSource("hit.wav", "static")
        hit:play()
        player.x = 25
        player.y = WINDOW_HEIGHT - player.height - 25
        enemy.x = (WINDOW_WIDTH - enemy.width) / 2
        enemy.y = (WINDOW_HEIGHT - enemy.height) / 2
    end

    -- Handle player collision with goal
    if player.x < goal.x + goal.width and
    player.x + player.width > goal.x and
    player.y < goal.y + goal.height and
    player.y + player.height > goal.y then
        player.x = 25
        player.y = WINDOW_HEIGHT - player.height - 25
        gameOver = true
        music:stop()
        -- "Win Jingle" by Fupi licensed CC0: https://opengameart.org/content/win-jingle
        local victory = love.audio.newSource("winfretless.ogg", "static")
        victory:play()
    end

end


function love.keypressed(key)
    if key == 'return' then
        gameOver = false
    end
end


function love.draw()

    -- Draw player
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Draw goal zone
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", goal.x, goal.y, goal.width, goal.height)

    -- Draw enemy
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)

    -- Draw victory text
    if gameOver then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print("Congratulations! You've won! You are now finally FREE!", WINDOW_WIDTH / 6, WINDOW_HEIGHT / 6)
        love.graphics.print("Press ENTER to play again!", WINDOW_WIDTH / 6, WINDOW_HEIGHT / 4)
    end

end