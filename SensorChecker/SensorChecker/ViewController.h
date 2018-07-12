//
//  ViewController.h
//  SensorChecker
//
//  Created by JPShin on 2018. 3. 16..
//  Copyright © 2018년 Geotwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionModule.h"

@interface ViewController : UIViewController <SensorStateDelegate>


@property (weak, nonatomic) IBOutlet UILabel *labelAcc;
@property (weak, nonatomic) IBOutlet UILabel *labelGyr;
@property (weak, nonatomic) IBOutlet UILabel *labelMag;
@property (weak, nonatomic) IBOutlet UILabel *labelHeading;
@property (weak, nonatomic) IBOutlet UILabel *labelState;


@end

