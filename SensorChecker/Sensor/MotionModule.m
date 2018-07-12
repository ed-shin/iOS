//
//  MotionModule.m
//  SensorChecker
//
//  Created by JPShin on 2018. 3. 16..
//  Copyright © 2018년 Geotwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import "MotionModule.h"

@interface MotionModule ()
{
    //모션센서
    CMMotionManager *m_motionManager;
    //방향센서
    CLLocationManager *m_locationManager;
    //기압센서
    CMAltimeter *m_barometer;
    //근거리센서
    UIDevice *m_proximitySensor;
    
    NSString* file;
}
@end

@implementation MotionModule

-(id) init{
    self = [super init];
    if(self != nil){
        [self onLoad];
    }
    
    return self;
}

-(void) onLoad{
    
    //for motion sensor(acc, gyr, mag)
    m_motionManager = [[CMMotionManager alloc] init];
    
    //for barometer
    m_barometer = [[CMAltimeter alloc] init];
    
    //for heading
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    
    //권한 체크
    if ([m_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [m_locationManager requestWhenInUseAuthorization];
    }
    
    
    //근거리 센서 이벤트 연결
    m_proximitySensor = [UIDevice currentDevice];
    [m_proximitySensor setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximitySensorStateChange:) name:(@"UIDeviceProximityStateDidChangeNotification") object:nil];
}

//Start Motion Sensor
-(void) start:(float)interval{
    
    m_motionManager.deviceMotionUpdateInterval = interval;
    m_motionManager.accelerometerUpdateInterval = interval;
    
    //모션 센서
    if(m_motionManager.deviceMotionAvailable)
    {
        [m_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [self updateMotion:motion];
        }];
        [m_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magData, NSError * _Nullable error) {
            [self updateUncalibratedMag:magData.magneticField];
        }];
        
        [m_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            [self updateAcc:accelerometerData.acceleration];
        }];
    }
    
    //기압 센서
    if([CMAltimeter isRelativeAltitudeAvailable]){
        [m_barometer startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            [self updateAltitude:altitudeData];
        }];
    }
    
    //방향 센서
    [m_locationManager startUpdatingHeading];
}

//Stop Motion Sensor
-(void) stop{
    [m_motionManager stopAccelerometerUpdates];
    [m_motionManager stopMagnetometerUpdates];
    [m_motionManager stopDeviceMotionUpdates];
    [m_barometer stopRelativeAltitudeUpdates];
    [m_locationManager stopUpdatingHeading];
}


//Set Acceleration
-(void)updateAcc:(CMAcceleration)acceleration{
    
    [[self delegate] updateAccelation:acceleration.x :acceleration.y :acceleration.z];
}

//Set Uncalibrated mag
-(void)updateUncalibratedMag:(CMMagneticField)magField{
    
    [[self delegate] updateRawMagnetometer:magField.x :magField.y :magField.z];
}

//Set Gyro, Magnetic field
-(void)updateMotion:(CMDeviceMotion *)motion{
    
    [[self delegate] updateGyroscope:motion.rotationRate.x :motion.rotationRate.y :motion.rotationRate.z];
    [[self delegate] updateMagnetometer:motion.magneticField.field.x :motion.magneticField.field.y :motion.magneticField.field.z];
}

//Set Barometer Sensor Value
-(void) updateAltitude:(CMAltitudeData *)altitudeData{
    
    [[self delegate] updateAltitude:altitudeData.pressure.floatValue];
}

//Set Proximity
-(void) proximitySensorStateChange:(NSNotificationCenter *)notification{
    
    [[self delegate] updateProximity:[m_proximitySensor proximityState]];
//    if([m_proximitySensor proximityState] == YES){
//        [[self delegate] updateProximity:0.0f];
//    }
//    else{
//        [[self delegate] updateProximity:8.0f];
//    }
}

//Set Heading
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    [[self delegate] updateHeading:newHeading.trueHeading: newHeading.magneticHeading: newHeading.headingAccuracy];
}


@end
