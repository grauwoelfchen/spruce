class RevertConstraint
  def matches?(req)
    valid_type?(req.params) && valid_direction?(req.params)
  end

  private

  def valid_type?(params)
    params[:type] =~ /^b|l$/
  end

  def valid_direction?(params)
    !params[:redo] || params[:redo] =~ /^true|false$/
  end
end
