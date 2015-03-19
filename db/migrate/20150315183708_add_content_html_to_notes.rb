class AddContentHtmlToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :content_html, :text, null: true, default: nil
  end
end
