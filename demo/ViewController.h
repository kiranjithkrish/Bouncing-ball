//
//  ViewController.h
//  demo
//
//  Created by kiranjith on 26/10/14.
//  Copyright (c) 2014 kiranjith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ViewController : UIViewController
{
    ASImageNode * imageNode ;
   // UIImageView *ballImageView;
    BOOL buttonPressed;
    UIButton* gravityButton;
    CGPoint  touchPoint;
    
    
}


@end

