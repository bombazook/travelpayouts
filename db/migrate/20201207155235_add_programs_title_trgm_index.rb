class AddProgramsTitleTrgmIndex < ActiveRecord::Migration[6.0]
  def change
    add_index(:programs, :title, using: 'gin', opclass: :gin_trgm_ops) # speedup 3+ LIKE searches
  end
end
