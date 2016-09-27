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
    @dir = :right
    # Bullets / Zombie
    @bullet = Array.new
    @zombie = Array.new
    # Game Detection
    @score = 0
    @ammo = 20
    @counter = 0
    @lives = 3
    @shooting = false
    # Font
    @text = Font.new(self, default_font_name, 20)
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
      @counter = rand(1..300)
      p "#{@counter}"
      # Switches sprite base on side
      if @dir == :left then
        @char = @stand_left
      elsif @dir == :right then
        @char = @stand_right
      end
      # Movement
      if button_down? KbD and @shooting == false
        @char = @walk_right
        @dir = :right
        @char.adjust_xpos 4
      elsif button_down? KbA and @shooting == false
        @char = @walk_left
        @dir = :left
        @char.adjust_xpos -4
      elsif button_down? KbSpace and @ammo > 0 and @shooting == false# Shooting
        @shooting = true
        @ammo -= 1
        bullet = Sprite.new(self, 'media/bullet.png')
        bullet.move_to(@char.x + 50, @char.y + 30)
        @bullet << bullet
        if @dir == :left then
          @char = @shoot_left
        elsif @dir == :right then
          @char = @shoot_right
        end
      end
      # Zombie
      if @counter == 1
        zombie_right = Sprite.new(self, "media/Zombie/stand_right.png")
        zombie_right.move_to(0, 430)
      elsif @counter == 100
        zombie_left = Sprite.new(self, "media/Zombie/walk_left.png")
        zombie_left.move_to(800, 430)
      end
      @zombie << zombie_right << zombie_left
      # Zombie Movement
      @zombie.each do |zombie_right|
        zombie_right.adjust_xpos 0.1
      end
      @zombie.each do |zombie_left|
        zombie_left.adjust_xpos -0.1
      end
    end # End @game_start
   # Bullet
   if @shooting and @ammo >= 0 then
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
   # Bullet Detection
   @bullet.each do |bullet|
     @zombie.each do |zombie|
       if bullet.touching? zombie
         @zombie.delete(zombie)
         @bullet.delete(bullet)
         @shooting = false
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
  end # End update

  def draw
    @menu.see(0,0,0,1,1.25)
    @title.draw
    # Bullet Draw
    @bullet.each do |bullet|
    bullet.draw
      if bullet.x > 750
       @bullet.delete(bullet)
       @shooting = false
      elsif bullet.x < 10
       @bullet.delete(bullet)
       @shooting = false
      end
    end
    # Zombie Draw
    @zombie.each do |zombie|
      zombie.draw
      if zombie.touching?(@char)
        @lives -= 1
      end
    end
    #@zombie.each do |zombie_left|
    #  zombie_left.draw
    #end
    @char.draw
    @text.draw("Ammo: #{@ammo}", 1, 0, 0)
    @text.draw("Lives: #{@lives}", 700, 0, 0)
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
end

Game.new.show
