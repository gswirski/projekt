ActiveAdmin.register Product do
  menu priority: 12
  permit_params :name, :serving_size, :serving_unit,
    :calories, :fat, :carbs, :proteins, :vendor_id
end
