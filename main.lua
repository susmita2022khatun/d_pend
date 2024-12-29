push = require 'push'
require 'class'
require 'pendulum'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

RADIUS = 50
CENTER_X = VIRTUAL_WIDTH/2
CENTER_Y = VIRTUAL_HEIGHT/2
INITIAL_ANGLE = math.pi
ANGULAR_VELOCITY = -5
GRAVITY = 60
err = 0.035

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    main_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable =false,
        vsunc = true
    })
    pend = pendulum(INITIAL_ANGLE + err, 4,4,RADIUS, CENTER_X, CENTER_Y)
    pend_2 = pendulum(INITIAL_ANGLE + err, 4,4, RADIUS, pend.x, pend.y)

    pend_3 = pendulum(INITIAL_ANGLE - err +0.02, 4,4,RADIUS, CENTER_X, CENTER_Y)
    pend_4 = pendulum(INITIAL_ANGLE - err + 0.02, 4,4, RADIUS, pend_3.x, pend_3.y)

    pend_2_path = {}
    pend_4_path = {}

    gameState = 'start'
    
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
            pend_2_path = {}
            pend_4_path = {}
        else
            gameState = 'start'
            pend:reset()
            pend_2:reset()
            pend_3:reset()
            pend_4:reset()
        end
    end

end

function love.update(dt)
    if gameState == 'play' then
        pend:update(dt)
        pend_3:update(dt)
        pend_2.centre_x = pend.x
        pend_2.centre_y = pend.y
        pend_2.angle = pend_2.angle + pend.angular_velocity*dt
        pend_2.angular_velocity = pend_2.angular_velocity  + pend.angular_acceleration*dt

        pend_4.centre_x = pend_3.x
        pend_4.centre_y = pend_3.y
        pend_4.angle = pend_4.angle + pend_3.angular_velocity*dt
        pend_4.angular_velocity = pend_4.angular_velocity  + pend_3.angular_acceleration*dt
        pend_2:update(dt)
        pend_4:update(dt)

        table.insert(pend_2_path, {x = pend_2.x, y = pend_2.y})
        table.insert(pend_4_path, {x = pend_4.x, y = pend_4.y})

        if #pend_2_path > 500 then
            table.remove(pend_2_path, 1)
        end
        if #pend_4_path > 500 then
            table.remove(pend_4_path, 1)
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.setFont(main_font)

    if gameState == 'start' then
        love.graphics.print('START STATE',6, 20)
    else
        love.graphics.print('PLAY STATE', 6, 20)
    end

    love.graphics.setColor(0, 1, 0)
    if #pend_2_path > 1 then
        for i = 1, #pend_2_path - 1 do
            love.graphics.line(pend_2_path[i].x, pend_2_path[i].y, pend_2_path[i + 1].x, pend_2_path[i + 1].y)
        end
    end

    love.graphics.setColor(1, 0, 0) 
    if #pend_4_path > 1 then
        for i = 1, #pend_4_path - 1 do
            love.graphics.line(pend_4_path[i].x, pend_4_path[i].y, pend_4_path[i + 1].x, pend_4_path[i + 1].y)
        end
    end

    love.graphics.print('ERROR: '.. tostring(err), 3,40)

    pend:render()
    pend_2:render()
    pend_3:render()
    pend_4:render()
    push:apply('end')
end
