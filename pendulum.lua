pendulum = class()

function pendulum:init(initial_angle, width, height, radius, centre_x, centre_y)
    self.width = width
    self.height = height
    self.radius = radius
    self.centre_x = centre_x
    self.centre_y = centre_y

    self.angle = initial_angle 
    self.angular_velocity = 0 
    self.angular_acceleration = 0 

    self.x = self.centre_x + self.radius * math.sin(self.angle)
    self.y = self.centre_y + self.radius * math.cos(self.angle)

    self.gravity = GRAVITY 
end

function pendulum:reset()
    self.angle = 0
    self.angular_velocity = 0
    self.angular_acceleration = 0
end

function pendulum:update(dt)
    self.angular_acceleration = (-self.gravity / self.radius) * math.sin(self.angle)
    self.angular_velocity = self.angular_velocity + self.angular_acceleration * dt
    self.angle = self.angle + self.angular_velocity * dt

    self.x = self.centre_x + self.radius * math.sin(self.angle)
    self.y = self.centre_y + self.radius * math.cos(self.angle)
end

function pendulum:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.line(self.centre_x, self.centre_y, self.x, self.y)

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.circle("fill", self.x, self.y, self.width)

    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.circle("fill", self.centre_x, self.centre_y, self.width / 2)
end
