#Entwickelt für CG SS08
#von Karsten Siesing (s0516130)
#Tutor: Prof. Thomas Jung

include Math
require 'CSV'
PI = 3.141
Coef =    PI/180
class Shoulders
  
        attr_accessor :shLength, :deltaAngle, :shAngle, :shCent, :balance
        attr_accessor :shBegin, :shEnd, :balLocation, :balCenter
        #protected :shAngle, :shCent
        
   Coordinate = Struct.new("Coordinate",:x , :y)
   def initialize    
    @shCent= Coordinate[0,0]
    @shLength=100
    @deltaAngle=0
    @shAngle=0
    @shEnd= Coordinate[0,0]
    @shEnd.x = self.shCent.x+(@shLength/2).ceil
    @shEnd.y=self.shCent.y
    self.balance=@shEnd
    self.balLocation=0
    self.balCenter = self.balance 
    
  end
    
protected
  def calculate()
    @shBegin = Coordinate[0,0]
    #puts self.shAngle
    @shBegin[:x] = @shCent.x-(cos(Coef*@shAngle)*@shLength/2)
    @shBegin[:y]=@shCent.y-(sin(Coef*@shAngle)*@shLength/2)
    @shEnd[:x]=@shCent.x+(cos(Coef*@shAngle)*@shLength/2)
    @shEnd[:y]=@shCent.y+(sin(Coef*@shAngle)*@shLength/2)
    
    if @shAngle < 180 && @shAngle
      self.balance = @shEnd
      self.balLocation=1
      else if @shAngle > 180
        
        self.balance = self.shBegin
        self.balLocation=0
      end
      self.balCenter=self.balance
    end
    
  end
  
        
 public :shLength, :shBegin, :balLocation, :balCenter, :shEnd
 public
        def shLength=(newLength)
          @shLength=newLength
          calculate()
        end
        def shBegin=(newBegin)
          @shBegin = newBegin
          calculate()
        end
        def shEnd=(newEnd)
          @shEnd=newEnd
          calculate()
        end
        def deltaAngle=(newAngle)
          @deltaAngle=newAngle
          calculate()
        end
        
         def Shoulders.parse(string)
      CSV::Reader.parse(string){|row| row.each {|cell| puts cell}}
    end
end 
      
     