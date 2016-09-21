require 'Gosu'

# A Background is defined as a special type of Image, that always gets drawn at (0,0)
class Background < Gosu::Image
  def initialize(window, file_location)
    super(window, file_location, true)
    @is_visible = true
  end
  
  def hide()          @is_visible = false     end
  def show()          @is_visible = true      end
      
  def see(x, y, z, scale_x, scale_y)
    self.draw(x,y,z,scale_x,scale_y) if @is_visible
  end

  
  # NEEDS TO BE IMPLEMENTED
  #overrides ## Sprite.draw so that the background fills up the screen
  #def draw
  #end 
end
