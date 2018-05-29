module OrderLunch
  class Base < Grape::API
    def self.inherited(subclass)
      super

      subclass.instance_eval do
        include OrderLunch::BaseHelpers
      end
    end
  end
end
