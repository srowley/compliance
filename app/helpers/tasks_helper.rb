module TasksHelper
  def csv_params(params)
    if params.nil?
      { format: 'csv' }
    else
      { format: 'csv' }.merge({ filter: params }) unless params.nil?
      end
  end
end
