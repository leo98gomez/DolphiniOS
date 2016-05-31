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



EAGLContext *context;
GLKView *glkView;
int framenum = 0;

void cInterfaceIGL::Swap()
{
    NSLog(@"Frame: %d", framenum++);
}
void cInterfaceIGL::SwapInterval(int Interval)
{
}

GLInterfaceMode cInterfaceIGL::GetMode()
{
    return GLInterfaceMode::MODE_OPENGLES3;
}

void cInterfaceIGL::DetectMode()
{
    s_opengl_mode = GLInterfaceMode::MODE_OPENGLES3;
}

bool cInterfaceIGL::Create(void *window_handle, bool core)
{
    printf("IGL: Creating render window: %p\n", window_handle);
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext: context];
    glkView = (GLKView *)window_handle;
    glkView.context = context;
    
    //CAEAGLLayer * eaglLayer = (CAEAGLLayer*) glkView.layer;
    //eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES)};
    
    s_backbuffer_width = glkView.frame.size.width;
    s_backbuffer_height = glkView.frame.size.height;
    return true;
}

void cInterfaceIGL::GLDraw()
{
    
}

void cInterfaceIGL::Update()
{
    printf("IGL: Update\n");
}
void cInterfaceIGL::Draw(u8* data, int width, int height)
{
    [glkView display];
    printf("IGL: Draw\n");
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
