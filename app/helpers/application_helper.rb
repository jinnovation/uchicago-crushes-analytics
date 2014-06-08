module ApplicationHelper

  def raise_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def link_to_new_tab(txt, path, opts={})
    link_to txt, path, { target: "_blank"}.merge(opts)
  end
end
