class Outline
  include Inesita::Component
  include Draggable

  def initialize
    init_draggable
  end

  # def on_outline_change(node, _element_changed)
  #   js_obj = node.nestable('serialize')
  #   new_data = JSON.from_object(js_obj)
  #
  #   if new_data != store.app.state.visible_data
  #     store.app.dispatch Actions::UpdateVisibleData.new(new_data)
  #   end
  # end

  def render
    puts "#{@x}, #{@y}"
    div class: 'dd', id: 'outline' do
      render_parent store.app.state.visible_data
    end
    div class: 'dd-placeholder' if @dragging
  end

  def render_parent(parent)
    ol class: 'dd-list' do
      parent.each { |child| render_child(child) }
    end
  end
  
  def render_child(child)
    li class: 'dd-item', data: { id: child['id'] } do
      div class: 'dd-handle', onmousedown: method(:start_drag) do
        child['id'].to_s
      end
      render_parent(child['children']) if child['children']
    end # li
  end
end
