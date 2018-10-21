//
//  ViewController.h
//  youfindme
//
//  Created by Gilberto Hubner on 9/1/14.
//  Copyright (c) 2014 hubner-apps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShowMapNew.h"
#import "ShowMap.h"
#import "sqlite3.h"
@interface ViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    CLLocationCoordinate2D  *locationEvent;
    CLLocationManager *currentlocation;
    CLGeocoder *geocoder;
    ShowMap *ann ;
    IBOutlet MKMapView *mapViewDetail;
    NSMutableArray   *arrayCoordinate;

    IBOutlet UIView *viewDetail;
 
    
    IBOutlet UILabel *txtEmailFrom;

    IBOutlet UITextView *txtEmailTo;
 
    IBOutlet UITextView *txtIN;
    IBOutlet UITextView *txtOUT;
    
    IBOutlet UISegmentedControl *segmentMapMode;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentMapMode;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;

@property (strong, nonatomic) IBOutlet UILabel *txtEmailFrom;
@property (strong, nonatomic) IBOutlet UITextView *txtOUT;

@property (strong, nonatomic) IBOutlet UITextView *txtEmailTo;

@property (strong, nonatomic) IBOutlet UITextView *txtIN;



@property (strong, nonatomic) IBOutlet MKMapView *mapViewDetail;

@property (nonatomic, strong) NSArray *annotations;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@property (strong, nonatomic) NSString *rectColor;
@property (nonatomic, strong) NSString *eventLatitude;
@property (nonatomic, strong) NSString *eventLongitude;
@property (nonatomic, strong) NSString *recordIDResult;
@property (nonatomic,strong) NSString *fieldText;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *NLat;
@property (strong, nonatomic) NSString *NLon;
@property (strong, nonatomic) NSString *WLat;
@property (strong, nonatomic) NSString *WLon;
@property (strong, nonatomic) NSString *SLat;
@property (strong, nonatomic) NSString *SLon;
@property (strong, nonatomic) NSString *ELat;
@property (strong, nonatomic) NSString *ELon;


@end

