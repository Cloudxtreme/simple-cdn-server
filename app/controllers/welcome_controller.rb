class WelcomeController < ApplicationController

  def index
    @nearly_full_accesses = Access.all
  end
end
