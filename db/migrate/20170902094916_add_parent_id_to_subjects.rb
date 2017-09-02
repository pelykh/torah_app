class AddParentIdToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :subjects, :parent, foreign_key: true
  end
end
