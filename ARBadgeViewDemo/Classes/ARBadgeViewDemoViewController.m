//
//  ARBadgeViewDemoViewController.m
//  ARBadgeViewDemo
//
//  Created by Alan Rogers on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ARBadgeViewDemoViewController.h"

#import "ARBadgeView.h"

@implementation ARBadgeViewDemoViewController

@synthesize badgeView = _badgeView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.badgeView.badgeNumber = 2;
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
