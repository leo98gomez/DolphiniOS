//
//  DolphinBridge.m
//  DolphiniOS
//
//  Created by mac on 2015-03-17.
//  Copyright (c) 2015 OatmealDome. All rights reserved.
//

// Big thank you to OatmealDome for this bridge class

#import "DolphinBridge.h"

#import <Foundation/Foundation.h>

//#import "Common/FileUtil.h"

#include <cstdio>
#include <cstdlib>

//#include "Android/ButtonManager.h"
#include "Common/CommonPaths.h"
#include "Common/CommonTypes.h"
#include "Common/CPUDetect.h"
#include "Common/Event.h"
#include "Common/FileUtil.h"
#include "Common/Logging/LogManager.h"
#include "Core/BootManager.h"
#include "Core/ConfigManager.h"
#include "Core/Core.h"
#include "Core/Host.h"
#include "Core/State.h"
#include "Core/HW/Wiimote.h"
#include "Core/PowerPC/PowerPC.h"

// Banner loading
//#include "DiscIO/BannerLoader.h"
#include "DiscIO/Filesystem.h"
#include "DiscIO/VolumeCreator.h"

#include "UICommon/UICommon.h"

#include "VideoCommon/OnScreenDisplay.h"
#include "VideoCommon/VideoBackendBase.h"

// Based off various files for the Android port by Sonicadvance1
@implementation DolphinBridge : NSObject

- (void) createUserFolders
{
    NSLog(@"Creating User Folders");
    File::CreateFullPath(File::GetUserPath(D_CONFIG_IDX));
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX));
    //File::CreateFullPath(File::GetUserPath(D_WIIUSER_IDX));
    File::CreateFullPath(File::GetUserPath(D_CACHE_IDX));
    File::CreateFullPath(File::GetUserPath(D_DUMPDSP_IDX));
    File::CreateFullPath(File::GetUserPath(D_DUMPTEXTURES_IDX));
    File::CreateFullPath(File::GetUserPath(D_HIRESTEXTURES_IDX));
    File::CreateFullPath(File::GetUserPath(D_SCREENSHOTS_IDX));
    File::CreateFullPath(File::GetUserPath(D_STATESAVES_IDX));
    File::CreateFullPath(File::GetUserPath(D_MAILLOGS_IDX));
    File::CreateFullPath(File::GetUserPath(D_SHADERS_IDX));
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + USA_DIR DIR_SEP);
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + EUR_DIR DIR_SEP);
    File::CreateFullPath(File::GetUserPath(D_GCUSER_IDX) + JAP_DIR DIR_SEP);
}

- (NSString*) getUserDirectory
{
   return [NSString stringWithCString:File::GetUserPath(D_USER_IDX).c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void) setUserDirectory:(NSString*)userDir
{
    NSLog(@"Setting user directory to %@", userDir);
    std::string directory([userDir cStringUsingEncoding:NSUTF8StringEncoding]);
    UICommon::SetUserDirectory(directory);
}

- (NSString*) getLibraryDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/Dolphin"];
}

- (void) copyResources
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: self.getLibraryDirectory])
    {
        NSLog(@"setting library directory to %@", self.getLibraryDirectory);
        NSError *err = nil;
        if (![fileManager createDirectoryAtPath:self.getLibraryDirectory withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"Error creating library directory: %@", [err localizedDescription]);
        }
    }
    if (![fileManager fileExistsAtPath: [self.getLibraryDirectory stringByAppendingString:@"GC"]])
    {
        NSLog(@"Copying GC folder...");
        [self copyDirectoryOrFile:fileManager :@"GC"];
    }
    if (![fileManager fileExistsAtPath: [self.getLibraryDirectory stringByAppendingString:@"Shaders"]])
    {
        NSLog(@"Copying Shaders folder...");
        [self copyDirectoryOrFile:fileManager :@"Shaders"];
    }
}

- (void) copyDirectoryOrFile:(NSFileManager*)fileMgr :(NSString *)directory
{
    NSString *destination = [self.getLibraryDirectory stringByAppendingString:directory];
    NSString *source = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/"] stringByAppendingString:directory];
    NSLog(@"copyDirectory source: %@", source);
    
    NSError *err = nil;
    if (![fileMgr copyItemAtPath:source toPath:destination error:&err])
    {
        NSLog(@"Error copying directory: %@", [err localizedDescription]);
    }
}

- (void) loadPreferences
{
    //
}

- (void) saveDefaultPreferences
{
    IniFile dolphinConfig;
    dolphinConfig.Load(File::GetUserPath(D_CONFIG_IDX) + "Dolphin.ini");
    //PowerPC::CORE_JITARM64 ,PowerPC::CORE_INTERPRETER
    dolphinConfig.GetOrCreateSection("Core")->Set("CPUCore", PowerPC::CORE_INTERPRETER);
    dolphinConfig.GetOrCreateSection("Core")->Set("CPUThread", "False"); // originally false
    dolphinConfig.GetOrCreateSection("Core")->Set("Fastmem", "False"); // originally false
    dolphinConfig.GetOrCreateSection("Core")->Set("GFXBackend", "SW"); //eventually OGL (CHanging this does nothing, must change in VideoBackendBase.cpp)
    dolphinConfig.GetOrCreateSection("Core")->Set("FrameSkip", "0x00000009");
    dolphinConfig.Save(File::GetUserPath(D_CONFIG_IDX) + "Dolphin.ini");
    
    NSLog(@"%s", (File::GetUserPath(D_CONFIG_IDX) + "Dolphin.ini").c_str());
    
    IniFile oglConfig;
    oglConfig.Load(File::GetUserPath(D_CONFIG_IDX) + "gfx_opengl.ini");
    
    IniFile::Section *oglSettings = oglConfig.GetOrCreateSection("Settings");
    oglSettings->Set("ShowFPS", "False"); // originally false
    oglSettings->Set("EFBScale", "2");
    oglSettings->Set("MSAA", "0");
    oglSettings->Set("EnablePixelLighting", "False"); // originally false
    oglSettings->Set("DisableFog", "False");
    
    IniFile::Section *oglEnhancements = oglConfig.GetOrCreateSection("Enhancements");
    oglEnhancements->Set("MaxAnisotropy", "0");
    //oglEnhancements->Set("PostProcessingShader", "");
    oglEnhancements->Set("ForceFiltering", "False"); // originally false
    oglEnhancements->Set("StereoSwapEyes", "False"); // originally false, not sure why this is true in the Android version
    oglEnhancements->Set("StereoMode", "0");
    oglEnhancements->Set("StereoDepth", "20");
    oglEnhancements->Set("StereoConvergence", "20");
    
    IniFile::Section *oglHacks = oglConfig.GetOrCreateSection("Hacks");
    oglHacks->Set("EFBScaledCopy", "True");
    oglHacks->Set("EFBAccessEnable", "False"); // originally false
    oglHacks->Set("EFBEmulateFormatChanges", "False"); // originally false
    oglHacks->Set("EFBCopyEnable", "True");
    oglHacks->Set("EFBToTextureEnable", "True");
    oglHacks->Set("EFBCopyCacheEnable", "False");
    
    oglConfig.Save(File::GetUserPath(D_CONFIG_IDX) + "gfx_opengl.ini");
}
//
static bool MsgAlert(const char* caption, const char* text, bool /*yes_no*/, int /*Style*/)
{
    NSLog(@"[%s] %s", caption, text);
    return false;
}
//
//// oh my!
- (void) startEmulation
{
    
    NSLog(@"Emulation will now commence!! Setting user dir to: %@", [self getUserDirectory]);
    UICommon::SetUserDirectory([[self getUserDirectory] cStringUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"Registering MsgAlert handler");
    NSLog(@"Calling UICommon::Init()");
    UICommon::Init();
    
    //NSString *starfieldDol = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/"] stringByAppendingString:@"/LuigisMansion.iso"];
    NSString *starfieldDol = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/"] stringByAppendingString:@"/starfield.dol"];
    
    NSLog(@"StarField Path: %@", starfieldDol);
    // No use running the loop when booting fails
    NSLog(@"Booting PowerPC :o");
    if (BootManager::BootCore([starfieldDol UTF8String])) {
        NSLog(@"Boot Started, waiting for run state");
        while (PowerPC::GetState() != PowerPC::CPU_POWERDOWN) {
            // we wait...
        }
        NSLog(@"Core booted");
    } else {
        NSLog(@"Unable to boot");
    }
    //UICommon::Shutdown();
}

@end