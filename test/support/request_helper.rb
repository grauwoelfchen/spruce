module RequestHelper
  private

    def with_params(controller, params)
      controller.request = fake_request
      controller.stub(:params, params) do
        yield
      end
    end

    def with_referer(controller, referer_value)
      with_request(controller, :referer => referer_value) do
        yield
      end
    end

    def with_request(controller, stubs={}, &block)
      controller.request = fake_request
      unless stubs.blank?
        request_stubs(controller.request, stubs, &block)
      else
        yield(controller)
      end
    end

    def request_stubs(req, stubs, &block)
      stubs.keys.inject(block) { |memo, key|
        memo = Proc.new {
          req.stub(key, stubs[key]) do
            memo
          end
        }
      }.call
    end

    def fake_request
      env = {
        "SERVER_NAME" => "localhost",
        "HTTP_HOST"   => "test.host"
      }
      ActionDispatch::Request.new(env)
    end
end
