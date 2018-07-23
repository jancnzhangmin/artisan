class AddSkillscoreToUserpayorder < ActiveRecord::Migration[5.1]
  def change
    add_column :userpayorders, :skillscore, :float
    add_column :userpayorders, :conceptscore, :float
    add_column :userpayorders, :attitudescore, :float
  end
end
