//
//  ViewController.m
//  demo
//
//  Created by kiranjith on 26/10/14.
//  Copyright (c) 2014 kiranjith. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {

    {
 
        [super viewDidLoad];
    
        
        buttonPressed = YES;
        gravityButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 20, 150, 40)];
        gravityButton.backgroundColor = [ UIColor blackColor];
        [self.view addSubview:gravityButton];
        
        gravityButton.titleLabel.textColor = [UIColor whiteColor];
        [gravityButton setTitle:@"Impart Gravity" forState:UIControlStateNormal];
        [ gravityButton addTarget:self action:@selector(gravityButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
// With Nodes
        
        
        imageNode = [[ASImageNode alloc]init];
        imageNode.image = [UIImage imageNamed:@"ball.png"];
        imageNode.frame = CGRectMake(0.f, 0.0f, 60.0f, 60.0f);
        [self.view addSubview:imageNode.view];
        [self addBounceAnimationWithoutGravityForLayer:imageNode.layer];
        
//Without Nodes
    
       // UIImage *ballImage = [UIImage imageNamed:@"ball.png"];
        //ballImageView.frame = CGRectMake(10.f, 60, 60.0f, 60.0f);
        //ballImageView = [[UIImageView alloc] initWithImage:ballImage];
        // [self.view addSubview:ballImageView];
        //  [self addFallAnimationForLayer:ballImageView.layer];
        
        
    }

}

//Button to select between gravity and no gravity
-(void)gravityButtonPressed
{
    
    if (buttonPressed)
    {
        [gravityButton setTitle:@"Remove Gravity" forState:UIControlStateNormal];
        buttonPressed = NO;
        [self addBounceAnimationWithGravityForLayer:imageNode.layer];

        
    }else
    {
        [gravityButton setTitle:@"Impart Gravity" forState:UIControlStateNormal];
        buttonPressed = YES;
        imageNode.frame = CGRectMake(10, 0, 60.0f, 60.0f);
        [self addBounceAnimationWithoutGravityForLayer:imageNode.layer];
        
        
    }
    
}

//Move the ball to the touch points
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    imageNode.frame = CGRectMake(touchLocation.x, touchLocation.y, 60.0f, 60.0f);
    touchPoint = touchLocation
    ;
    
    
    if (!buttonPressed)
    {
        [self addBounceAnimationWithGravityForLayer:imageNode.layer];
        
    }
    else
    {
        imageNode.frame = CGRectMake(touchPoint.x, 0, 60.0f, 60.0f);
        
        [self addBounceAnimationWithoutGravityForLayer:imageNode.layer];
        
    }
    
    
    
}

- (void)addBounceAnimationWithoutGravityForLayer:(CALayer *)layer{
    

    NSString *keyPath = @"transform.translation.y";
    

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    
    animation.duration = 1.5f;
    animation.repeatCount = HUGE_VAL;
    
     animation.autoreverses = YES;
    
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    

    // The animation start
    [values addObject:[NSNumber numberWithFloat:0.0f]];
    

    // The animation finish
  
    CGFloat height;
    if (buttonPressed) {
        height = [[UIScreen mainScreen] applicationFrame].size.height - imageNode
        .frame.size.height/2;
    }else
    {
        height = (self.view.frame.size.height- touchPoint.y) - imageNode.frame.size.height;
    }
    
    [values addObject:[NSNumber numberWithFloat:height]];
    
    
    animation.values = values;
    
    [layer addAnimation:animation forKey:keyPath];
    

}



- (void)addBounceAnimationWithGravityForLayer:(CALayer *)layer
{
     NSString *keyPath = @"transform";
   
    CGFloat initialMomentum = 400.0f;
    
    CGFloat gravityConstant = 200.0f;
    CGFloat dampeningFactorPerBounce = 0.8;
    
    CGFloat momentum = initialMomentum;
    CGFloat positionOffset = 0;
    
    
    CGFloat slicesPerSecond = 60.0f;
   
    CGFloat lowerMomentumCutoff = 5.0f;

 layer.frame= CGRectMake(touchPoint.x , self.view.frame.size.height-60, 60.0f, 60.0f);

    CGFloat duration = 0;
    NSMutableArray *values = [NSMutableArray array];
    
    do
    {
              duration = duration + 1.0f/slicesPerSecond;
        positionOffset= positionOffset + momentum/slicesPerSecond;
        
        if (positionOffset<0)
        {
            positionOffset=0;
            momentum =-momentum*dampeningFactorPerBounce;
        }
        
     
        momentum = momentum - gravityConstant/slicesPerSecond;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
        [values addObject:[NSValue valueWithCATransform3D:transform]];
        

    } while (!(positionOffset==0 && momentum < lowerMomentumCutoff));
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath
                                    ];
    animation.repeatCount = 1;
    animation.duration = duration;
   // animation.fillMode = kCAFillModeForwards;
    
    // Set the values that should be interpolated during the animation
    animation.values = values;
   // animation.removedOnCompletion = YES;
    
    animation.autoreverses = NO;
    
    [layer addAnimation:animation forKey:@"transform.translation.y"];
    
;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
