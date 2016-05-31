// Copyright 2012 Dolphin Emulator Project
// Copyright 2016 Will Cobb
// Licensed under GPLv2+
// Refer to the license.txt file included.

// From what I can tell, GLKView requires drawing to the framebuffer to be done in
// glkView:drawInRect:. Instead of drawing in the video backend, it instead compies
// over texture data in Draw(). GLDraw() will be called by the GLKView callback.

#include <array>
#include <cstdlib>
#include <sstream>
#include <vector>

#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>
#import "Common/GL/GLInterface/GLProgram.h"

#include "Common/GL/GLInterface/IGL.h"
#include "Common/Logging/Log.h"
#include "Common/GL/GLUtil.h"

const float positionVert[] =
{
    -1.0f, 1.0f,
    1.0f, 1.0f,
    -1.0f, -1.0f,
    1.0f, -1.0f
};

const float textureVert[] =
{
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f
};

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const kVertShader = SHADER_STRING (
                                             precision highp float;
                                             attribute vec4 position;
                                             attribute vec2 inputTextureCoordinate;
                                             
                                             varying highp vec2 texCoord;
                                             
                                             void main()
                                             {
                                                 texCoord = inputTextureCoordinate;
                                                 gl_Position = position;
                                             }
                                             );
NSString *const kFragShader = SHADER_STRING (
                                             precision highp float;
                                            uniform sampler2D inputImageTexture;
                                            varying highp vec2 texCoord;
                                            
                                            void main()
                                            {
                                                highp vec4 color = texture2D(inputImageTexture, texCoord);
                                                gl_FragColor = color;
                                            }
                                            );


EAGLContext *context;
GLKView *glkView;
EAGLSharegroup* shareGroup;
GLProgram *program;
GLuint texHandle[1];
GLint attribPos;
GLint attribTexCoord;
GLint texUniform;
bool initiated = false;
int framenum = 0;
// Show the current FPS
void cInterfaceIGL::Swap()
{
    NSLog(@"Frame: %d", framenum++);
}
void cInterfaceIGL::SwapInterval(int Interval)
{
}


void cInterfaceIGL::DetectMode()
{
    s_opengl_mode = GLInterfaceMode::MODE_OPENGLES3;
}

bool cInterfaceIGL::Create(void *window_handle, bool core)
{
    initiated = true;
    
    printf("Creating render window: %p\n", window_handle);
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext: context];
    NSLog(@"Context: %@", context);
    glkView = (GLKView *)window_handle;
    glkView.context = context;
    
    CAEAGLLayer * eaglLayer = (CAEAGLLayer*) glkView.layer;
    eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES)};
    
    NSLog(@"GLK View: %@", glkView); 
    
    s_backbuffer_width = glkView.frame.size.width;
    s_backbuffer_height = glkView.frame.size.height;
    
    
    
    return true;
}

void init()
{
    if (!initiated)
        return;
    initiated = true;
    program = [[GLProgram alloc] initWithVertexShaderString:kVertShader fragmentShaderString:kFragShader];
    
    [program addAttribute:@"position"];
    [program addAttribute:@"inputTextureCoordinate"];
    
    [program link];
    
    attribPos = [program attributeIndex:@"position"];
    attribTexCoord = [program attributeIndex:@"inputTextureCoordinate"];
    
    texUniform = [program uniformIndex:@"inputImageTexture"];
    
    glEnableVertexAttribArray(attribPos);
    glEnableVertexAttribArray(attribTexCoord);
    
    glViewport(0, 0, 4, 3);//size.width, size.height);
    
    [program use];
    
    glGenTextures(1, texHandle);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texHandle[0]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

void cInterfaceIGL::GLDraw()
{

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texHandle[0]);
    glUniform1i(texUniform, 1);
    
    glVertexAttribPointer(attribPos, 2, GL_FLOAT, 0, 0, (const GLfloat*)&positionVert);
    glVertexAttribPointer(attribTexCoord, 2, GL_FLOAT, 0, 0, (const GLfloat*)&textureVert);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void cInterfaceIGL::Draw(u8* data, int width, int height)
{
//    for (int i = 0; i < 1000; i++) {
//        data[i * 3] = 200;
//    }
    
    init();
    
    glBindTexture(GL_TEXTURE_2D, width);//texHandle[0]);
    //glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    [glkView display]; // This will automatically throttle to 60 fps
}

std::unique_ptr<cInterfaceBase> cInterfaceIGL::CreateSharedContext()
{
    NSLog(@"CreateSharedContext()");
//	std::unique_ptr<cInterfaceBase> context = std::make_unique<cInterfaceIGL>();
//	if (!context->Create(this))
//		return nullptr;
//	return context;
}

bool cInterfaceIGL::Create(cInterfaceBase* main_context)
{
    NSLog(@"Create(cInterfaceBase* main_context)");

	return true;
}

bool cInterfaceIGL::CreateWindowSurface()
{
    NSLog(@"CreateWindowSurface()");
    
	return true;
}

void cInterfaceIGL::DestroyWindowSurface()
{
//	if (egl_surf != EGL_NO_SURFACE && !eglDestroySurface(egl_dpy, egl_surf))
//		NOTICE_LOG(VIDEO, "Could not destroy window surface.");
//	egl_surf = EGL_NO_SURFACE;
}

bool cInterfaceIGL::MakeCurrent()
{
    [EAGLContext setCurrentContext: context];
    return true;
}

void cInterfaceIGL::UpdateHandle(void* window_handle)
{
//	m_host_window = (EGLNativeWindowType)window_handle;
//	m_has_handle = !!window_handle;
}

void cInterfaceIGL::UpdateSurface()
{
//	ClearCurrent();
//	DestroyWindowSurface();
//	CreateWindowSurface();
//	MakeCurrent();
}

bool cInterfaceIGL::ClearCurrent()
{
    return true;
}

// Close backend
void cInterfaceIGL::Shutdown()
{
//	ShutdownPlatform();
}
