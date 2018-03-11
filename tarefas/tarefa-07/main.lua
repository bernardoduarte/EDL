
function newObj(self, init)
	init = init or {}
	setmetatable(init, self)
	self.__index = self
	return init
end

-- Tarefa-06
-- Valor: Velocity
-- Tipo: Registro
-- Observações: Implementação da estrutura de um tipo definido pelo programador.
Velocity = {
	x = nil,
	y = nil,
}
-- Tarefa-05
-- Nome: Operador "{}"
-- Propriedade: Semântica
-- Binding time: Compile
-- Explicação: O construtor {} pode inicializar tanto arrays quanto tables.
-- Em tempo de compilação será determinado que Velocity será um table e não um array.

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
-- Tarefa-05
-- Nome: Variáveis "rot", "scale"
-- Propriedade: Valor
-- Binding time: Compile
-- Explicação: Os valores dessas variáveis são atribuidos em tempo de compilação.
-- Apesar da linguagem Lua ser uma linguagem interpretada, ela possui um compilador.
-- Diferentemente de linguagens como C, o compilador de Lua está contido em seu runtime.

function Player:new(o)
	local obj = newObj(self, o)
	self.texture = love.graphics.newImage("player_9mmhandgun.png")
	self.width = 60
	self.height = 60
	self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.texture:getDimensions())
	self.delta = 0
	self.fps=1/2
	self.bulletSpeed = 500
-- Tarefa-06
-- Valor: {} da variável bullets
-- Tipo: Array
-- Observação: Para garantir o comportamento de um Array foram utilizadas as funções table.insert, table.remove e ipairs.
	self.bullets = {}
-- Tarefa-07
-- Coleção dinâmica de objetos: Variável "bullets"
-- A variável bullets é um array que contém todos os tiros que forem efetuados pelo jogador durante o jogo.
-- Escopo: Não local, pois configura uma variável de instância.
-- Tempo de vida: Do instanciamento do objeto à sua destruição.
-- Alocação: Ao instanciar um novo objeto Player
-- No jogo, a alocação do único player, a instância do objeto que contém a coleção, é feita no carregamento do jogo.
-- Desalocação: Ao destruir um objeto Player.
-- No jogo, a desalocação do player que contém essa coleção será feita no encerramento do jogo.
	self.bulletScreenCount = 0
	self.speed = 125
	self.hp = 100
	self.points = 0
-- Tarefa-05
-- Nome: Palavra "self"
-- Propriedade: Endereço
-- Binding time: Run
-- Eplicação: O endereço de self está associado ao elemento que chama o método.
-- Dessa forma, somente em runtime quando o método for chamado que o endereço de self será amarrado.

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
-- Tarefa-07
-- Método PLayer:shoot
-- Responsável pela criação dos objetos da coleção "bullets" toda vez que o botão do mouse estiver pressionado e pelo menos meio segundo tiver passado do último tiro.
-- A inserção dos objetos é feita pela função table.insert().

function Player:updateBullets(dt)
	local window_w, window_h, _ = love.window.getMode()
-- Tarefa-05
-- Nomes: Variáveis "window_w" e "window_h"
-- Propriedade: Endereço
-- Binding time: Run
-- Explicação: O endereço de variáveis locais só é alocado em tempo de execução.

	for i, bullet in ipairs(self.bullets) do
		bullet.x = bullet.x + (bullet.dx * dt)
		bullet.y = bullet.y + (bullet.dy * dt)
		local shotHit = false
-- Tarefa-05
-- Nome: Valor false
-- Propriedade: Tipo
-- Binding time: Design
-- Explicação: Em Lua não existem definições de tipos, entretanto cada valor carrega o seu próprio tipo.
-- Neste caso o tipo do valor false foi definido como boolean no design da linguagem.

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
-- Tarefa-07
-- Método Player:updateBullets
-- Responsável por verificar colisões entre objetos das listas "bullets" e "enemies" e remover os tiros quando necessário.
-- A validação da colisão é feita verificando se o tiro e o inimigo se encontram dentro de um raio de 10 pixels um do outro.
-- A validação é feita entre todos os objetos de ambas as listas.
-- Caso ocorra uma colisão, o tiro é removido e o inimigo recebe o dano do tiro.
-- Caso não ocorra nenhuma colisão, será verificado se o tiro ainda se encontra na tela do jogo.
-- Se a verificação do tiro confirmar que ele está fora do limite da tela, o tiro será removido.
-- A remoção dos objetos é feita pela função table.remove().

function Player:drawBullets()
	for i, v in ipairs(self.bullets) do
-- Tarefa-06
-- Valor: "fill"
-- Tipo: Enumeração
-- Observações: Valor da enumeração DrawMode(https://love2d.org/wiki/DrawMode) para determinar a forma de renderização.
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
-- Tarefa-06
-- Valor: {x = rand_x, y = rand_y, rot = 0, hp = 100}
-- Tipo: Dicionário
-- Observações: O comportamento desse valor se configura como um Dicionário pois permite acesso, remoção, inclusão e alteração de um campo.
-- Este valor está sendo inicializado com a inclusão de 4 campos com seus respectivos valores.
		table.insert(enemies, {x = rand_x, y = rand_y, rot = 0, hp = 100})
		spawnCount = spawnCount + 1

		if currentSpawnDeltaLimit > minSpawnDelta and spawnCount % 2 == 0 then
			currentSpawnDeltaLimit = currentSpawnDeltaLimit - 0.5
		end
	end
end
-- Tarefa-07
-- Função spawnEnemy
-- Responsável pela criação dos objetos da coleção "enemies" a cada ciclo de tempo.
-- O tamanho do ciclo começa em 2 segundos e depois de um tempo atinge o tamanho de 1 segundo.
-- A inserção dos objetos é feita pela função table.insert().

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
-- Tarefa-07
-- Função enemyShot
-- Responsável pela remoção dos objetos da coleção "enemies" caso o objeto tenha atingido 0 hitpoints.
-- A remoção dos objetos é feita pela função table.remove().


function distFromPlayer(x, y)
	return dist(x, y, player.x, player.y)
end

function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
-- Tarefa-05
-- Nome: Funções "sqrt" e "pow"
-- Propriedade: Implementação
-- Binding time: Design
-- Explicação: As funções sqrt e pow são funções da biblioteca padrão de matemática(math) da linguagem Lua.
-- Portanto, suas implementações foram feitas durante o design da linguagem.
end

function love.load()
	player = Player:new{x=300,y=400}
	enemies = {}
-- Tarefa-07
-- Coleção dinâmica de objetos: Variável "enemies"
-- A variável enemies é um array que contém todos os inimigos que serão farão parte do jogo.
-- Escopo: Global
-- Tempo de vida: Do início ao fim do jogo
-- Alocação: No início do jogo, quando o Löve executar a função love.load()
-- Desalocação: Quando o jogo for encerrado

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