//
//  ReportDetailViewController.m
//  Igothere
//
//  Created by Gilberto Hubner on 9/27/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "ReportDetailViewController.h"

@interface ReportDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblLocationName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentMapMode;
@property (strong, nonatomic) IBOutlet UILabel *lblDateIN;
@property (strong, nonatomic) IBOutlet UILabel *lblDateOUT;


@end

@implementation ReportDetailViewController
@synthesize NLat;
@synthesize NLon;
@synthesize WLat;
@synthesize WLon;
@synthesize SLat;
@synthesize SLon;
@synthesize ELat;
@synthesize ELon;
@synthesize eventLatitude;
@synthesize eventLongitude;
@synthesize annotations = _annotations;
@synthesize rectColor;
@synthesize fieldText;
@synthesize locationName;
@synthesize segmentMapMode;
@synthesize mapViewReportDetail;
@synthesize recordIDResult;
-(NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"hubner-Apps.sqlite"];
}
-(void) openDB {
    //---create database---
    if (sqlite3_open([[self filePath] UTF8String], &appDB) != SQLITE_OK )
    {
       
    }
}
-(void)checkNULL:(char *)aChar
{
    if (aChar == NULL)
    {
        fieldText=@"";
    }
    else
    {
        fieldText=[NSString stringWithUTF8String:aChar];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)readLocation
{
    [self openDB];
    NSString *sql =[NSString stringWithFormat:@"select * from Event as a,Location as b where a.locationID=b.locationID and a.EventID=%@",self.recordIDResult];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
 
            [self checkNULL:(char *)sqlite3_column_text(statement , 2)];
            self.lblDateIN.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 3)];
            self.lblDateOUT.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 11)];
            self.lblLocationName.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 16)];
            NLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 17)];
            NLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 18)];
            WLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 19)];
            WLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,20)];
            SLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,21)];
            SLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,22)];
            ELat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,23)];
            ELon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,24)];

        }
    }
  // sqlite3_close(appDB);
}
-(void)locatinPosition
{
    
    MKCoordinateRegion region= { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.span.longitudeDelta =0.01f;
    region.span.latitudeDelta = 0.01f;
    ann = [[ShowMap alloc] init];
    region.center.latitude  = eventLatitude.floatValue;
    region.center.longitude =  eventLongitude.floatValue;
    ann.title=locationName;
    ann.coordinate = region.center;
    [self.mapViewReportDetail setRegion:region animated:YES];
    //  ann.coordinate = CLLocationCoordinate2DMake(eventLatitude.floatValue, eventLongitude.floatValue);
    [self.mapViewReportDetail addAnnotation:ann];
}
- (IBAction)btnBack:(id)sender {
     [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)mapModeChanged:(id)sender {
    NSString *mapType=@"";
    switch (self.segmentMapMode.selectedSegmentIndex)
    {
        case 0:
            mapType=@"0";
            self.mapViewReportDetail.mapType = MKMapTypeSatellite  ;
            break;
        case 1:
            mapType=@"1";
            self.mapViewReportDetail.mapType = MKMapTypeHybrid ;
            break;
        case 2:
            mapType=@"2";
            self.mapViewReportDetail.mapType =MKMapTypeStandard ;
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.mapViewReportDetail.delegate=self;
    self.mapViewReportDetail.mapType = MKMapTypeSatellite;
    [mapViewReportDetail removeOverlays:[mapViewReportDetail overlays]];
    [self readLocation];
    [self mapFixRectView];
    [self locatinPosition];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.mapViewReportDetail =nil;
}


-(void)mapFixRectView
{
    
    // Convert Degree to Radian and move the needle
    
    
    float N1point = NLat.floatValue;
    float N2point = NLon.floatValue;
    float W1point = WLat.floatValue;
    float W2point = WLon.floatValue;
    float S1point = SLat.floatValue;
    float S2point = SLon.floatValue;
    float E1point = ELat.floatValue;
    float E2point = ELon.floatValue;
    
    CLLocationCoordinate2D rect[5];
    rect[0] = CLLocationCoordinate2DMake(N1point, N2point);
    rect[1] = CLLocationCoordinate2DMake(W1point, W2point);
    rect[2] = CLLocationCoordinate2DMake(S1point, S2point);
    rect[3] = CLLocationCoordinate2DMake(E1point, E2point);
    rect[4] = CLLocationCoordinate2DMake(N1point, N2point);
    MKPolygon *polygon =[MKPolygon polygonWithCoordinates:rect count:5];
    rectColor=@"Green";
    polygon.title = locationName;
    [self.mapViewReportDetail addOverlay:polygon];
    
    float C1 = (NLat.floatValue - SLat.floatValue)/2 +SLat.floatValue;
    float C2 = ( WLon.floatValue -ELon.floatValue)/2 +ELon.floatValue;
    eventLatitude = [NSString stringWithFormat:@"%f",C1 ];
    eventLongitude= [NSString stringWithFormat:@"%f",C2 ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id < MKOverlay >)overlay
{
    
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    if ([rectColor isEqualToString:@"Yellow"])
    {
        renderer.strokeColor = [UIColor yellowColor];
        renderer.lineWidth = 3.0;
    }
    else
    {
        renderer.strokeColor = [UIColor greenColor];
        renderer.lineWidth = 5.0;
    }
    
    return renderer;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    
    polygonView.lineWidth = 0.3;
    polygonView.strokeColor = [UIColor redColor];
    
    polygonView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    return polygonView;
    
    
    /* circle
     
     MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
     circleView.strokeColor = [UIColor whiteColor];
     circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
     
     return circleView ;
     */
}

- (void)dealloc
{
    [self unloadViewData];
    
}


- (void) unloadViewData
{
    // undo everything created in loadView and viewDidLoad
    // called from dealloc and viewDidUnload so has to be defensive
    
    // Release the textures array
    self.mapViewReportDetail=nil;
    
    
}

@end
