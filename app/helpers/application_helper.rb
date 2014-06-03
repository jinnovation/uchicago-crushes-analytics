module ApplicationHelper

  def raise_404
    raise ActionController::RoutingError.new('Not Found')
  end
end
