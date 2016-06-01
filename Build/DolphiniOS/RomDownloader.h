//
//  iNDSRomDownloader.h
//  iNDS
//
//  Created by Will Cobb on 11/4/15.
//  Copyright © 2015 iNDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RomDownloader : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property id delegate;

@end
