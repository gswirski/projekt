class Product < ActiveRecord::Base
  belongs_to :vendor

  def display_name
    "[#{vendor.name}] #{name}"
  end
end
