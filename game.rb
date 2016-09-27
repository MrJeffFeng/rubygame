require 'Gosu'
require 'Sprite'
require 'Background'
require 'Zombie'

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
    #Zombie
    @zombie = Array.new
    @zombie_dir = :right
    @left_right = rand(1..2)
    # Game Detection
    @score = 0
    @ammo = 12
    @shooting = false
    @counter = 0
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
     if @left_right == 1
       @zombie_dir = :right
     else
       @zombie_dir = :left
    end
    @stand_left.move_to(@char.x,@char.y)
    @stand_right.move_to(@char.x,@char.y)
    @walk_right.move_to(@char.x,@char.y)
    @walk_left.move_to(@char.x,@char.y)
    @shoot_left.move_to(@char.x, @char.y)
    @shoot_right.move_to(@char.x, @char.y)
    @counter = rand(1..200)
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
      @ammo -= 1
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
   if @shooting and @ammo >= 0 then
     bullet = Sprite.new(self, 'media/bullet.png')
     bullet.move_to(@char.x + 50, @char.y + 30)
     @bullet << bullet
   end
   if @dir == :left
    @bullet.each do |bullet|
    bullet.adjust_xpos -20
    end
   elsif @dir == :right
     @bullet.each do |bullet|
    bullet.adjust_xpos 20
    end
   end
   p "#{@ammo}"
   # Zombie
    if @counter == rand(1..15) then
      zombie = Sprite.new(self, 'media/Zombie/walk_right.png')
      @zombie << zombie
       if @zombie_dir == :right    
         zombie.move_to(0, 445)
         @zombie.each do |zombie|
            zombie.adjust_xpos 20
         end
       elsif @zombie_dir == :left
         zombie = Sprite.new(self, 'media/Zombie/walk_left.png')
         zombie.move_to(800, 445)
         @zombie.each do |zombie|
           zombie.adjust_xpos -20
         end
       end
    end
   # Wall
   if @char.x >= 712
     @char.move_to(711, @char.y)
   elsif @char.x <= -10
     @char.move_to(-9, @char.y)
   end

   # Close Window
   close if button_down? KbEscape
   #END
  end

  def draw
    @menu.see(0,0,0,1,1.25)
    @title.draw
    @zombie.each do |zombie|
      zombie.draw
    end
    @bullet.each do |bullet|
      bullet.draw
    end
    @char.draw
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
end

Game.new.show