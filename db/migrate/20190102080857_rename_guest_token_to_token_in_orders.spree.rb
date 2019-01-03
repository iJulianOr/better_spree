class RenameGuestTokenToTokenInOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :token, :string
  end
end
