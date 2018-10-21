//
//  ViewController.h
//  Igothere
//
//  Created by CRW on 10/1/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShowMapNew.h"
#import "ShowMap.h"
#import "sqlite3.h"
#import <Foundation/Foundation.h>
@interface MainViewController : UIViewController<CLLocationManagerDelegate>
{
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    CLLocationCoordinate2D  *locationEvent;
    CLLocationManager *currentlocation;
    CLGeocoder *geocoder;
    NSMutableArray *itemsMapLocationID;
    NSMutableArray *itemsMapEventID;
    NSMutableArray *itemsAddress;
    NSMutableArray *itemsCity;
    NSMutableArray *itemsZip;
    NSMutableArray *itemsState;
    NSMutableArray *itemsMapNLat;
    NSMutableArray *itemsMapNLon;
    NSMutableArray *itemsMapWLat;
    NSMutableArray *itemsMapWLon;
    NSMutableArray *itemsMapSLat;
    NSMutableArray *itemsMapSLon;
    NSMutableArray *itemsMapELat;
    NSMutableArray *itemsMapELon;
    NSMutableArray *itemsMapEmailTo;
    NSMutableArray *itemsMapEmailFrom;
    NSMutableArray *itemsMapEmailMessageIN;
    NSMutableArray *itemsMapEmailMessageOUT;
    NSMutableArray *itemsMapEmailOUT;
    NSMutableArray *itemsMapLocationName;
    NSTimer *timer;
    IBOutlet UIView *circleView;
    
    IBOutlet UILabel *lblStatus;
    IBOutlet UIImageView *animationImageView;
    IBOutlet UIButton *btnStartStopTracking;
    IBOutlet UILabel *lblSpeed;
  
    IBOutlet UIView *viewAddress;
    
    IBOutlet UITextField *lblLocation;
    IBOutlet UITextField *lblAddress;
    
    IBOutlet UITextField *lblState;
    IBOutlet UITextField *lblCity;
    IBOutlet UITextField *lblZip;
    
}
@property (strong, nonatomic) IBOutlet UITextField *lblLocation;

@property (strong, nonatomic) IBOutlet UIView *viewAddress;

@property (strong, nonatomic) IBOutlet UITextField *lblAddress;
@property (strong, nonatomic) IBOutlet UITextField *lblZip;
@property (strong, nonatomic) IBOutlet UITextField *lblCity;
@property (strong, nonatomic) IBOutlet UITextField *lblState;


@property (strong, nonatomic) IBOutlet UILabel *lblSpeed;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIView *circleView;
@property (strong, nonatomic) IBOutlet UIButton *btnStartStopTracking;
@property (strong, nonatomic) IBOutlet UIImageView *animationImageView;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) NSString *lastDateIN;
@property (strong, nonatomic) UIColor *darkGreen;
@property (strong, nonatomic) NSString *fieldText;
@property (strong, nonatomic) NSString *rectColor;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventLatitude;
@property (strong, nonatomic) NSString *eventLongitude;
@property (strong, nonatomic) NSString *locationRecordID;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *locationAddress;
@property (strong, nonatomic) NSString *NLat;
@property (strong, nonatomic) NSString *NLon;
@property (strong, nonatomic) NSString *WLat;
@property (strong, nonatomic) NSString *WLon;
@property (strong, nonatomic) NSString *SLat;
@property (strong, nonatomic) NSString *SLon;
@property (strong, nonatomic) NSString *ELat;
@property (strong, nonatomic) NSString *ELon;
@property (strong, nonatomic) NSString *emailTo;
@property (strong, nonatomic) NSString *emailFrom;
@property (strong, nonatomic) NSString *emailMessage;
@property (strong, nonatomic) NSString *emailMessageIN;
@property (strong, nonatomic) NSString *emailMessageOUT;
@property (strong, nonatomic) NSString *sentEmailIN;
@property (strong, nonatomic) NSString *sentEmailOUT;
@property (strong, nonatomic) NSString *circleColor;
@property (strong, nonatomic) NSString *startTracking;
@property(readonly, nonatomic) CLLocationSpeed speed;
@property (strong, nonatomic) NSString *dateInOut;
@end
