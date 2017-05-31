class OutlineTree
  include Inesita::Component

  def render
    puts props[:outline_tree]
    ol class: "dd-list" do
      props[:outline_tree].each do |leaf|
        # puts leaf.class
        li class: "dd-item", data: { id: leaf['id'] } do
          div class: "dd-handle" do
            "#{leaf['id']}"
          end

          if leaf["children"]
            # puts "the child: #{leaf['children']}"
            component OutlineTree, props: { outline_tree: leaf["children"] }
          end
        end # li
      end
    end
  end

end
