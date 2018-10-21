//
//  ReportDetailViewController.h
//  Igothere
//
//  Created by Gilberto Hubner on 9/27/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShowMapNew.h"
#import "ShowMap.h"
#import "sqlite3.h"
@interface ReportDetailViewController : UIViewController <MKMapViewDelegate>
{

    CLGeocoder *geocoder;
     ShowMap *ann ;
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    IBOutlet MKMapView *mapViewReportDetail;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapViewReportDetail;

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
