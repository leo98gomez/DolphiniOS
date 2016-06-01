//
//  ViewController.m
//  DolphiniOS
//
//  Created by Will Cobb on 5/20/16.
//
//

#import "EmulatorViewController.h"
#import "DolphinBridge.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#include "Common/GL/GLInterfaceBase.h"
#import "DolphinGame.h"

@interface EmulatorViewController () <GLKViewDelegate> {
    DolphinBridge *bridge;
    
    GLuint texHandle[1];
    GLint attribPos;
    GLint attribTexCoord;
    GLint texUniform;
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation EmulatorViewController

GLKView *v;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [self currentScreenSizeAlwaysLandscape:YES];
    CGSize emulatorSize = CGSizeMake(screenSize.height * 1.33333, screenSize.height);
    self.glkView = [[GLKView alloc] initWithFrame:CGRectMake((screenSize.width - emulatorSize.width)/2, 0, emulatorSize.width, emulatorSize.height)];
    [self.view addSubview:self.glkView];
    
    v = self.glkView;
    v.delegate = self;
    
    NSLog(@"Loaded %@", self.glkView.delegate);
    // Do any additional setup after loading the view, typically from a nib.
    bridge = [DolphinBridge new];
}

- (void)launchGame:(DolphinGame *)game
{
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
    NSLog(@"Bridge %@", bridge);
    [bridge openRomAtPath:game.path];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(CGSize)currentScreenSizeAlwaysLandscape:(BOOL)portrait
{
    if (!portrait)
        return [UIScreen mainScreen].bounds.size;
    //Get portrait size
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    if (![self isPortrait]){
        return CGSizeMake(width, height);
    }
    return CGSizeMake(height, width);
}

-(BOOL) isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
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
