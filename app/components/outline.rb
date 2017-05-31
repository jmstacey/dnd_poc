class Outline
  include Inesita::Component

  Element.expose :nestable

  def on_dd_change(container, element_changed)
    js_obj = container.nestable('serialize')
    new_data = JSON.from_object(js_obj)

    if new_data != store.app.state.visible_data
      store.app.dispatch Actions::UpdateVisibleData.new(new_data)
    end

    # puts "App Store: #{store.app.state.visible_data}"
  end

  def will_unmount
    Element['#outline'].nestable('destroy') # Deactivate plugin invalidating this outline as it should be deployed clean from the store now for one-way binding
  end

  def on_mounted
    # Element['#outline'].nestable({ 'callback': method(:on_dd_change).to_proc }.to_n) # #to_n converts to native javascript. Provided by opal-jquery
    Element['#outline'].nestable({ 'json': store.app.state.visible_data, 'callback': method(:on_dd_change).to_proc }.to_n) # #to_n converts to native javascript. Provided by opal-jquery
  end

  def render
    div class: "dd", id: "outline", hook: unhook(:will_unmount)

    div # Without this, things break badly for some reason.

    # div class: "dd", id: "outline", hook: unhook(:will_unmount) do
    #   component OutlineTree, props: {outline_tree: store.app.state.visible_data}
    # end
  end

end
