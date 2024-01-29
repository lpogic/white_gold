$window_style = [:titlebar, :close]
require 'white_gold'


title! "Snake"
SQUARE_SIZE = 25

class Snake
  def initialize head = [5, 10], tail = [:d, :d]
    @head = head
    @tail = tail
    @alive = true
  end

  ALLOWED_DIRECTIONS = {
    w: [:a, :d],
    s: [:a, :d],
    a: [:w, :s],
    d: [:w, :s],
  }

  HEAD_STEP = {
    w: [0, -1],
    s: [0, 1],
    a: [-1, 0],
    d: [1, 0],
  }

  def step dir, grid, food
    return if !@alive
    dir = ALLOWED_DIRECTIONS[dir].include?(@tail.last) ? dir : @tail.last
    @tail.push dir
    @head = @head.zip(HEAD_STEP[dir], grid).map{|a| cycle_step *a }
    @tail.shift if @head != food
    @alive = alive_check grid
  end

  def alive_check grid
    @tail.size == coordinates(grid).uniq.size - 1
  end

  def coordinates grid
    @tail.reverse.reduce([@head]) do |a, e| 
      a << a.last.zip(HEAD_STEP[e].map{ -_1 }, grid).map{|a| cycle_step *a }
    end
  end

  def cycle_step base, move, cycle
    bm = base + move
    bm >= 0 ? bm <= cycle ? bm : 0 : cycle
  end

  def alive?
    @alive
  end
end

class GamePage < Page
  def generate_food grid, snake_coords
    loop do
      food = grid.map{ rand _1 }
      return food if !snake_coords.include? food
    end
  end

  ARROW_KEY_MAP = {
    up: :w,
    down: :s,
    left: :a,
    right: :d
  }

  def build
    @last_dir_key = :d

    @static_canvas = canvas!
    @dynamic_canvas = canvas!

    @grid = window.size.map{ (_1 / SQUARE_SIZE).floor - 1 }
    @snake = Snake.new
    @food = generate_food @grid, @snake.coordinates(@grid)

    @static_canvas.draw! do
      fill! :green
      (0..@grid[0]).each do |x|
        (0..@grid[1]).each do |y|
          rectangle! position: [x * SQUARE_SIZE, y * SQUARE_SIZE], size: SQUARE_SIZE - 1, color: :gray
        end
      end
    end

    @game_over = label! position: :center, text_size: 40, text: "GAME OVER", alignment: :center, visible: false

    @timer = timer 30, repeat: true do
      @snake.step @last_dir_key, @grid, @food
      snake_crd = @snake.coordinates @grid
      @food = generate_food @grid, snake_crd if snake_crd.include? @food
      @dynamic_canvas.draw! do
        fill! :transparent
        snake_crd.each do |crd|
          color = @snake.alive? ? :blue : :red
          rectangle! position: [crd.x * SQUARE_SIZE, crd.y * SQUARE_SIZE], size: SQUARE_SIZE - 1, color: color
        end
        rectangle! position: [@food.x * SQUARE_SIZE, @food.y * SQUARE_SIZE], size: SQUARE_SIZE - 1, color: :green
      end
      if !@snake.alive?
        @game_over.text! "GAME OVER\nscore: #{snake_crd.size - 3}"
        @game_over.visible! true
      end
    end

    @kc = keyboard_control! do
      on_key! :w, :s, :a, :d do |key|
        @last_dir_key = key
      end
      on_key! :up, :down, :left, :right do |key|
        @last_dir_key = ARROW_KEY_MAP[key]
        @timer.finish
      end
      on_key! :escape do
        window.close!
      end
      on_key! :space do
        @game_over.visible! false
        @snake = Snake.new
        @food = generate_food @grid, @snake.coordinates(@grid)  
      end
    end

    @dynamic_canvas.on_focus! do
      @kc.focus!
    end
    on_focus! do
      @kc.focus!
    end
  end
end

def intro
  label! position: :center, text_size: 40, alignment: :center, text: <<-TEXT
    Snake Game
    arrows - control the snake
    escape - exit
    space - restart the game
    Press SPACE to start
  TEXT

  keyboard_control! do
    on_key! :space do
      go GamePage
    end
  end
end

go :intro