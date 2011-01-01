module ActiveRecord
  module Acts
    module Activateable
      def self.included(base)
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
        def acts_as_activateable(column = :active)
          @configurations = { :column => :active, :default => true }
          @configurations.update(options)
          
          send :include, InstanceMethods
        end
        
        # Client.enable_all!
        def enable_all!
          all.each {|object| object.active = true; object.save; }
        end
        
        def disable_all!
          all.each {|object| object.active = false; object.save; }
        end
        
        def find_enabled
          _find_all_by_active_status_of(true)
        end
        
        def find_disabled
          _find_all_by_active_status_of(false)
        end
        
        private 
        
        def _find_all_by_active_status_of(status)
          all(:conditions => ["active = ?", status])
        end
        
      end
      
      module InstanceMethods
        def enable
          # send(:active, false)
          self.active = true
          save
        end
        
        def disable
          # send(:active, true)
          self.active = false
          save
        end
        
        def enabled?
          self.active
        end
        
        def disabled?
          #enabled = send(column)
          #!enabled
          !self.active
        end
      end
    end
  end
end