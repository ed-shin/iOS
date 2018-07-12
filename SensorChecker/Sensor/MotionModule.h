//
//  MotionModule.h
//  SensorChecker
//
//  Created by JPShin on 2018. 3. 16..
//  Copyright © 2018년 Geotwo. All rights reserved.
//

#ifndef MotionModule_h
#define MotionModule_h


#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@protocol SensorStateDelegate

@optional
-(void) updateAccelation:(double)x :(double)y :(double)z;
-(void) updateGyroscope:(double)x :(double)y :(double)z;
-(void) updateMagnetometer:(double)x :(double)y :(double)z;
-(void) updateRawMagnetometer:(double)x :(double)y :(double)z;
-(void) updateHeading:(double)trueHeading: (double)magHeading: (double)headingAccuracy;
-(void) updateAltitude:(double)altitude;
-(void) updateProximity:(Boolean)state;

@end


@interface MotionModule : NSObject <CLLocationManagerDelegate>

-(void) start:(float) interval;
-(void) stop;

@property (weak, nonatomic) id <SensorStateDelegate> delegate;

@end

#endif /* MotionModule_h */
