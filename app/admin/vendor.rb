ActiveAdmin.register Vendor do
  menu priority: 12
  permit_params :name, :address
end
