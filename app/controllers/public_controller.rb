class PublicController < ApplicationController
  def home
  end

  def about
  end

  def contact
  end

  def plans
    render "accounts/plans"
  end
end
