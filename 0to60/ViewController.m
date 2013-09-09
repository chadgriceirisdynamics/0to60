//
//  ViewController.m
//  0to60
//
//  Created by Chad D Grice on 2013-08-26.
//  Copyright (c) 2013 Iris Dynamics Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController{
    CLLocationManager *locationManager;
}


//////// The Pen IS mightier!!!!


- (void)viewDidLoad {
    
    [_currentSpeed setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    [_maxSpeed setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    [_elapsedTime setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    [_toXTime setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    [_qtrTime setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    [_eightTime setFont:[UIFont fontWithName:@"Digital Dream Fat Narrow" size:17]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    NSString *speedOutput = [NSString stringWithFormat:@"%.2f MPH",(currentLocation.speed * 2.23694)];
    NSString *maxOutput = [NSString stringWithFormat:@"%.2f MPH", maxspeed];
    
    
    speedCurrent = [speedOutput intValue];
    currentspeed = [speedOutput doubleValue];
    if (currentspeed > maxspeed){
        maxspeed = currentspeed;
    }
    else {
        
    }
    //starts timer void
    if ((speedCurrent > 0) && (systemIsArmed == 1)){
        systemIsArmed = 2;
        [self startRun];
    }
    //stops timer at 60 mph
    if ((speedCurrent >= 60) && (systemIsArmed == 2)){
        systemIsArmed = 0;
        [self timeToX];
    }
    //gets starting position to determin distance from it
    if (startPosition == 1) {
        startPosition = 2;
    
        NSString *startLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *startLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        x1 = [startLong doubleValue];
        y11 = [startLat doubleValue];
        NSLog(@"%f",x1);
        NSLog(@"%f",y11);

    }
    //gives current position
    if ((currentLocation != nil) && (startPosition == 2)) {
        NSString *currentLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *currentLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        x2 = [currentLong doubleValue];
        y2 = [currentLat doubleValue];
    }
    //calculates distance from start point and curent point. 
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:y11 longitude:x1];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:y2 longitude:x2];
    NSLog(@"Distance i feet: %f", ([location1 distanceFromLocation:location2])*3.28084);
    distanceInFeet = ([location1 distanceFromLocation:location2]) * 3.28084;
    //when distance is eight mile stops time
    if ((distanceInFeet >= 660) && (eightArmed == 1)) {
        eightArmed = 0;
        [self eightMileTime];
    }
    //when distance is quarter mile stops time
    if ((distanceInFeet >= 1320) && (qrtArmed == 1)) {
        qrtArmed = 0;
        [self qtrMileTime];
    }
    
    speedCurrent = [speedOutput intValue];
    self.currentSpeed.text = speedOutput;
    self.maxSpeed.text = maxOutput;
    
    //stops things when data is collected and vehicle slows at least 5mph less than max speed
    if (maxspeed > (currentspeed + 5)) {
        [countUpTimer invalidate];
    }
}


- (IBAction)start:(id)sender {
    mainInt = 0;
    maxspeed = 0;
    systemIsArmed = 1;
    startPosition = 1;
    eightArmed = 1;
    qrtArmed = 1;
}

- (IBAction)stopTest:(id)sender {
    [countUpTimer invalidate];
   
}

- (void) startRun {
    countUpTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    start = [NSDate date];
}

- (void) timerRun {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:start];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    timeString = nil;
    
    mainInt = mainInt + 1;
    int seconds = mainInt / 10;
    int milliSeconds = mainInt - (seconds * 10);
    
    NSString *timerOUtput = [NSString stringWithFormat:@"%.2d.%.1d", seconds,milliSeconds];
    self.elapsedTime.text = timerOUtput;
   
}

- (void) timeToX {
    xStop = [NSDate date];
    NSTimeInterval timeInterval = [xStop timeIntervalSinceDate:start];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.toXTime.text = timeString;
}

- (void) qtrMileTime {
    qtrStop = [NSDate date];
    NSTimeInterval timeInterval = [qtrStop timeIntervalSinceDate:start];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.qtrTime.text = timeString;
}

-(void) eightMileTime {
    eightStop = [NSDate date];
    NSTimeInterval timeInterval = [eightStop timeIntervalSinceDate:start];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.eightTime.text = timeString;
}


@end
