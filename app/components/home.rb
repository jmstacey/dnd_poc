class Home
  include Inesita::Component

  def render
    div.jumbotron class: 'text-center' do
      img src: '/static/inesita-rb.png'
      h1 do
        text "Hello I'm Inesita"
      end
      component Counter, props: {header: 'This is a sample counter', sub_header: 'This is a simple undo/redo version demo'}
    end
  end
end
