require 'Gosu'
require 'Sprite'
require 'Background'
require 'Character'
require 'Zombie'
require 'SceneMap'

include Gosu

class Game < Gosu::Window
  def initialize
    # Game Window
    super(800, 600, false)
    # Backgrounds / Cursor
    @cursor = Gosu::Image.new(self, 'media/cursor.png')
    @menu = Background.new(self, 'media\\menu.png')
    @floor = Background.new(self,'media\\floor.png')
    # Text
    @title = Sprite.new(self, 'media\\title.png')
    # Character
    #@shooter = Sprite.new(self,'media\\shooter.png')
    # Game Detection
    $scene = 'menu'
    $game_start = false
    $score = 0
    $window = self
    @char = SceneMap.new
    # Game Caption
    self.caption = "Zombie Shooter - Alpha - 0.0.1"
  end

  def update
    if $game_start == true
      movement
    end
    @char.update
  end

  def draw
    @menu.see(0,0,0,1,1.25)
    @title.draw
    @char.draw
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
end

Game.new.show
