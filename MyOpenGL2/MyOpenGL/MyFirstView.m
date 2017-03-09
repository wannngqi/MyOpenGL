//
//  MyFirstView.m
//  MyOpenGL
//
//  Created by wangqi on 17/3/7.
//  Copyright © 2017年 wangqi. All rights reserved.
//

#import "MyFirstView.h"
#include <OpenGL/gl3.h>
#import "LoadShaders.h"

enum VAO_IDs {Triangles, NumVAOs};
enum Buffer_IDs {ArrayBuffer, NumBuffers};
enum Atrib_IDs {vPostion = 0};

GLuint VAOs[NumVAOs];
GLuint Buffers[NumBuffers];

const GLuint NumVertices = 6;

static void init(){
    glGenVertexArrays(NumVAOs, VAOs);
    glBindVertexArray(VAOs[Triangles]);
    
    GLfloat vertices[NumVertices][2] = {
        { -0.90, -0.90 },
        {  0.85, -0.90 },
        { -0.90,  0.85 },
        {  0.90, -0.85 },
        {  0.90,  0.90 },
        { -0.85,  0.90 },
    
    };
    
    glGenBuffers(NumBuffers, Buffers);
    glBindBuffer(GL_ARRAY_BUFFER, Buffers[ArrayBuffer]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    NSString* vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"triangles" ofType:@"vert"];
    NSString* fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"triangles" ofType:@"frag"];
    
    ShaderInfo shaders[] = {
        {GL_VERTEX_SHADER, vertexShaderPath.UTF8String},
        {GL_FRAGMENT_SHADER, fragmentShaderPath.UTF8String},
        {GL_NONE, NULL},
    };
    
    GLuint program = LoadShaders(shaders);
    glUseProgram(program);
    
    glVertexAttribPointer(vPostion, 2, GL_FLOAT, GL_FALSE, 0, (void *)0);
    glEnableVertexAttribArray(vPostion);
}

static void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glBindVertexArray(VAOs[Triangles]);
    glDrawArrays(GL_TRIANGLES, 0, NumVertices);
    glFlush();
}
@implementation MyFirstView

- (void)awakeFromNib {
    
    NSOpenGLPixelFormatAttribute attributes[] = {
        NSOpenGLPFADepthSize,(NSOpenGLPixelFormatAttribute)24,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        (NSOpenGLPixelFormatAttribute)0
    };
    
    NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    [self setPixelFormat:pf];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    const GLubyte *version = glGetString(GL_VERSION);
    const GLubyte *glslVersion = glGetString(GL_SHADING_LANGUAGE_VERSION);
    
    NSLog(@"gl version %s",version);
    NSLog(@"glsl version %s",glslVersion);
    
    init();
    display();
    
}

@end
