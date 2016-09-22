class Character
  
  def initialize(x, y)
    @real_x = x
    @real_y = y
    @stand_right = Image.load_tiles($window, "media/Character/character1.png", 96, 120, false)
    @stand_left = Image.load_tiles($window, "media/Character/character1_left.png", 96, 120, false)
    @walk_right = Image.load_tiles($window, "media/Character/character3.png", 106, 116, false)
    @walk_left = Image.load_tiles($window, "media/Character/character3_left.png", 106, 116, false)
    @shoot_right = Image.load_tiles($window, "media/Character/character_shooting3.png", 105, 117, false)
    @shoot_left = Image.load_tiles($window, "media/Character/character_shooting3_left.png", 105, 117, false)
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
    if button_down? KbSpace and @dir == :right
      @sprite = @shooting_right
    end
    if button_down? KbSpace and @dir == :left
      @sprite = @shooting_left
    end
end
  def hide()  @is_visible = false     end
  def show()  @is_visible = true      end
    
def move_left
    @dir = :left
    @move_x = -5
    @moving = true
    @sprite = @walk_left
end

  def move_right
    @dir = :right
    @move_x = 5
    @moving = true
    @sprite = @walk_right
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