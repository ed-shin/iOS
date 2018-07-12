//
//  ViewController.m
//  SensorChecker
//
//  Created by JPShin on 2018. 3. 16..
//  Copyright © 2018년 Geotwo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    MotionModule* m_motion;
    Boolean m_proximity;
    double m_acc[3];
    double m_gyr[3];
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    m_motion = [[MotionModule alloc] init];
    m_motion.delegate = self;
    [m_motion start:0.2f];
    
    m_proximity = false;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateAccelation:(double)x :(double)y :(double)z{
    
    m_acc[0] = x;
    m_acc[1] = y;
    m_acc[2] = z;
    
    _labelAcc.text = [NSString stringWithFormat:@"x: %.2f\ny: %.2f\nz: %.2f", x, y, z];
    
    [self updateStatus];
}

-(void)updateGyroscope:(double)x :(double)y :(double)z{
    
    m_gyr[0] = x;
    m_gyr[1] = y;
    m_gyr[2] = z;
    
    _labelGyr.text = [NSString stringWithFormat:@"x: %.2f\ny: %.2f\nz: %.2f", x, y, z];
}

-(void)updateMagnetometer:(double)x :(double)y :(double)z{
    
    _labelMag.text = [NSString stringWithFormat:@"x: %.2f\ny: %.2f\nz: %.2f", x, y, z];
}

-(void)updateRawMagnetometer:(double)x :(double)y :(double)z{
    
}

-(void)updateProximity:(Boolean)state{
    m_proximity = state;
}

-(void)updateHeading:(double)trueHeading :(double)magHeading :(double)headingAccuracy{
    
    _labelHeading.text = [NSString stringWithFormat:@"true %.2f\nmag: %.2f\naccuracy: %.2f", trueHeading, magHeading, headingAccuracy];
}

-(void)updateAltitude:(double)altitude{
    
}

-(void)updateStatus{
    
    NSString* window = @"";
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
        window = @"protrait";
    }
    else{
        window = @"landscape";
    }
    
    NSString* orientation = @"";
    if(fabs(m_acc[0]) > fabs(m_acc[1])){
        orientation = @"landscape";
    }
    else{
        orientation = @"portrait";
    }
    
    NSString* swing = @"";
    if(fabs(m_gyr[0]) > 2 || fabs(m_gyr[1]) > 2 || fabs(m_gyr[2]) > 2){
        swing = @"swing";
    }
    else{
        swing = @"stop";
    }
    
    _labelState.text = @"";
    _labelState.text = [_labelState.text stringByAppendingString:[NSString stringWithFormat:@"window: %@\n", window]];
    _labelState.text = [_labelState.text stringByAppendingString:[NSString stringWithFormat:@"orientation: %@\n", orientation]];
    _labelState.text = [_labelState.text stringByAppendingString:[NSString stringWithFormat:@"swing: %@", swing]];
}

@end
