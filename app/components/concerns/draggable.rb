module Draggable
  def init_draggable
    listen_for_mouse_up
    listen_for_mouse_move
  end

  def listen_for_mouse_up
    $document.on('mouseup') do |e|
      puts 'mouseup'
      e.prevent
      @dragging = false
      # TODO: dispatch new outline state to store
      render!
    end
  end

  def listen_for_mouse_move
    $document.on('mousemove') do |e|
      puts 'mousemove'
      e.prevent
      if @dragging
        puts 'am dragging'
        @x = e.page.x - @offset_x
        @y = e.page.y - @offset_y
        render!
      end
    end
  end

  def start_drag(e)
    puts 'start_drag'
    e.prevent
    @target          = e.target
    @drag_item       = Element[@target.to_n].closest('li')
    @left            = e.page.x
    @top             = e.page.y
    @mouse_offset_x  = e.page.x - @drag_item.offset.left
    @mouse_offset_y  = e.page.y - @drag_item.offset.top
    @mouse_start_x   = @mouse_last_x = e.page.x
    @mouse_start_y   = @mouse_last_y = e.page.y

    puts "beautiful:"
    puts @offset_x, @offset_y

    # Set height of placeholder equal to the item being dragged
    Element['.dd-placeholder'].css('height', @drag_item.height())

    puts "#{@offset_x}, #{@offset_y}"
    @dragging = true
    render!
  end
end
