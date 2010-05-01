#Entwickelt für CG SS08
#von Karsten Siesing (s0516130)
#Tutor: Prof. Thomas Jung
require "opengl"
require "gl"
require "glu"
include GL,GLU

StgDiam = 10
BalDiam = 30
JointLeng = BalDiam+StgDiam
CentDiam = 30

$wechsel = nil

  def GLCreate()
    glClearColor(0.0,0.0,0.0,0.0)
    glEnable(GL_COLOR_MATERIAL)
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_SCISSOR_TEST)
    p=[10.0,10.0,10.0,0.0]
    glLightfv(GL_LIGHT0,GL_POSITION,p)
    $glMainObj=gluNewQuadric()
    gluQuadricDrawStyle($glMainObj,GLU_FILL)
    glRotatef(90,0,1,0)
    
    return 0
  end
  
  GLTerminate = Proc.new {
  gluDeleteQuadric($glMainObj)
  }
  
  def wechsel(wechsel)
    if wechsel == 'teapot'
      glutSolidTeapot(BalDiam)
      else
      gluSphere($glMainObj,BalDiam,20,20)
    end
  end
  
  GLResize = Proc.new{|width,height|
  glViewport(0,0,width,height)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glOrtho(-(width/2),width/2, -(height/2),height/2,-(height/2),height/2)
  glMatrixMode(GL_MODELVIEW)
  glScissor(0,0,width,height)
  }

  def GLClear
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT)
  end


  GLCreateObjects = Proc.new{|stange|
  #  Draw stange
  glColor3f(0.5,0.0,0.0)#0.7,0.5,1
  glRotatef(stange.stgAngle,1,0,0)
  gluCylinder($glMainObj,StgDiam,StgDiam,stange.stgLength,10,10)
  glRotatef(-stange.stgAngle,1,0,0)

  #  Draw stange plug
  glTranslatef(0,-stange.stgEnd.y,stange.stgEnd.x)
  gluSphere($glMainObj,StgDiam,20,20)
  glTranslatef(0,stange.stgEnd.y,-stange.stgEnd.x)

  #  Draw shoulder joint
  glTranslatef(0,-stange.stgEnd.y,stange.stgEnd.x)
  glRotatef(-90,0,1,0)
  gluCylinder($glMainObj,StgDiam,0,JointLeng,10,10)
  glRotatef(90,0,1,0)
  glTranslatef(0,stange.stgEnd.y,-stange.stgEnd.x)

  #  Draw shoulder
  glColor3f(1,0,0)#(0.5,0.2,0.5)
  glTranslatef(-JointLeng,-stange.shBegin.y,stange.shBegin.x)
  glRotatef(stange.shAngle,1,0,0)
  gluCylinder($glMainObj,StgDiam,StgDiam,stange.shLength,10,10)
  glRotatef(-stange.shAngle,1,0,0)
  glTranslatef(JointLeng,stange.shBegin.y,-stange.shBegin.x)

  #  Draw shoulder plugs
  glTranslatef(-JointLeng,-stange.shBegin.y,stange.shBegin.x)
  gluSphere($glMainObj,StgDiam,20,20)
  glTranslatef(JointLeng,stange.shBegin.y,-stange.shBegin.x)

  glTranslatef(-JointLeng,-stange.shEnd.y,stange.shEnd.x)
  gluSphere($glMainObj,StgDiam,20,20)
  glTranslatef(JointLeng,stange.shEnd.y,-stange.shEnd.x)

  #  Draw balance
  glColor3f(1,1,1)#(0,0.5,1)
  glTranslatef(-JointLeng,-stange.balCenter.y,stange.balCenter.x)
  wechsel($wechsel)
  glTranslatef(JointLeng,stange.balCenter.y,-stange.balCenter.x)
  
  #  Draw central sphere
  glColor3f(0,0.5,0)#(1,1,0.5)
  gluSphere($glMainObj,CentDiam,20,10)
  glutPostRedisplay()
  }

  def GLPaint
    glutSwapBuffers() 
  end


  def GLRotate(deg)
  glRotatef(deg,0,1,0)
  end
  
  def GLRotateY(deg)
  glRotatef(deg,1,0,0)
  end