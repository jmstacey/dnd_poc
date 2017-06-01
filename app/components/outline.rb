class Outline
  include Inesita::Component

  Element.expose :nestable

  def on_dd_change(node, _element_changed)
    js_obj = node.nestable('serialize')
    new_data = JSON.from_object(js_obj)

    if new_data != store.app.state.visible_data
      store.app.dispatch Actions::UpdateVisibleData.new(new_data)
    end
  end

  def after_render(node, _name, _previous)
    # puts "after_render"
    @_previous_node = node # Helper for before_render
    Element[node.to_n].nestable({ json:     store.app.state.visible_data,
                                  callback: method(:on_dd_change).to_proc }.to_n)
    # Element[node.to_n].nestable({callback: method(:on_dd_change).to_proc }.to_n) # #to_n converts to native javascript. Provided by opal-jquery
  end

  def before_render
    # puts "before_render"
    Element[@_previous_node.to_n].nestable('destroy') unless @_previous_node.nil?
  end

  def render
    # puts "render"
    div class: 'dd', id: 'outline', hook: hook(:after_render)

    # div class: "dd", id: "outline", hook: hook(:on_hook) do
    #   component OutlineTree, props: { outline_tree: store.app.state.visible_data }
    # end

    div # Keep this! Without extra trailing rendering breaks.
  end

end
