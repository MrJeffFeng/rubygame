class Crate

  def initialize
    @crates = Array.new
    @counter = 0
    @falling = false
  end

  def update(window)
    @counter = rand(1..600)
    if @counter == 4 and not @falling
      crate = Sprite.new(window, "media/heart.png")
      crate.move_to(rand(30..720), -10)
      @crates << crate
      @falling = true
    end
    @crates.each do |crate|
      until crate.y > 530
      crate.adjust_ypos 1
      end
      @falling = false
    end
  end

  def draw
    @crates.each do |crate|
      crate.draw
    end
  end
end
