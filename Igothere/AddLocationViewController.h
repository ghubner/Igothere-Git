//
//  AddLocationViewController.h
//  GPS
//
//  Created by Gilberto Hubner on 8/30/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShowMapNew.h"
#import "ShowMap.h"
#import "sqlite3.h"
@protocol RefreshTableDelegate <NSObject>

-(void)refreshTable:(NSString *)recordID;

@end
@interface AddLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{

    sqlite3 *appDB;
    sqlite3_stmt *statement;
    CLLocationCoordinate2D  *locationEvent;
    CLLocationManager *currentlocation;
    CLGeocoder *geocoder;
    ShowMap *ann ;
    NSMutableArray *itemsLocationName;
    NSMutableArray *itemsNLat;
    NSMutableArray *itemsNLon;
    NSMutableArray *itemsWLat;
    NSMutableArray *itemsWLon;
    NSMutableArray *itemsSLat;
    NSMutableArray *itemsSLon;
    NSMutableArray *itemsELat;
    NSMutableArray *itemsELon;
    
    NSMutableArray *itemsLocationID;
    NSMutableArray *itemsEventID;
    NSMutableArray *itemsEmailTo;
    NSMutableArray *itemsEmailFrom;
    NSMutableArray *itemsEmailMessageIN;
    NSMutableArray *itemsEmailMessageOUT;

    IBOutlet UIButton *btnAddNew;
    IBOutlet MKMapView *mapViewAdd;
    IBOutlet UITextField *txtAddress;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtState;
    IBOutlet UITextField *txtZip;
    int nTouches;
    IBOutlet UIView *viewAddLocation;
    IBOutlet UIButton *btnCurrentLocation;
    IBOutlet UISegmentedControl *segmentMapMode;
    IBOutlet UIStepper *stepperRect;
}
@property (strong, nonatomic) IBOutlet UIStepper *stepperRect;

@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNew;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentMapMode;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIView *viewAddLocation;

@property (strong, nonatomic) NSString *rectColor;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewAdd;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSString *recordIDResult;
@property (nonatomic,strong)  NSString *fieldText;
@property (nonatomic, strong) NSString *eventLatitude;
@property (nonatomic, strong) NSString *eventLongitude;
@property (strong, nonatomic) NSString *NLat;
@property (strong, nonatomic) NSString *NLon;
@property (strong, nonatomic) NSString *WLat;
@property (strong, nonatomic) NSString *WLon;
@property (strong, nonatomic) NSString *SLat;
@property (strong, nonatomic) NSString *SLon;
@property (strong, nonatomic) NSString *ELat;
@property (strong, nonatomic) NSString *ELon;
@property (nonatomic, assign) float zoomLevel;
@end
