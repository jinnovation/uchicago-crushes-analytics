class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @posts = Post.all
  end

  def analytics
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Year' )
    data_table.new_column('number', 'Sales')
    data_table.new_column('number', 'Expenses')
    # Add Rows and Values
    data_table.add_rows([
                         ['2004', 1000, 400],
                         ['2005', 1170, 460],
                         ['2006', 660, 1120],
                         ['2007', 1030, 540]
                        ])

    option = { width: 800, height: 600, title: 'GLORIOUS EXAMPLE CHART WOW' }
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
  end

end
