class Zombie

  def initialize(x, y)
    @real_x = x
    @real_y = y
    @stand_right = Image.load_tiles($window, "media/Zombie/stand_left.png", w, h, false)
    @stand_left = Image.load_tiles($window, "media/Zombie/stand_left.png", w, h, false)
    @walk_right = Image.load_tiles($window, "media/Zombie/walk_right.png", w, h, false)
    @walk_left = Image.load_tiles($window, "media/Zombie/walk_left.png", w, h, false)
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

  end

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
