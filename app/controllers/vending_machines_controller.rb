require 'rack'
require_relative '../../all_aboard/controller_base'
Dir[File.dirname(__FILE__) + "/../models/*.rb"].each {|file| require_relative file }

class VendingMachinesController < ControllerBase

  def show

    @name_to_image_filename = {
      skittles: 'skittles.jpg',
      doritos: 'doritos.png',
      cheetos: 'cheetos.png',
      'm&ms': 'm&ms.jpeg',
      'swedish fish': 'swedish_fish.jpeg',
      starburst: 'starburst.png',
      'cheez-its': 'cheez_its.jpg',
    }

    itemsFromCookie = session['vending_machine']

    @vending_machine = VendingMachine.new(itemsFromCookie)

    @user_mode = params['user-mode'] || session['user_mode'] || 'customer'
    session['user_mode'] = @user_mode

    # refresh cookie in case default items were used to create VendingMachine
    session['vending_machine'] = @vending_machine.itemsHash

    render("show")
  end

  def destroy
    session['vending_machine'] = nil

    redirect_to '/'
  end

end
