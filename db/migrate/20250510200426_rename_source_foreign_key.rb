class RenameSourceForeignKey < ActiveRecord::Migration[7.2]
  def change
    rename_column :bills, :payment_source, :payment_source_id
  end
end
