# frozen_string_literal: true

module BK
  module Compat
    # CircleCI orb handling
    class CircleCI
      private

      def load_orb(key, _conf)
        @translator.register(CircleCISteps::GenericOrb.new(key))
      end
    end

    module CircleCISteps
      # Generic orb steps/jobs (that states it is not supported)
      class GenericOrb
        def initialize(key)
          @prefix = key
        end

        def matcher(orb, _conf)
          orb.start_with?("#{@prefix}/")
        end

        def translator(action, _config)
          [
            "# #{action} is part of orb #{@prefix} which is not supported and should be translated by hand"
          ]
        end
      end
    end
  end
end
