class Character
  
  def initialize(x, y)
    @real_x = x
    @real_y = y
    @stand_right = Image.load_tiles(window, "media/Character/stand_right.png", w, h, false)
    @stand_left = 
    @sprite = @stand_right
    @dir = :right
    @x = @real_x + (@sprite[0].width / 2)
    @y = @real_y + @sprite[0].height
    @move_x = 0
    @moving = false
    @is_visible = true
  end
  
  def update
    @real_x = @x - (@sprite[0].width / 2)
    @real_y = @y - @sprite[0].height
    
    if @moving then
      if @move_x > 0 then
        @move_x -= 1
        @x += 4
      elsif @move_x < 0 then
        @move_x += 1
        @x -= 4
      elsif @move_x == 0 then
        @moving = false
      end
    else   
      if @dir == :left then
        @sprite = @stand_left
      elsif @dir == :right then
        @sprite = @stand_right
      end
    end
  end
  
  def hide()  @is_visible = false     end
  def show()  @is_visible = true      end
    
def move_left
    @dir = :left
    @move_x = -5
    @sprite = @walk_left
    @moving = true
  end

  def move_right
    @dir = :right
    @move_x = 5
    @sprite = @walk_right
    @moving = true
  end

  def get_x
    return @x
  end

  def get_y
    return @y
  end

  def dir
    return @dir
  end
  
  def draw(z=5) # Creates smooth costume switch
   frame = milliseconds / 150 % @sprite.size
   @sprite[frame].draw(@real_x, @real_y, z) if @is_visible
  end
  
end