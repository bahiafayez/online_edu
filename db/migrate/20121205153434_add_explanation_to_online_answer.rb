class AddExplanationToOnlineAnswer < ActiveRecord::Migration
  def change
    add_column :online_answers, :explanation, :text
  end
end
