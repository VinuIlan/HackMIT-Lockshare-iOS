//
//  ViewController.h
//  SmartLock
//
//  Created by Vinu Ilangovan on 10/4/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController : UIViewController {
    
    MKMapView *mapview;
    
    CLLocationManager *locmanager;
    
    CLLocation *startLoc;
    
    BOOL gotlocation;
    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapview;

@property (nonatomic, strong) IBOutlet UILabel * lockIDLabel;

@property (strong, nonatomic) IBOutlet UIButton *locationLockButton;

@property (strong, nonatomic) IBOutlet UIButton *normalLockButton;

@property (strong, nonatomic) IBOutlet UIButton *permissionsPanelButton;

@property (strong, nonatomic) IBOutlet UIButton *reloadLockIDButton;

@end

