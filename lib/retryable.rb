module Retryable
  def self.attempt(options = {}, &block)
    opts = { :tries => 1, :on => Exception }.merge(options)

    return nil if opts[:tries] == 0

    retry_exception, tries = [ opts[:on] ].flatten, opts[:tries]

    begin
      return yield
    rescue *retry_exception => e
      retry if (tries -= 1) > 0
    end

    yield
  end
end
