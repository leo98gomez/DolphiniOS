// Copyright 2008 Dolphin Emulator Project
// Copyright 2016 Will Cobb
// Licensed under GPLv2+
// Refer to the license.txt file included.

#pragma once

// Will Edited
// Needs to be rewritten for iOS

#include <string>
//#include <EGL/egl.h>
//#include <EGL/eglext.h>

#include "Common/GL/GLInterfaceBase.h"

class cInterfaceIGL : public cInterfaceBase
{
private:
	//EGLConfig m_config;
	bool m_has_handle;
	//EGLNativeWindowType m_host_window;
	bool m_supports_surfaceless = false;
    

	bool CreateWindowSurface();
	void DestroyWindowSurface();

protected:
	void DetectMode();
	//EGLSurface egl_surf;
	//EGLContext egl_ctx;
	//EGLDisplay egl_dpy;

	//virtual EGLDisplay OpenDisplay() { return eglGetDisplay(EGL_DEFAULT_DISPLAY); }
	//virtual EGLNativeWindowType InitializePlatform(EGLNativeWindowType host_window, EGLConfig config) { return (EGLNativeWindowType)EGL_DEFAULT_DISPLAY; }
	virtual void ShutdownPlatform() {}

public:
	void Swap() override;
	void SwapInterval(int interval) override;
	void SetMode(GLInterfaceMode mode) override { s_opengl_mode = mode; }
	bool Create(void* window_handle, bool core) override;
	bool Create(cInterfaceBase* main_context) override;
	bool MakeCurrent() override;
	bool ClearCurrent() override;
	void Shutdown() override;
	void UpdateHandle(void* window_handle) override;
	void UpdateSurface() override;
	std::unique_ptr<cInterfaceBase> CreateSharedContext() override;
    
    void Draw(u8* data, int width, int height) override;
    void GLDraw() override;
};
