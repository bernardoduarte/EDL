
function newObj(self, init)
	init = init or {}
	setmetatable(init, self)
	self.__index = self
	return init
end

Velocity = {
	x = nil,
	y = nil,
}

function Velocity:new(o)
	local obj = newObj(self, o)
	self.x = 0
	self.y = 0
	return obj
end

Player = {
	rot = 0,
	scale = 1,
	vel = Velocity:new{x=0,y=0},
	width = nil,
	height = nil,
}

function Player:new(o)
	local obj = newObj(self, o)
	self.texture = love.graphics.newImage("player_9mmhandgun.png")
	self.width = 60
	self.height = 60
	self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.texture:getDimensions())
	self.delta = 0
	self.fps=1/2
	self.bulletSpeed = 500
	self.bullets = {}
	self.bulletScreenCount = 0
	self.speed = 125
	self.hp = 100
	self.points = 0
	return obj
end

function Player:draw()
	love.graphics.draw(
		self.texture, self.quad,
		self.x, self.y,
		self.rot, self.scale, self.scale,
		self.width/2,self.height/2,
		0,0
	)
	love.graphics.print(self.hp, self.x - 10, self.y + 10)
end

function Player:stop()
	self.vel.x = 0
	self.vel.y = 0
end

function Player:updateVelocity()
	self:stop()

	if love.keyboard.isDown("w", "up") then
		self.vel.y = self.vel.y - self.speed
	end

	if love.keyboard.isDown("a", "left") then
		self.vel.x = self.vel.x - self.speed
	end

	if love.keyboard.isDown("s", "down") then
		self.vel.y = self.vel.y + self.speed
	end

	if love.keyboard.isDown("d", "right") then
		self.vel.x = self.vel.x + self.speed
	end

	if math.abs(self.vel.x) + math.abs(self.vel.y) == self.speed * 2 then
		self.vel.x = self.vel.x * math.cos(45)
		self.vel.y = self.vel.y * math.cos(45)
	end
end

function Player:move(dt)
	local window_w, window_h, _ = love.window.getMode()
	self.x = self.x + self.vel.x*dt
	self.y = self.y + self.vel.y*dt
	if self.x > window_w then
		self.x = window_w
	end
	if self.x < 0 then
		self.x = 0
	end
	if self.y > window_h then
		self.y = window_h
	end
	if self.y < 0 then
		self.y = 0
	end
end

function Player:lookAtMouse()
	local mouseX = love.mouse.getX()
	local mouseY = love.mouse.getY()

	self.rot = math.atan2((mouseY - self.y), (mouseX - self.x))
end

function Player:shoot(dt)
	if self.delta < self.fps then
		self.delta = self.delta + dt
	end

	if love.mouse.isDown(1) and self.delta >= self.fps then
		self.delta = self.delta - self.fps

		local bulletDx = self.bulletSpeed * math.cos(self.rot)
		local bulletDy = self.bulletSpeed * math.sin(self.rot)

		table.insert(self.bullets, {x = self.x, y = self.y, dx = bulletDx, dy = bulletDy})
		self.bulletScreenCount = self.bulletScreenCount + 1
	end
end

function Player:updateBullets(dt)
	local window_w, window_h, _ = love.window.getMode()
	for i, bullet in ipairs(self.bullets) do
		bullet.x = bullet.x + (bullet.dx * dt)
		bullet.y = bullet.y + (bullet.dy * dt)
		local shotHit = false
		for j, enemy in ipairs(enemies) do
			if dist(enemy.x, enemy.y, bullet.x, bullet.y) < 10 then
				enemyShot(enemy, j)
				table.remove(self.bullets, i)
				shotHit = true
			end
		end
		if not shotHit and (bullet.x < 0 or bullet.x > window_w or
			bullet.y < 0 or bullet.y > window_h) then
			table.remove(self.bullets, i)
			self.bulletScreenCount = self.bulletScreenCount + 1
		end
	end
end

function Player:drawBullets()
	for i, v in ipairs(self.bullets) do
		love.graphics.circle("fill", v.x, v.y, 3)
	end
end

function Player:hit()
	if self.hp > 0 then
		self.hp = self.hp - 10
	end
end

function Player:awardEnemyKill()
	self.points = self.points + 10
end

function spawnEnemy(dt)
	spawnDelta = spawnDelta - dt
	if spawnDelta <= 0 then
		spawnDelta = currentSpawnDeltaLimit

		local window_w, window_h, _ = love.window.getMode()
		local rand_x = love.math.random(window_w)
		local rand_y = love.math.random(window_h)
		while distFromPlayer(rand_x, rand_y) < 100 do
			rand_x = love.math.random(window_w)
			rand_y = love.math.random(window_h)
		end
		table.insert(enemies, {x = rand_x, y = rand_y, rot = 0, hp = 100})
		spawnCount = spawnCount + 1

		if currentSpawnDeltaLimit > minSpawnDelta and spawnCount % 2 == 0 then
			currentSpawnDeltaLimit = currentSpawnDeltaLimit - 0.5
		end
	end
end

function drawEnemies()
	for i, v in ipairs(enemies) do
		love.graphics.circle("fill", v.x, v.y, 3)
		love.graphics.draw(enemyTexture, enemyQuad, v.x, v.y, v.rot+math.rad(90), 0.5, 0.5, enemyWidth/2, enemyHeight/2, 0,0)
		love.graphics.print(v.hp, v.x - 10, v.y + 20)
	end
end

function moveEnemies(dt)
	for i, enemy in ipairs(enemies) do
		enemyLookAtPlayer(enemy)
		local enemyDx = enemySpeed * math.cos(enemy.rot)
		local enemyDy = enemySpeed * math.sin(enemy.rot)

		enemy.dx = enemyDx
		enemy.dy = enemyDy

		enemy.x = enemy.x + (enemy.dx * dt)
		enemy.y = enemy.y + (enemy.dy * dt)

		if distFromPlayer(enemy.x, enemy.y) < 10 then
			player:hit()
		end
	end
end

function enemyLookAtPlayer(enemy)
	enemy.rot = math.atan2((player.y - enemy.y), (player.x - enemy.x))
end

function enemyShot(enemy, index)
	enemy.hp = enemy.hp - 25
	if enemy.hp <= 0 then
		table.remove(enemies, index)
		player:awardEnemyKill()
	end
end

function distFromPlayer(x, y)
	return dist(x, y, player.x, player.y)
end

function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
end

function love.load()
	player = Player:new{x=300,y=400}
	enemies = {}
	enemyTexture = love.graphics.newImage("enemy.png")
	enemyWidth, enemyHeight = enemyTexture:getDimensions()
	enemyQuad = love.graphics.newQuad(0, 0, enemyWidth, enemyHeight, enemyTexture:getDimensions())
	enemySpeed = 75
	spawnDelta = 0
	maxSpawnDelta = 2
	currentSpawnDeltaLimit = maxSpawnDelta
	minSpawnDelta = 1
	spawnCount = 0
end


function love.update(dt)
	if player.hp > 0 then
		if player.points > 500 then
			enemySpeed = 100
		end

		player:updateVelocity()

		player:move(dt)

		player:lookAtMouse()
		player:shoot(dt)

		player:updateBullets(dt)

		spawnEnemy(dt)
		moveEnemies(dt)
	end
end


function love.draw()
	if player.hp > 0 then
		fps = string.format("%s %d", "FPS", love.timer.getFPS())
		love.graphics.print(fps, 0, 0)
		points = string.format("%s %d", "Points", player.points)
		love.graphics.print(points, 0, 20)

		player:draw()
		player:drawBullets()
		drawEnemies()
	else
		love.graphics.setNewFont(40)
		gameover = string.format("%s\n %s %d", "Game Over", "Points", player.points)
		love.graphics.printf(gameover, 0, 400, 800, 'center')
	end
end