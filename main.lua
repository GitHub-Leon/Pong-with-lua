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
end


function love.update(dt)
  dt = love.timer.getDelta()

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
  
    if collision then
      ball.dx = -ball.dx * 1.1
      ball.x = player_two.x - 15
  
      if ball.dy < 0 then
        ball.dy = -math.random(10,150)
      else
        ball.dy = math.random(10, 150)
      end
    end
end


function love.draw()
    -- Print scores
    love.graphics.print(tostring(player_one.score), WINDOW_WIDTH/2 - 80, WINDOW_HEIGHT/20, 0, 4)
    love.graphics.print(tostring(player_two.score), WINDOW_WIDTH/2 + 50, WINDOW_HEIGHT/20, 0, 4)


    -- Update positions
    love.graphics.rectangle('fill', player_one.x, player_one.y, RECTANGLE_WIDTH, RECTANGLE_HEIGHT)
    love.graphics.rectangle('fill', player_two.x, player_two.y, RECTANGLE_WIDTH, RECTANGLE_HEIGHT)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.radius, ball.radius)
end
