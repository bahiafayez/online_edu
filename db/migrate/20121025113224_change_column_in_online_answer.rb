class ChangeColumnInOnlineAnswer < ActiveRecord::Migration
  def up
    change_column :online_answers, :answer, :string, :default => ""
  end

  def down
    change_column :online_answers, :answer, :string
  end
end
