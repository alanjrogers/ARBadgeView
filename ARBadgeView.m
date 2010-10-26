//
//  ARBadgeView.m
//
//  Created by Alan Rogers on 13/09/09.
//  Copyright 2009 Blind Mice Studios. All rights reserved.
//

#import "ARBadgeView.h"

static NSMutableDictionary* badgeImages = nil;

@implementation ARBadgeView

@synthesize badgeNumber = _number;


- (void) createPathForBadgeInFrame:(CGRect)badgeFrame withAdjustment:(CGFloat)adjustment
{
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(theContext);
	CGContextAddArc(theContext, CGRectGetMidX(badgeFrame) + adjustment, CGRectGetMidY(badgeFrame), badgeFrame.size.height/2.0f, -M_PI/2, M_PI/2, 0);
	CGContextAddArc(theContext, CGRectGetMidX(badgeFrame) - adjustment, CGRectGetMidY(badgeFrame), badgeFrame.size.height/2.0f, M_PI/2, -M_PI/2, 0);
	
	CGContextClosePath(theContext);
}


- (void) drawBadgeAtPoint:(CGPoint)centerPoint context:(CGContextRef)theContext
{
	CGContextSaveGState(theContext);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextSetFillColorSpace(theContext, colorSpace);
	
    CGFloat scale = [[UIScreen mainScreen] scale];
        
	const CGSize badgeSize = CGSizeMake(23.0*scale, 23.0*scale);
	const CGSize badgeShadowSize = CGSizeMake(2.0*scale, 3.0*scale);
	
	NSString* const badgeText = [NSString stringWithFormat:@"%lu", self.badgeNumber];
	UIFont* const badgeFont = [UIFont boldSystemFontOfSize:17*scale];
	const CGSize badgeGlyphsBounds = [badgeText sizeWithFont:badgeFont];
	
	CGFloat adjustment = (badgeGlyphsBounds.width - 12*scale)/2.0;
	
	if (badgeGlyphsBounds.width <= 12.0*scale) adjustment = 0.0f;
	const CGPoint badgeTextOrigin = CGPointMake(centerPoint.x-(badgeGlyphsBounds.width)/2.0+badgeShadowSize.width,
												centerPoint.y-(badgeGlyphsBounds.height)/2.0+badgeShadowSize.height);
	
	
    
	
	const CGRect badgeFrame = CGRectMake(centerPoint.x-badgeSize.width/2.0+badgeShadowSize.width - adjustment,
										 centerPoint.y-badgeSize.height/2.0+badgeShadowSize.height,
										 badgeSize.width + adjustment*2,
										 badgeSize.height);
	
	CGColorRef shadowColor = (CGColorRef)CFRetain([[UIColor colorWithWhite:0.0f alpha:0.6f] CGColor]);
	CGContextSetShadowWithColor(theContext, badgeShadowSize, 3.0*scale, shadowColor);
	
	CFRelease(shadowColor);
	
    
	
	CGColorRef outlineColor = (CGColorRef)CFRetain([[UIColor whiteColor] CGColor]);
	
	CGContextBeginTransparencyLayer(theContext, NULL);
    
	{
		CGContextSaveGState(theContext);
		
		[self createPathForBadgeInFrame:badgeFrame withAdjustment:adjustment];		
		
		CGFloat colors[] = {0.978, 0.736, 0.749, 1.0, 0.752, 0.0, 0.0, 1.0};
        CGFloat locations[] = {0, 1};
		
		CGContextClip(theContext);
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        
        
        CGPoint myStartPoint, myEndPoint;
        CGFloat myStartRadius, myEndRadius;
        myStartPoint.x = CGRectGetMidX(badgeFrame);
        myStartPoint.y = CGRectGetMinY(badgeFrame);
        myEndPoint.x = CGRectGetMidX(badgeFrame);
        myEndPoint.y = CGRectGetMaxY(badgeFrame)/4.0;
        myStartRadius = 0;
        myEndRadius = CGRectGetWidth(badgeFrame);
        CGContextDrawRadialGradient (theContext, gradient, myStartPoint,
                                     myStartRadius, myEndPoint, myEndRadius,
                                     kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        
		CGContextRestoreGState(theContext);
        
	}
	
	[self createPathForBadgeInFrame:badgeFrame withAdjustment:adjustment];		
	
	CGContextSetStrokeColorWithColor(theContext, outlineColor);
	CGContextSetLineWidth(theContext, 2.0*scale);
	CGContextStrokePath(theContext);	
    
	CGContextEndTransparencyLayer(theContext);
	
	CGContextSetShadow(theContext, CGSizeZero, 0.0);
	
	CGContextSetFillColorWithColor(theContext, outlineColor);
	[badgeText drawAtPoint:badgeTextOrigin withFont:badgeFont];	
	
	CFRelease(colorSpace);
	
	CGContextRestoreGState(theContext);
    
	CFRelease(outlineColor);
}


- (NSString *)applicationDocumentsDirectory 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void) createImageForBadgeNumber:(NSNumber*)badgeNumber
{
    CGFloat scale = [[UIScreen mainScreen] scale];

	CGRect rect = CGRectMake(0.0f, 0.0f, 52.0*scale, 52.0*scale);
	
	NSString* fileName = [NSString stringWithFormat:@"%lu.png", [badgeNumber unsignedIntegerValue]]; 
	NSString* savePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
	
	UIGraphicsBeginImageContext(rect.size);
	
	[self drawBadgeAtPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)) context:UIGraphicsGetCurrentContext()];

	CGImageRef bitmap = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());

	UIGraphicsEndImageContext();
	// convert the finished image to a UIImage and grab the data
	
	NSData* imageData = UIImagePNGRepresentation([UIImage imageWithCGImage:bitmap]);
	
	// image is retained by the property setting above, so we can 
	// release the original
	CGImageRelease(bitmap);
	
	[imageData writeToFile:savePath atomically:YES];
	
	[badgeImages setObject:savePath forKey:badgeNumber];
}

- (void) setBadgeNumber:(NSUInteger)badgeNumber
{
	_number = badgeNumber;
	
	if (_number == 0)
	{
		self.image = nil;
		return;
	}
	
	if (badgeImages == nil)
	{
		badgeImages = [[NSMutableDictionary dictionary] retain];
	}
	
	NSNumber* badgeValue = [NSNumber numberWithUnsignedInteger:_number];
	
	if ([badgeImages objectForKey:badgeValue] == nil)
	{
		[self createImageForBadgeNumber:badgeValue];
	}
	
	self.image = [UIImage imageWithContentsOfFile:[badgeImages objectForKey:badgeValue]];
}


@end
