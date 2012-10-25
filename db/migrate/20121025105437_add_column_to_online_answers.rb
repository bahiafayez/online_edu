class AddColumnToOnlineAnswers < ActiveRecord::Migration
  def change
    add_column :online_answers, :correct, :boolean
  end
end
