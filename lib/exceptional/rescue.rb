module Exceptional::Rescue
  def self.included(base)
    base.class_eval do
      alias_method_chain :rescue_action, :exceptional
    end
  end
  
  def rescue_action_with_exceptional(exception)
    Exceptional.log(self, exception)
    rescue_action_without_exceptional(exception)
  end
end
