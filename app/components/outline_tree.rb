class OutlineTree
  include Inesita::Component

  def render
    puts props[:outline_tree]
    ol class: 'dd-list' do
      props[:outline_tree].each do |leaf|
        component OutlineTreeLeaf, props: { outline_leaf: leaf }
      end
    end
  end
end
