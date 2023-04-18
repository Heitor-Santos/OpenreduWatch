class ApplicationController < ActionController::Base
    def mocks
        puts "Testeee"
        puts request.path
        render plain: 'Hello World!'
      end
    
      def hello2
        render plain: 'Hello World!'
      end
    
      def hello3
        render plain: 'Hello World!'
      end
end
