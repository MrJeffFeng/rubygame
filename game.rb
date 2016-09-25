require 'Gosu'
require_relative 'Sprite'
require_relative 'Background'

include Gosu

class Game < Gosu::Window
  def initialize
    # Game Window
    super(800, 600, false)
    # Backgrounds / Cursor
    @cursor = Gosu::Image.new(self, 'media/cursor.png')
    @menu = Background.new(self, 'media/menu.png')
    @title = Sprite.new(self, 'media/title.png')
    # Character
    @stand_left = Sprite.new(self,'media/Character/stand_left.png')
    @stand_right = Sprite.new(self,'media/Character/stand_right.png')
    @walk_left = Sprite.new(self,'media/Character/walk_left.png')
    @walk_right = Sprite.new(self,'media/Character/walk_right.png')
    @shoot_left = Sprite.new(self,'media/Character/shooting_left.png')
    @shoot_right = Sprite.new(self,'media/Character/shooting_right.png')
    @stand_right.move_to(350, 445)
    @char = @stand_right
    @bullet = Array.new
    @dir = :right
    # Game Detection
    @score = 0
    @shooting = false
    # Game Caption
    self.caption = "Zombie Shooter - Alpha - 0.1.0"
  end

  def update
    # Start Game
    if button_down? KbReturn
      @game_start = true
        @title.hide
    end
    # Updates Sprites
   if @game_start
    @stand_left.move_to(@char.x,@char.y)
    @stand_right.move_to(@char.x,@char.y)
    @walk_right.move_to(@char.x,@char.y)
    @walk_left.move_to(@char.x,@char.y)
    @shoot_left.move_to(@char.x, @char.y)
    @shoot_right.move_to(@char.x, @char.y)

    if @dir == :left then
      @char = @stand_left
    elsif @dir == :right then
      @char = @stand_right
    end

    # Movement
    if button_down? KbD then
      @char = @walk_right
      @dir = :right
      @char.adjust_xpos 4
    elsif button_down? KbA then
      @char = @walk_left
      @dir = :left
      @char.adjust_xpos -4
    elsif button_down? KbSpace # Shooting
      @shooting = true
      if @dir == :left then
        @char = @shoot_left
      elsif @dir == :right then
        @char = @shoot_right
      end
    else
      @shooting = false
    end
   end
   # Bullet
   if @shooting then
     bullet = Sprite.new(self, 'media/bullet.png')
     bullet.move_to(@char.x + 50, @char.y + 30)
     @bullet << bullet
     if @dir == :left
      @bullet.each do |bullet|
      bullet.adjust_xpos -20
      end
     elsif @dir == :right
       @bullet.each do |bullet|
      bullet.adjust_xpos 20
      end
     end
   end
   # Wall
   if @char.x >= 730
     @char.move_to(729, @char.y)
   elsif @char.x <= 0
     @char.move_to(1, @char.y)
   end

   # Close Window
   close if button_down? KbEscape
   #END
  end

  def draw
    @menu.see(0,0,0,1,1.25)
    @title.draw
    @char.draw
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
end

Game.new.show
