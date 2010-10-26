//
//  ARBadgeViewDemoViewController.h
//  ARBadgeViewDemo
//
//  Created by Alan Rogers on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARBadgeView;

@interface ARBadgeViewDemoViewController : UIViewController 
{
    ARBadgeView* _badgeView;
}

@property (nonatomic, retain) IBOutlet ARBadgeView* badgeView;

@end

