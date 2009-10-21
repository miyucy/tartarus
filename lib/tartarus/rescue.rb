module Tartarus::Rescue
  def self.included(base)
    base.class_eval do
      alias_method_chain :rescue_action, :tartarus
    end
  end
  
  def rescue_action_with_tartarus(exception)
    if response_code_for_rescue(exception) == :internal_server_error
      Tartarus.log(self, exception)
    end

    rescue_action_without_tartarus(exception)
  end
end
