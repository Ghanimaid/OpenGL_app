#Entwickelt für CG SS08
#von Karsten Siesing (s0516130)
#Tutor: Prof. Thomas Jung

require "Shoulders.rb"

class Stangen < Shoulders
   attr_accessor :stgAngle, :stgLength, :zero, :shBegin, :stgEnd, :stgBegin
        @@zaehler = 1
        def initialize(center)
          @stgBegin = Coordinate[0,0]
          @stgEnd= Coordinate[0,0]
          super()
          self.stgLength=100
          self.zero=center
          self.stgAngle=0
          calculate()
        end
        
        
        
        def normalize(angle)
         
          angle-360
        end

 private
        
        def calculate()
          @stgBegin=self.zero
          @stgEnd.x=self.zero.x+(cos(Coef*self.stgAngle))*self.stgLength
          @stgEnd.y=self.zero.y+(sin(Coef*self.stgAngle))*self.stgLength
          self.shCent=@stgEnd
          
          self.shAngle=normalize(stgAngle + deltaAngle)
          super()
          
          @@zaehler+=1
        end
end
      