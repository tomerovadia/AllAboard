require_relative '../all_aboard/router'

module AppRouter
  def draw_router

    router = Router.new

    router.draw do
      get Regexp.new("^/$"), MyController, :index
    end

    router

  end
end
