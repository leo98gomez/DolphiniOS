//
//  ViewController.m
//  DolphiniOS
//
//  Created by Will Cobb on 5/20/16.
//
//

#import "ViewController.h"
#import "DolphinBridge.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#include "Common/GL/GLInterfaceBase.h"

@interface ViewController () <GLKViewDelegate> {
    DolphinBridge *bridge;
    
    GLuint texHandle[1];
    GLint attribPos;
    GLint attribTexCoord;
    GLint texUniform;
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

GLKView *v;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glkView = [[GLKView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width * 0.75)];
    [self.view addSubview:self.glkView];
    
    v = self.glkView;
    v.delegate = self;
    
    NSLog(@"Loaded %@", self.glkView.delegate);
    // Do any additional setup after loading the view, typically from a nib.
    bridge = [DolphinBridge new];
    
    NSString *userDir = [bridge getUserDirectory];
    
    if (userDir.length == 0)
    {
        // let's setup everything
        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        [bridge setUserDirectory:[docDir stringByAppendingString:@"/Dolphin"]];
        [bridge createUserFolders];
        [bridge copyResources];
        [bridge saveDefaultPreferences];
    }
    [bridge startEmulation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void* Host_GetRenderHandle()
{
    printf("Asking for window handle\n");
    return (__bridge void*)v;
}

@end
