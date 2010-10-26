//
//  ARBadgeViewDemoAppDelegate.h
//  ARBadgeViewDemo
//
//  Created by Alan Rogers on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARBadgeViewDemoViewController;

@interface ARBadgeViewDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ARBadgeViewDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ARBadgeViewDemoViewController *viewController;

@end

