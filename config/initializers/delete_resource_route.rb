module DeleteResourceRoute
  def self.included(klass)
    super
    klass.instance_variable_set("@_with_delete", false)
  end

  # Add additional `:delete` routes
  #
  #   resources :books, :with => [:delete]
  #
  def resources(*args, &block)
    opts = args.last.delete(:with)
    handle_with_routes_option(opts)
    super(*args) do
      yield if block_given?
      if with_delete?
        member do
          get :delete
          delete :delete, action: :destroy
        end
        disable_delete_route
      end
    end
  end

  private

  def handle_with_routes_option(opts)
    if opts.is_a?(Array)
      if opts.include?(:delete)
        @_with_delete = true
      end
    end
  end

  def with_delete?
    @_with_delete
  end

  def disable_delete_route
    @_with_delete = false
  end
end

ActionDispatch::Routing::Mapper.send(:include, DeleteResourceRoute)
