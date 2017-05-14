require_relative '../all_aboard/router'

module AppRouter
  def draw_router

    router = Router.new

    router.draw do
      get Regexp.new("^/vending_machines$"), VendingMachinesController, :show
      delete Regexp.new("^/vending_machines$"), VendingMachinesController, :destroy
      post Regexp.new("^/items$"), ItemsController, :create
      delete Regexp.new("^/items/(?<id>.+)$"), ItemsController, :destroy
    end

    router

  end
end
