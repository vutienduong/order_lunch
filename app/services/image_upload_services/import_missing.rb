module ImageUploadServices
  class ImportMissing
    class << self
      def call(*args)
        new(*args).call
      end
    end

    def initialize; end

    def call; end
  end
end
