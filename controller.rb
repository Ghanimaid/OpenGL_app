#Entwickelt für CG SS08
#von Karsten Siesing (s0516130)
#Tutor: Prof. Thomas Jung
require 'gl'
require 'glut'
require 'glu'
require "Stangen.rb"
require 'Graph.rb'
require 'win32/sound'
require 'fileutils'
require 'begruessung.rb'
include Win32
include Gl,Glut,Glu

def titel
    "CG Beleg Karsten Siesing(s0516130) 'Entspannung am Bildschirm'"
end

  MinBalCnt = 7
  MaxBalCnt =50
  Coordinate = Struct.new(:x, :y)
    
  $width = 800
  $height = 600
    
  @center = Coordinate[0,0]
  $stgCnt= 35
  @@counter=1
  $winkel=0.0
  $curX=0
  $curY=0
  
  @Stangen= Array.new
  @audio= true
  @audioFileDefault ='defaultaudio.wav'
  
  def init
    if(GLCreate()!=0)
      puts ("Kann keinen OpenGL Inhalt erzeugen")
    end
    for i in 0...MaxBalCnt
    @Stangen[i]= Stangen.new(@center)
    @Stangen[i].deltaAngle=10
  end
  puts begruessung
  puts handhabung
  if !(File.exists? 'Readme.txt')
    readme handhabung
  end
  
  end
  
  def force
    $force
  end
  
  #erzeugt Readmedatei
  def readme(string)
    open('Readme.txt','a') do |f| f.puts string end
  end
  
  def playsound
    if @audio
      if @audioFile.nil?
        if File.exists? @audioFileDefault
        Sound.play(@audioFileDefault, Sound::ASYNC | Sound::LOOP)
        else 
          puts 'die default Audiodatei ist leider nicht vorhanden, bitte druecken Sie F1 um ihre Musikdatei anzugeben!'
      end
      else
        if File.exists? @audioFile
          if @audioFile.slice(-4,4) == '.wav'
            Sound.play(@audioFile,Sound::ASYNC | Sound::LOOP)
            else
              puts 'dies ist keine .WAV datei'
              @audioFile = nil
              playsound
            end
          else
            puts 'Ihre Datei existiert an dieser Stelle nicht.'
            @audioFile = nil
            playsound
          end
      end
    end
  end
  
  def eingabeAudio
    #system 'cls'
    Sound.stop(true)
    puts "Bitte geben Sie die Adresse ihres Titels ein!"
    print ">>>:"
    @audioFile = gets
    @audioFile.chomp!
    playsound
  end
  
  #Einstellung der Geschwindigkeit
  $force = 0.50
  
  display= Proc.new{
  if @@counter ==1
  playsound
  end
  #Anpassung der Form an Bildgröße
  resize($width,$height)    
 
  GLClear()
    
  i = 0    
  while i < $stgCnt
  
  #Winkel der Objekte wird eingestellt
  @Stangen[i].stgAngle=$winkel+(360.0/$stgCnt)*i
 
  #Kreaierung der einzelnen Objekte
  GLCreateObjects.call @Stangen[i]
  
  #Umdrehungskraft wird berechnet
  $force+= cos(Coef*@Stangen[i].stgAngle)*@Stangen[i].balLocation
  
  i+=1
 
  @@counter+=1
  end

  $winkel= $winkel+ $force.ceil
  $winkel= @Stangen[1].normalize($winkel)
  
  GLPaint()
  
  }

  #die Formen werden dem Fenster angepasst
  def resize(breite,hoehe)
    for i in 0...MaxBalCnt
    @Stangen[i].stgLength=hoehe/2-hoehe/8-30
    @Stangen[i].shLength=hoehe/4-25
    end
    GLResize.call(breite,hoehe)
  end

  keyboard = lambda do |key, x, y|
    case(key)
      when ?\e,?q,?Q
      exit(0)
      when ?t,?T
      if $wechsel != 'teapot'
      $wechsel = 'teapot'
      else $wechsel = nil
      end
      when ?s,?S
      if @audio
        Sound.stop(true)
        @audio= false
        else if !@audio
          @audio= true
          @@counter = 1
        end
      end
    end
  end

 specialKey = lambda do |key, x, y|
    case(key)
      when GLUT_KEY_UP
      if $stgCnt<MaxBalCnt
        $stgCnt+=1
      end
      when GLUT_KEY_DOWN
      if $stgCnt>MinBalCnt
        $stgCnt-=1
      end
      when GLUT_KEY_PAGE_UP
      #GLRotateY(1)
      when GLUT_KEY_PAGE_DOWN
      #GLRotateY(-1)
      when GLUT_KEY_RIGHT
      GLRotate(1)
      when GLUT_KEY_LEFT
      GLRotate(-1)
      when GLUT_KEY_F1
      eingabeAudio()
    end
    glutPostRedisplay()
  end
  
  motion = lambda do |x,y|
    if ($curX != -1)
      GLRotate(x-$curX)
    end
    if ($curY != -1)
      GLRotateY(y-$curY)
    end
    $curY=y
    $curX=x
  end
  
  def reshape(breite,hoehe)
    resize(breite,hoehe)
    $height= hoehe
    $width= breite
  end
  


Glut.glutInit
Glut.glutInitDisplayMode(Glut::GLUT_DOUBLE | Glut::GLUT_RGB)
Glut.glutInitWindowSize($width,$height)
Glut.glutInitWindowPosition(1, 1)
Glut.glutCreateWindow(titel)
init()
Glut.glutDisplayFunc(display)
Glut.glutReshapeFunc(method('reshape').to_proc)
Glut.glutKeyboardFunc(keyboard)
Glut.glutSpecialFunc(specialKey)
Glut.glutMotionFunc(motion)
Glut.glutMainLoop()

