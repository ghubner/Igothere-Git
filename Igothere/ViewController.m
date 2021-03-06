//
//  ViewController.m
//  youfindme
//
//  Created by Gilberto Hubner on 9/1/14.
//  Copyright (c) 2014 hubner-apps.com. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController
@synthesize txtEmailFrom;
@synthesize txtEmailTo;

@synthesize mapViewDetail;
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
@synthesize viewDetail;
@synthesize rectColor;
@synthesize fieldText;
@synthesize locationName;
@synthesize txtIN;
@synthesize txtOUT;
@synthesize segmentMapMode;
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
    NSString *sql =[NSString stringWithFormat:   @"Select * from Location where locationID='%@'",self.recordIDResult];
    
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            locationName=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 6)];
            NLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 7)];
            NLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 8)];
            WLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 9)];
            WLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,10)];
            SLat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,11)];
            SLon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,12)];
            ELat=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,13)];
            ELon=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,14)];
            txtEmailTo.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,15)];
            txtEmailFrom.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,16)];
            txtIN.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,17)];
            txtOUT.text=fieldText;
        }
    }
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
    [self.mapViewDetail setRegion:region animated:YES];
  //  ann.coordinate = CLLocationCoordinate2DMake(eventLatitude.floatValue, eventLongitude.floatValue);
    [self.mapViewDetail addAnnotation:ann];
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
            self.mapViewDetail.mapType = MKMapTypeSatellite  ;
            break;
        case 1:
            mapType=@"1";
            self.mapViewDetail.mapType = MKMapTypeHybrid ;
            break;
        case 2:
            mapType=@"2";
            self.mapViewDetail.mapType =MKMapTypeStandard ;
            break;
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation

{
    
    static NSString *AnnotationViewID = @"com.invasivecode.pin";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapViewDetail dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    if (annotation==self.mapViewDetail.userLocation)
    {
        return nil;
    }
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
    }
    annotationView.annotation = annotation;
    
    annotationView.canShowCallout=YES;
    
    
    annView.pinColor = MKPinAnnotationColorRed;
    
 //   [annView setAnimatesDrop:YES];
  //  annView.draggable = YES;
    //   annotationView.image = [UIImage imageNamed:geoImage];
    // return annotationView;
    return annView;
}
-(void)viewWillAppear:(BOOL)animated
{

}
-(void)viewDidDisappear:(BOOL)animated
{
    self.mapViewDetail=nil;
}
- (void)viewDidLoad
{
    mapViewDetail.delegate=self;
    self.mapViewDetail.mapType = MKMapTypeSatellite;
    [mapViewDetail removeOverlays:[mapViewDetail overlays]];
    [self readLocation];
    [self mapFixRectView];
    [self locatinPosition];
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
    [self.mapViewDetail addOverlay:polygon];

    float C1 = (NLat.floatValue - SLat.floatValue)/2 +SLat.floatValue;
    float C2 = ( WLon.floatValue -ELon.floatValue)/2 +ELon.floatValue;
    eventLatitude = [NSString stringWithFormat:@"%f",C1 ];
    eventLongitude= [NSString stringWithFormat:@"%f",C2 ];
    
}


- (void)selectAnnotation:(id < MKAnnotation >)annotation animated:(BOOL)animated
{
    for (id <MKAnnotation> anAnnotation in [NSArray arrayWithArray:self.mapViewDetail.annotations]) {
        [self.mapViewDetail removeAnnotation:anAnnotation];
    }
    
}
-(void)mapView:(MKMapView *)MapView regionDidChangeAnimated:(BOOL)animated
{
    
    //  [mapView removeOverlays:[mapView overlays]];
    
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
  //self.mapViewDetail=nil;
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

