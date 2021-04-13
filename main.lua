-- Window param
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

-- Rectangle
RECTANGLE_SPEED = 400
RECTANGLE_WIDTH = 20
RECTANGLE_HEIGHT = 100
math.randomseed(os.time())


-- Main Functions
function love.load()
  --Setup Window
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  });

  love.window.setTitle("Fake-Pong by Leon")

  -- init players
  player_one = {}
  player_one.y = 10
  player_one.x = 10
  player_one.score = 0

  player_two = {}
  player_two.y = WINDOW_HEIGHT-110
  player_two.x = WINDOW_WIDTH-30
  player_two.score = 0

  -- init ball
  ball = {}
  ball.x = WINDOW_WIDTH/2-7
  ball.y = WINDOW_HEIGHT/2-7
  ball.radius = 15

  ball.dx = math.random(2) == 1 and 300 or -300
  ball.dy = math.random(-50, 50)

  --start game
  gameState = 'stopped'
end


function love.update(dt)
  dt = love.timer.getDelta()

  -- if game is started
  if gameState == 'running' then
    -- Player 1 controls
    if love.keyboard.isDown('w') then
      player_one.y = math.max(10, player_one.y - RECTANGLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
      player_one.y = math.min(WINDOW_HEIGHT-110, player_one.y + RECTANGLE_SPEED * dt)
    end
  
    -- Player 2 controls
    if love.keyboard.isDown('up') then
      player_two.y = math.max(10, player_two.y - RECTANGLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
      player_two.y = math.min(WINDOW_HEIGHT-110, player_two.y + RECTANGLE_SPEED * dt)
    end
  
  
    -- update ball movement
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt
  
  
    -- detect collision player one
    collision = true
    if ball.x > player_one.x + RECTANGLE_WIDTH or player_one.x > ball.x + ball.radius then 
      collision = false
    end
    if ball.y > player_one.y + RECTANGLE_HEIGHT or player_one.y > ball.y + ball.radius then
      collision = false
    end
  
    if collision then
      ball.dx = -ball.dx * 1.1
      ball.x = player_one.x + 15
  
      if ball.dy < 0 then
        ball.dy = -math.random(10,150)
      else
        ball.dy = math.random(10, 150)
      end
    end
  
      -- detect collision player two
      collision = true
      if ball.x > player_two.x + RECTANGLE_WIDTH or player_two.x > ball.x + ball.radius then 
        collision = false
      end
      if ball.y > player_two.y + RECTANGLE_HEIGHT or player_two.y > ball.y + ball.radius then
        collision = false
      end
  
  
      -- changes direction of ball and adding speed
      if collision then
        ball.dx = -ball.dx * 1.05
        ball.x = player_two.x - 15
  
        if ball.dy < 0 then
          ball.dy = -math.random(0,300)
        else
          ball.dy = math.random(0, 300)
        end
      end
  
      -- detects if the ball hits the top or the bottom of the screen
      if ball.y > WINDOW_HEIGHT-ball.radius or ball.y <= 0 then
        ball.dy = -ball.dy
      end
  
  
      -- score update
      if ball.x < 0 then
        player_two.score = player_two.score + 1
  
        --reset ball
        ball.x = WINDOW_WIDTH/2-7
        ball.y = WINDOW_HEIGHT/2-7
        ball.dx = math.random(2) == 1 and 300 or -300
        ball.dy = math.random(-50, 50)
  
      elseif ball.x > WINDOW_WIDTH then
        player_one.score = player_one.score + 1
  
        --reset ball
        ball.x = WINDOW_WIDTH/2-7
        ball.y = WINDOW_HEIGHT/2-7
        ball.dx = math.random(2) == 1 and 300 or -300
        ball.dy = math.random(-50, 50)
      end
  
      -- check if game is finished
      if player_one.score == 10 or player_two.score == 10 then
        gameState = 'finished'
      end
  end

  --starts game
  if gameState == 'stopped' and love.keyboard.isDown('r') then
    gameState = 'running'
  end

  if gameState == 'finished' and love.keyboard.isDown('r') then
    gameState = 'running'

    -- reset ball
    ball.x = WINDOW_WIDTH/2-7
    ball.y = WINDOW_HEIGHT/2-7
    ball.dx = math.random(2) == 1 and 300 or -300
    ball.dy = math.random(-50, 50)

    --reset players
    player_one.y = 10
    player_one.x = 10
    player_one.score = 0
  
    player_two.y = WINDOW_HEIGHT-110
    player_two.x = WINDOW_WIDTH-30
    player_two.score = 0
  end
end


function love.draw()
  if gameState == 'running' then
    -- Print scores
    love.graphics.print(tostring(player_one.score), WINDOW_WIDTH/2 - 80, WINDOW_HEIGHT/20, 0, 4)
    love.graphics.print(tostring(player_two.score), WINDOW_WIDTH/2 + 50, WINDOW_HEIGHT/20, 0, 4)


    -- Update positions
    love.graphics.rectangle('fill', player_one.x, player_one.y, RECTANGLE_WIDTH, RECTANGLE_HEIGHT)
    love.graphics.rectangle('fill', player_two.x, player_two.y, RECTANGLE_WIDTH, RECTANGLE_HEIGHT)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.radius, ball.radius)
  end


  -- print winning screen if game is finished
  if gameState == 'finished' then
    if player_one.score == 10 then
      love.graphics.print("Player 1 wins", WINDOW_WIDTH/2 - 110, WINDOW_HEIGHT/2 - 30, 0, 3)
    elseif player_two.score == 10 then
      love.graphics.print("Player 2 wins", WINDOW_WIDTH/2 - 110, WINDOW_HEIGHT/2 - 30, 0, 3)
    end

    love.graphics.print("Press 'r' to start the game", WINDOW_WIDTH/2 - 150, WINDOW_HEIGHT/7, 0, 2)
  end

  if gameState == 'stopped' then
    love.graphics.print("Press 'r' to start the game", WINDOW_WIDTH/2 - 150, WINDOW_HEIGHT/2 - 30, 0, 2)
  end
end
