class SceneMap

  def initialize
    @character = Character.new(400, 350)
  end

  def update
    @character.update
    @character.move_left if button_down? KbA
    @character.move_right if button_down? KbD
  end

  def draw
    @character.draw
  end
end
