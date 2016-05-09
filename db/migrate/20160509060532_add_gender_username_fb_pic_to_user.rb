class AddGenderUsernameFbPicToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :gender, :string
    add_column :users, :fb_pic, :string
  end
end
