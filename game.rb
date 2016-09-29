require 'Gosu'
require_relative 'Sprite'
require_relative 'Background'
#require_relative 'Crate'

include Gosu

class Game < Gosu::Window
  def initialize
    # Game Window
    super(1280, 600, false)
    # Backgrounds / Cursor
    @cursor = Gosu::Image.new(self, 'media/cursor.png')
    @menu = Background.new(self, 'media/menu.png')
    @title = Sprite.new(self, 'media/title.png')
    @title.move_to(270,0)
    # Character
    @stand_left = Sprite.new(self,'media/Character/stand_left.png')
    @stand_right = Sprite.new(self,'media/Character/stand_right.png')
    @walk_left = Sprite.new(self,'media/Character/walk_left.png')
    @walk_right = Sprite.new(self,'media/Character/walk_right.png')
    @shoot_left = Sprite.new(self,'media/Character/shooting_left.png')
    @shoot_right = Sprite.new(self,'media/Character/shooting_right.png')
    @stand_right.move_to(640, 445)
    @char = @stand_right
    @dir = :right
    # Bullets / Zombie
    @bullet = Array.new
    @zombie = Array.new
    @crates = Array.new
    # Game Detection
    @score = 0
    @ammo = 12
    @counter = 0
    @lives = 90
    @cooldown = 0
    @shooting = false
    @falling = false
    # Font
    @text = Font.new(self, default_font_name, 20)
    # Game Caption
    self.caption = "Zombie Shooter - Alpha - 0.2.3"
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
      @counter = rand(1..250)
      # Switches sprite base on side
      if @dir == :left then
        @char = @stand_left
      elsif @dir == :right then
        @char = @stand_right
      end
      # Movement
      if button_down? KbSpace and @ammo > 0 and @shooting == false # Shooting
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
      elsif (button_down? KbD or button_down? KbRight) and @shooting == false
        @char = @walk_right
        @dir = :right
        @char.adjust_xpos 6
      elsif (button_down? KbA or button_down? KbLeft) and @shooting == false
        @char = @walk_left
        @dir = :left
        @char.adjust_xpos(-6)
      end
      # Zombie Spawning
      if @counter == 1
        zombie = Zombie.new(self, "media/Zombie/stand_right.png", :left)
        zombie.move_to(-50, 440)
        @zombie << zombie
      elsif @counter == 100
        zombie = Zombie.new(self, "media/Zombie/stand_left.png", :right)
        zombie.move_to(1280, 440)
        @zombie << zombie
      end
      # Zombie Movement
      @zombie.each do |zombie|
        if zombie.touching?(@char)
          zombie.adjust_xpos 0
          @lives -= 1
        elsif zombie.dir == :left
          zombie.adjust_xpos 5
        elsif zombie.dir == :right
          zombie.adjust_xpos(-5)
        end
      end
      # Crate
      if @counter == 48 and not @falling
        crate = Crate.new(self, "media/heart.png", :lives)
        crate.move_to(rand(30..1250), -10)
        @crates << crate
        @falling = true
      elsif @counter == 90 or @counter == 45 and not @falling #having to counters makes frequency increase
        crate = Crate.new(self, "media/ammo.png", :ammo)
        crate.move_to(rand(30..1250), -10)
        @crates << crate
        @falling = true
      end
      # Crate Movement
      @crates.each do |crate|
        if @char.touching? crate and crate.item == :lives
          @lives += 30 if @lives < 90
          if @lives > 90
            @lives = 90
          end
          @crates.delete(crate)
          @falling = false
          @cooldown = 0
        elsif @char.touching? crate and crate.item == :ammo
          @ammo += 5 if @ammo < 50
          if @ammo > 50 #makes ammo equal to 50 if it goes above it
            @ammo = 50
          end
          @crates.delete(crate)
          @falling = false
          @cooldown = 0
        elsif crate.y > 500
          crate.adjust_ypos 0
          @cooldown += 1
            if crate.item == :lives and @cooldown > 500
              @crates.delete(crate)
              @cooldown = 0
              @falling = false
            elsif crate.item == :ammo and @cooldown > 200
              @crates.delete(crate)
              @cooldown = 0
              @falling = false
            end
        elsif crate.y <= 500
          crate.adjust_ypos 2
        end
      end
    end # End @game_start
   # Bullet
   if @shooting and @ammo >= 0 then
     if @dir == :left
      @bullet.each do |bullet|
        bullet.adjust_xpos(-20)
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
         @score += 1
         @zombie.delete(zombie)
         @bullet.delete(bullet)
         @shooting = false
       end
     end
   end
   # Wall
   if @char.x >= 1192
     @char.move_to(1191, @char.y)
   elsif @char.x <= -10
     @char.move_to(-9, @char.y)
   end
   # Close Window
   close if button_down? KbEscape
  end # End update

  def draw
    @menu.see(0,0,0,1.6,1.25)
    @title.draw
    # Bullet Draw
    @bullet.each do |bullet|
    bullet.draw
      if bullet.x > 1280
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
    end
    # Crate Draw
    @crates.each do |crate|
      crate.draw
    end
    @char.draw
    # Text Draw
    @text.draw("Ammo: #{@ammo}", 1, 0, 0)
    @text.draw("Lives: #{@lives}", 1180, 0, 0)
    @text.draw("Score: #{@score}", 640, 0, 0)
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
end

class Crate < Sprite
  attr_accessor :item

  def initialize(window, image, item)
    @item = item
  super window, image
  end
end

class Zombie < Sprite
  attr_accessor :dir

  def initialize(window, image, dir)
    @dir = dir
    super window, image
  end
end

Game.new.show
