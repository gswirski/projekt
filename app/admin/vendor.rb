ActiveAdmin.register Vendor do
  menu priority: 11
  permit_params :name, :address
end
