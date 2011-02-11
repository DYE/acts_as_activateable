module ActiveRecord
  module Acts
    module Activateable
      def self.included(base)
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
        def acts_as_activateable(options = {})
          @configuration = { 
          	:column => :active, 
          	:default => true 
          }.update(options)
          
          send :include, InstanceMethods
        end
        
        # Client.enable_all!
        def enable_all!
          all.each {|object| object.send("#{@configuration[:column]}=", true); object.save }
        end
        
        def disable_all!
          all.each {|object| object.send("#{@configuration[:column]}=", false); object.save; }
        end
        
        def find_enabled
          _find_all_by_active_status_of(true)
        end
        
        def find_disabled
          _find_all_by_active_status_of(false)
        end
        
        private 
        
        def _find_all_by_active_status_of(status)
          all(:conditions => { @configuration[:column] => status })
        end
        
      end
      
      module InstanceMethods
        def enable
          # send(:active, false)
          self.send("#{@configuration[:column]}=", true); save
        end
        
        def disable
          # send(:active, true)
          self.send("#{@configuration[:column]}=", false); save
        end
        
        def enabled?
          self.send(@configuration[:column])
        end
        
        def disabled?
          !enabled?
        end
      end
    end
  end
end