class ChangeExplanationTypeInOnlineAnswer < ActiveRecord::Migration
  def up
    change_column :online_answers, :explanation, :text, :default => ""
  end

  def down
    change_column :online_answers, :explanation, :text
  end
end
