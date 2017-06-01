class OutlineTreeLeaf
  include Inesita::Component

  def render
    # props[:outline_tree]
    li class: 'dd-item', data: { id: props[:outline_leaf]['id'] } do
      div class: 'dd-handle' do
        props[:outline_leaf]['id'].to_s
      end

      if props[:outline_leaf]['children']
        # puts "the child: #{props[:outline_leaf]['children']}"
        component OutlineTree, props: { outline_tree: props[:outline_leaf]['children'] }
      end
    end # li
  end
end
