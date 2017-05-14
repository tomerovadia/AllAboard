require 'rack'
require_relative '../../all_aboard/controller_base'
Dir[File.dirname(__FILE__) + "/../models/*.rb"].each { |file| require_relative file }

class ItemsController < ControllerBase

  def create
    new_item = Item.new({name: params['item']['name'], price: params['item']['price']})
    session['vending_machine'][new_item.id] = new_item

    redirect_to '/'
  end

  def destroy
    session['vending_machine'].delete(params['id'])

    redirect_to '/'
  end

end
