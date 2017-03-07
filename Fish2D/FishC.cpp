//
//  FishC.cpp
//  Fish2D
//
//  Created by Igor Kovrizhkin on 4/26/13.
//  Copyright (c) 2013 kovrizhkin. All rights reserved.
//

#include "FishC.h"

#include <stdio.h>
#include <stdlib.h>

// FiShNet for Samsung R&D
// Draws a simple Net
// pseudo phisics of drag and gravitation
// not inertial for better performance and simplicity
// by Igor K.
// 25.02.12



    typedef struct {    // Structure for Dot (Left, Top) position, or (Horizontal, Vertical) forse
        float x;
        float y;
    }Dot;

//    Dot  g_DotNet[XDots][YDots];   // Main Array of Dots (nodes)
//    int  g_DraggedDot[2] = {0, 0}; // Indexes of Dragged Dot
//    GLboolean g_Clicked=0;
//    GLboolean g_Animation=1;

    const Dot forse0 ={0,0};

    // Phisics

    Dot Elementary_Forse(int i1, int k1, int i2, int k2){     // Function Calculates force between two Dots
        float dY, dX, D, dD;
        Dot forse;
//        
//        if (i2<0 || i2>=YDots || k2<0 || k2>=XDots) return forse0; // If 2nd Dot doesn't exist return {0, 0}
//        dY= g_DotNet[i1][k1].y - g_DotNet[i2][k2].y;
//        dX= g_DotNet[i1][k1].x - g_DotNet[i2][k2].x;
//        D=sqrt(dY*dY+dX*dX);      // distance between Dots
//        dD=D-spread;              // tension
//        if (dD<=0) return forse0; // if no tension return {0, 0}
//        else{
//            forse.x =  - (dX/D)*dD*k_guk;     // dF.x= cos(Alpha)*tension*Guk_koef
//            forse.y =  - (dY/D)*dD*k_guk;     // dF.y= sin(Alpha)*tension*Guk_koef
//            return forse;
//        }
    }

    void AddForses(Dot *forse1, Dot forse2)  // Adds forse2 to forse1
    {
        if (forse1){
            (*forse1).x=(*forse1).x+(forse2).x;
            (*forse1).y=(*forse1).y+(forse2).y;
        }
    }

    Dot Calculate_Forse(int i, int k){       // Function Calculates overal force
        Dot forse;
        
        forse.x=0;
//        forse.y=-Dot_mass;  // Ading gravity force
//        
        AddForses(&forse, (Elementary_Forse(i, k, i+1, k))); // upper connection
        AddForses(&forse, (Elementary_Forse(i, k, i-1, k))); // lower
        AddForses(&forse, (Elementary_Forse(i, k, i, k+1))); // right
        AddForses(&forse, (Elementary_Forse(i, k, i, k-1))); // left
        return forse;
    }


    void Deformation(){  // Moving dots with "Forse" dT(iterations) times
        Dot total_forse=forse0;
        int i,k,j;
        
//        for (j=0;j<=iterations;j++){    // Iterations
//            for(i=0;i<YDots;i++)
//                for(k=0;k<XDots;k++){
//                    if (((i==YDots-1 && k==0) || (i==YDots-1 && k==XDots-1))) continue;  // Is not upper left/right
//                    if ((g_Clicked) && (i==g_DraggedDot[0] && k==g_DraggedDot[1]))  continue;  // and not dragged
//                    AddForses(&(g_DotNet[i][k]), (Calculate_Forse(i,k)));  // coordinate movement
//                    AddForses(&total_forse   , (Calculate_Forse(i,k)));
//                }
//        }
        //	if ((ABS(total_forse.x+total_forse.y)<0.0001) && !g_Clicked) // If No movement Stop Animation
        //		g_Animation=0;
    }

    // Mouse Control Functions

    void SearchNearestDot(float x, float y){
        int  i, k ;
        float smallest;
        
//        for(i=0;i<YDots;i++)
//            for(k=0;k<XDots;k++){
//                smallest=abs(g_DotNet[i][k].x - x) + abs(g_DotNet[i][k].y - y); // Distance bewen Dots and cursor
//                if (abs(smallest) < spread) {  // if Distance less then spread - Grab that Dot
//                    g_DraggedDot[0]=i;
//                    g_DraggedDot[1]=k;
//                    i=YDots;
//                    g_Clicked=1;
//                    break;
//                }
//            }
//    }

//    void MouseDrag (int x, int y) {
//        GLint m_viewport[4];
//        glGetIntegerv( GL_VIEWPORT, m_viewport ); // returns the x and y window coordinates of the viewport, followed by its width and height
//        g_Animation=1;
//        if (g_Clicked && (!(m_viewport[2]==0) && !(m_viewport[3]==0))){
//            g_DotNet[g_DraggedDot[0]][g_DraggedDot[1]].x =    x / (float)m_viewport[2];
//            g_DotNet[g_DraggedDot[0]][g_DraggedDot[1]].y = 1- y / (float)m_viewport[3];
//        }
    }


    void MouseClick(int button, int state, int x, int y){
//        if(button == GLUT_LEFT_BUTTON)
//        {
//            GLint m_viewport[4];
//            glGetIntegerv( GL_VIEWPORT, m_viewport ); // returns the x and y window coordinates of the viewport, followed by its width and height
//            if(state == GLUT_DOWN){   // Mouse Left Klick Down
//                float x_t, y_t;
//                x_t=   x / (float) m_viewport[2] ;
//                y_t=1- y / (float) m_viewport[3] ;
//                SearchNearestDot(x_t, y_t);
//                // Clicked=1;
//            }
//            else	  {               // Mouse Left Klick Up
//                g_Clicked=0;
//            }
//        }
    }

    // Drawing

    void DrawDots(){
//        int i,k;
//        glEnable(GL_POINT_SMOOTH); // Makes Dots Round
//        glBegin(GL_POINTS);        // Draw Points
//        for(i=0;i<YDots;i++)
//            for(k=0;k<XDots;k++)
//                glVertex3f(g_DotNet[i][k].x, g_DotNet[i][k].y, 0.0);
//        glEnd();
    }


    void DrawNet(){
//        int i,k;
//        
//        for(i=0;i<YDots;i++){          // Draw Horizontal Lines
//            glBegin(GL_LINE_STRIP);    // Draw Broken Line trhough points - ÎÓÏ‡Ì‡ˇ ÎËÌËˇ, ˜ÂÂÁ ‚ÒÂ ÚÓ˜ÍË
//            for(k=0;k<XDots;k++){
//                glVertex3f(g_DotNet[i][k].x, g_DotNet[i][k].y,0.0);
//            }
//            glEnd();
//        }
//        
//        for(k=0;k<XDots;k++){           // Draw Vertical Lines
//            glBegin(GL_LINE_STRIP);
//            for(i=0;i<YDots;i++){
//                glVertex3f(g_DotNet[i][k].x, g_DotNet[i][k].y,0.0);
//            }
//            glEnd();
//        }
    }

    void Draw() {
//        glClear(GL_COLOR_BUFFER_BIT);
//        glColor3f(1.0, 1.0, 1.0); // Color Of Lines And Dots (R,G,B)
//        glPointSize(5);
//        DrawDots();
//        glLineWidth(1);
//        DrawNet();
//        Deformation();         // Move Dots
//        glutSwapBuffers();
    }

    // Initialize and Setup

    void Timer(int i){
//        if (g_Animation) {
//            glutPostRedisplay();
//        }
//        glutTimerFunc(30, Timer, 1);
//    }
//
//    void Initialize() {     // Initializing Open GL Enviroment
//        glClearColor(0.0, 0.0, 0.0, 0.0);
//        glMatrixMode(GL_PROJECTION);
//        glLoadIdentity();
//        glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
//    }
//
//    int OldFishMain(int iArgc, char** cppArgv) {
//        char i,k;
//        
//        glutInit(&iArgc, cppArgv);                      // Initializing display ans Window
//        glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
//        glutInitWindowSize(500, 500);
//        glutInitWindowPosition(200, 50);
//        glutCreateWindow("FishNet");
//        
//        Initialize();
//        
//        for(i=0;i<YDots;i++)
//            for(k=0;k<XDots;k++){
//                g_DotNet[i][k].x=left_Indent + spread*k;  // initial position of Dots in Net
//                g_DotNet[i][k].y=Top_Indent + spread*i;
//            }
//        
//        glutMouseFunc(MouseClick); // Sets the Function which Detects Mouse Click
//        glutMotionFunc(MouseDrag); // , Mouse Drag
//        glutDisplayFunc(Draw);     // Sets the Function which Draws in Window
//        Timer(1);
//        glutMainLoop();   // Enters the GLUT event processing loop
//        return 0;
    }