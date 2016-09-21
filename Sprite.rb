require 'Gosu'

NO_TILING = 0

# A Sprite is defined as a special type of Image.
class Sprite < Gosu::Image
  attr_accessor :x, :y  # Makes the x and y variables available
      # to other objects.

  # Initializes a Sprite with a window and file location of the Image.
  def initialize(window, file_location)
    super(window, file_location, true)
    @x = 0
    @y = 0
    @is_visible = true
    @rotation = 0
    @window = window
  end
  
  # Moves the Sprite to the specified x,y position.
  # In Gosu, the upper left corner is (0,0).  The bottom right corner is (800,600), usually.
  def move_to(x, y)
    @x = x
    @y = y
  end
  
  def rotate(amount)        @rotation += amount     end  # in degrees
  def adjust_xpos(amount)     @x += amount        end
  def adjust_ypos(amount)     @y += amount          end
  def hide()          @is_visible = false     end
  def show()          @is_visible = true      end
  def visible?()        return @is_visible      end
  
  
  def draw()
    # draw_rot() uses the CENTER of the image, while our x and y are the upper left corner...
    draw_rot(@x + width / 2, @y + height / 2, NO_TILING, @rotation) if @is_visible  
  end
  
  # So-so touching?() method, good enough for now.
  def touching?(other_sprite)
    is_touching = false
    self_lower_right_x = @x + self.width
    self_lower_right_y = @y + self.height
    other_lower_right_x = other_sprite.x + other_sprite.width
    other_lower_right_y = other_sprite.y + other_sprite.height
    
    if (other_sprite.visible? and self.visible?)
      if (other_sprite.x.between?(@x, self_lower_right_x) and other_sprite.y.between?(@y, self_lower_right_y)) \
              or (self.x.between?(other_sprite.x, other_lower_right_x) and self.y.between?(other_sprite.y, other_lower_right_y))        
        is_touching = true
      end
    end
    return is_touching
  end

  def clicked?
    is_clicked = false
    self_lower_right_x = @x + self.width
    self_lower_right_y = @y + self.height
    
    if self.visible? and @window.button_down? MsLeft
        if (@window.mouse_x.between?(x, self_lower_right_x) and @window.mouse_y.between?(y, self_lower_right_y))        
          is_clicked = true
        end
    end
    return is_clicked
  end


end