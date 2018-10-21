//
//  AddLocationViewController.m
//  GPS
//
//  Created by Gilberto Hubner on 8/30/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import "AddLocationViewController.h"
#import "InsertViewController.h"
#define kGeoCodingString @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f"
@interface AddLocationViewController ()

@end

@implementation AddLocationViewController
@synthesize stepperRect;
@synthesize delegate;
@synthesize segmentMapMode;
@synthesize btnCurrentLocation;
@synthesize btnAddNew;
@synthesize viewAddLocation;
@synthesize fieldText;
@synthesize recordIDResult;
@synthesize mapViewAdd;
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
@synthesize txtAddress;
@synthesize geocoder;
@synthesize txtCity;
@synthesize txtState;
@synthesize txtZip;
@synthesize rectColor;
@synthesize zoomLevel;


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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return true;
}

- (NSString*)textClear:(NSString *)textFormat
{
    textFormat=[NSString stringWithFormat:@"%@",textFormat ];
    
    if ([textFormat isEqualToString:@"<null>"] || [textFormat isEqualToString:@"(null)"])
    {
        textFormat=@"";
    }
    return textFormat;
}

- (IBAction)btnClose:(id)sender {
    if([delegate respondsToSelector:@selector(refreshTable:)])
    {
        //send the delegate function with the amount entered by the user
        [delegate refreshTable:[NSString stringWithFormat:@"%@", self.recordIDResult]];
    }
     [self dismissViewControllerAnimated:TRUE completion:nil];
}


- (IBAction)btnAdd:(id)sender {
    viewAddLocation.hidden=FALSE;
    [self performSegueWithIdentifier:@"ShowInsert" sender:self];
}




- (NSString*)convertHTML:(NSString *)textFormat
    {
        
        
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"<" withString:@"%3c"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@">" withString:@"%3e"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"{" withString:@"%7b"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"}" withString:@"%7d"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"|" withString:@"%7c"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"^" withString:@"%5e"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"~" withString:@"%7e"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"[" withString:@"%5b"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"]" withString:@"%5d"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"`" withString:@"%60"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"," withString:@"%2c"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"*" withString:@"%2a"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\r\n" withString:@"%0d"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\r" withString:@"%0d"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\n" withString:@"%0d"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
        NSString *str = @"\"";
        NSString *quotes =[str substringWithRange:NSMakeRange(0, 1)];
        textFormat= [self textClear:[NSString stringWithFormat:@"%@",textFormat ]];
        textFormat=[textFormat stringByReplacingOccurrencesOfString: quotes withString:@"%22"];
        str=@"\\";
        NSString *backSlash = [str substringWithRange:NSMakeRange(0, 1)];
        textFormat=[textFormat stringByReplacingOccurrencesOfString:backSlash withString:@"%5c"];
        return textFormat;
}

- (IBAction)stepperRectChange:(id)sender {
    [mapViewAdd removeOverlays:[mapViewAdd overlays]];
    [self mapRectView];
    rectColor=@"Green";
    [self mapFixRectView:rectColor];

}

-(void)makeRect:(NSString *)lineColor
{
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
    rectColor=lineColor;
    polygon.title = @"Select Location";
    [self.mapViewAdd addOverlay:polygon];
}
-(void)mapRectView
{

    for (int ii=0; ii < itemsLocationID.count; ii++)
    {
        self.NLat  = [NSString stringWithFormat:@"%@",[itemsNLat objectAtIndex:ii]];
        self.NLon  = [NSString stringWithFormat:@"%@",[itemsNLon objectAtIndex:ii]];
        self.WLat  = [NSString stringWithFormat:@"%@",[itemsWLat objectAtIndex:ii]];
        self.WLon  = [NSString stringWithFormat:@"%@",[itemsWLon objectAtIndex:ii]];
        self.SLat  = [NSString stringWithFormat:@"%@",[itemsSLat objectAtIndex:ii]];
        self.SLon  = [NSString stringWithFormat:@"%@",[itemsSLon objectAtIndex:ii]];
        self.ELat  = [NSString stringWithFormat:@"%@",[itemsELat objectAtIndex:ii]];
        self.ELon  = [NSString stringWithFormat:@"%@",[itemsELon objectAtIndex:ii]];
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
        rectColor=@"Yellow";
         polygon.title = @"Select Location";
        [self.mapViewAdd addOverlay:polygon];
     //   float C1 = (NLat.floatValue - SLat.floatValue)/2 +SLat.floatValue;
      //  float C2 = ( WLon.floatValue -ELon.floatValue)/2 +ELon.floatValue;
        
      //  ann.title  = @"NORTH";
      //  ann = [[ShowMap alloc] init];
      //  ann.coordinate = CLLocationCoordinate2DMake(C1, C2);
       // [self.mapViewAdd addAnnotation:ann];
    }
}
-(void)mapFixRectView:(NSString *)lineColor
{

    
    self.btnAddNew.enabled=TRUE;
    float radius=0.00005  * self.stepperRect.value;
    float C1 = eventLatitude.floatValue;
    float C2 = eventLongitude.floatValue;
    
    float Npoint = C1 + radius;
    float Spoint = C1 - radius;
    float Wpoint = C2 + radius;
    float Epoint = C2 - radius;
    NSLog(@"%f %f %f %f ",Npoint,Spoint,Wpoint,Epoint);
    
    CLLocationCoordinate2D rect2[5];
    rect2[0] = CLLocationCoordinate2DMake(Npoint, Epoint);
    rect2[1] = CLLocationCoordinate2DMake(Npoint, Wpoint);
    rect2[2] = CLLocationCoordinate2DMake(Spoint, Wpoint);
    rect2[3] = CLLocationCoordinate2DMake(Spoint, Epoint);
    rect2[4] = CLLocationCoordinate2DMake(Npoint, Epoint);
    MKPolygon *polygon1 =[MKPolygon polygonWithCoordinates:rect2 count:5];
    rectColor=lineColor;
    [self.mapViewAdd addOverlay:polygon1];
    NLat = [NSString stringWithFormat:@"%f", Npoint];
    NLon = [NSString stringWithFormat:@"%f", Epoint];
    WLat = [NSString stringWithFormat:@"%f", Npoint];
    WLon = [NSString stringWithFormat:@"%f", Wpoint];
    SLat = [NSString stringWithFormat:@"%f", Spoint];
    SLon = [NSString stringWithFormat:@"%f", Wpoint];
    ELat = [NSString stringWithFormat:@"%f", Spoint];
    ELon = [NSString stringWithFormat:@"%f", Epoint];
//    ann.title  = @"NORTH";
//    ann.coordinate = CLLocationCoordinate2DMake(Npoint, C2);
//    [self.mapView addAnnotation:ann];
//    ann.title=txtAddress.text;
   
}

-(void)readLocations
{
    [self openDB];
    itemsLocationID = [[NSMutableArray alloc] init];
    itemsEventID= [[NSMutableArray alloc] init];
    itemsNLat = [[NSMutableArray alloc] init];
    itemsNLon = [[NSMutableArray alloc] init];
    itemsWLat = [[NSMutableArray alloc] init];
    itemsWLon = [[NSMutableArray alloc] init];
    itemsSLat = [[NSMutableArray alloc] init];
    itemsSLon = [[NSMutableArray alloc] init];
    itemsELat = [[NSMutableArray alloc] init];
    itemsELon = [[NSMutableArray alloc] init];
    itemsEmailTo = [[NSMutableArray alloc] init];
    itemsEmailFrom  = [[NSMutableArray alloc] init];
    itemsEmailTo  = [[NSMutableArray alloc] init];
    itemsEmailMessageIN= [[NSMutableArray alloc] init];
    itemsEmailMessageOUT= [[NSMutableArray alloc] init];
    itemsLocationID= [[NSMutableArray alloc] init];
        NSString *sql =[NSString stringWithFormat:@"Select * from Location where enableLocation=1"];
    
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement , 0)];
            [itemsLocationID addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            [itemsLocationName addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 6)];
            [itemsNLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 7)];
            [itemsNLon   addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 8)];
            [itemsWLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 9)];
            [itemsWLon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,10)];
            [itemsSLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,11)];
            [itemsSLon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,12)];
            [itemsELat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,13)];
            [itemsELon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,14)];
            [itemsEmailTo addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,15)];
            [itemsEmailFrom addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,16)];
            [itemsEmailMessageIN addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,17)];
            [itemsEmailMessageOUT addObject: fieldText];
        }
    }
 //   sqlite3_close(appDB);
}
-(void)mapFixRectView
{
    ann = [[ShowMap alloc] init];
    for (int ii=0; ii < itemsLocationID.count; ii++)
    {
        self.NLat  = [NSString stringWithFormat:@"%@",[itemsNLat objectAtIndex:ii]];
        self.NLon  = [NSString stringWithFormat:@"%@",[itemsNLon objectAtIndex:ii]];
        self.WLat  = [NSString stringWithFormat:@"%@",[itemsWLat objectAtIndex:ii]];
        self.WLon  = [NSString stringWithFormat:@"%@",[itemsWLon objectAtIndex:ii]];
        self.SLat  = [NSString stringWithFormat:@"%@",[itemsSLat objectAtIndex:ii]];
        self.SLon  = [NSString stringWithFormat:@"%@",[itemsSLon objectAtIndex:ii]];
        self.ELat  = [NSString stringWithFormat:@"%@",[itemsELat objectAtIndex:ii]];
        self.ELon  = [NSString stringWithFormat:@"%@",[itemsELon objectAtIndex:ii]];
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
        rectColor=@"Yellow";
        polygon.title = @"Select Location";
        [self.mapViewAdd addOverlay:polygon];
        float C1 = (NLat.floatValue - SLat.floatValue)/2 +SLat.floatValue;
        float C2 = ( WLon.floatValue -ELon.floatValue)/2 +ELon.floatValue;
        //  ann.title  = @"NORTH";
        ann.coordinate = CLLocationCoordinate2DMake(C1, C2);
        [self.mapViewAdd addAnnotation:ann];
    }
}
-(void)currentLocation
{
    geocoder = [[CLGeocoder alloc] init];
    currentlocation = [[CLLocationManager alloc] init];
    currentlocation.desiredAccuracy = kCLLocationAccuracyBest;
    currentlocation.delegate = self;
    [currentlocation startUpdatingLocation];
    [self.mapViewAdd setShowsUserLocation:YES];
    MKCoordinateRegion region= { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    zoomLevel=0.001 * self.stepperRect.value;
    int zoom=self.stepperRect.value;
    zoom=0.001;
    region.span.longitudeDelta =zoom;
    region.span.latitudeDelta = zoom;
    ann = [[ShowMap alloc] init];
    region.center.latitude  =   currentlocation.location.coordinate.latitude;
    region.center.longitude =  currentlocation.location.coordinate.longitude;
  //  self.latitude.text=[ NSString stringWithFormat:@"%f",currentlocation.location.coordinate.latitude ];
  //  self.longitude.text=[ NSString stringWithFormat:@"%f",currentlocation.location.coordinate.longitude ];
    ann.title=@"Current Location";
    ann.coordinate = region.center;
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    //   BOOL locationAvailable = currentlocation.location !=nil;
    
    if (locationAllowed==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for igothere app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else
    {
        if(region.center.latitude == 0 || region.center.longitude ==0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service is not Activate"
                                                            message:@"To Activate, please go to  Settings and turn on Activate Current Location."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }else
        {
            [self.mapViewAdd setRegion:region animated:YES];
            CLLocationCoordinate2D  locationEventMap;

            region.center.latitude  = locationEventMap.latitude;
            region.center.longitude = locationEventMap.longitude ;
            [self getAddressFromLatLon:currentlocation.location.coordinate.latitude withLongitude:currentlocation.location.coordinate.longitude];
        }
    }
}
- (IBAction)dropPin:(id)sender {
    self.btnAddNew.enabled=TRUE;
    [self removeAllAnnotations];
    [self currentLocation];
    geocoder = [[CLGeocoder alloc] init];
    currentlocation = [[CLLocationManager alloc] init];
    currentlocation.desiredAccuracy = kCLLocationAccuracyBest;
    currentlocation.delegate = self;
    [currentlocation startUpdatingLocation];
    mapViewAdd.showsUserLocation = YES;
    MKCoordinateRegion region= { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    region.span.longitudeDelta =0.003f;
    region.span.latitudeDelta = 0.003f;
    ann = [[ShowMap alloc] init];
    region.center.latitude  =   currentlocation.location.coordinate.latitude;
    region.center.longitude =  currentlocation.location.coordinate.longitude;
    ann.title=@"Current Location";
    ann.coordinate = region.center;
    
    [mapViewAdd setRegion:region animated:YES];
    
    [self.mapViewAdd addAnnotation:ann];
    eventLatitude =[NSString stringWithFormat:@"%f",ann.coordinate.latitude ];
    eventLongitude=[NSString stringWithFormat:@"%f",ann.coordinate.longitude ];
   
    [self mapRectView];
    rectColor=@"Green";
    [self mapFixRectView:rectColor];
    
}
//- (IBAction)btnClearPins:(id)sender {
//    nTouches=0;
//       [txtLocation  resignFirstResponder];
//    [self removeAllAnnotations];
//}

-(void)removeAllAnnotations
{
    //Get the current user location annotation.
       [mapViewAdd removeOverlays:[mapViewAdd overlays]];
    id userAnnotation=mapViewAdd.userLocation;
    
    //Remove all added annotations
    [mapViewAdd removeAnnotations:mapViewAdd.annotations];
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [mapViewAdd addAnnotation:userAnnotation];
}

- (IBAction)mapModeChanged:(id)sender {

    NSString *imgbtnmap= @"My LocationBlank.png";
    [ btnCurrentLocation setImage:[UIImage imageNamed:imgbtnmap] forState:UIControlStateNormal];
    switch (self.segmentMapMode.selectedSegmentIndex)
    {
        case 0:
            self.mapViewAdd.mapType = MKMapTypeSatellite  ;
            break;
        case 1:
            self.mapViewAdd.mapType = MKMapTypeHybrid ;
            break;
        case 2:

            self.mapViewAdd.mapType =MKMapTypeStandard ;
            break;
    }
}



-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:kGeoCodingString,pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    txtAddress.text=@"go to Settings and turn on Location Service for igothere app.";
    txtState.text=@"";
    txtCity.text=@"";
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:pdblLatitude
                                                        longitude:pdblLongitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count){
            
            txtAddress.text= [NSString stringWithFormat:@"%@" , [placemarks[0] name] ];
            txtState.text=[NSString stringWithFormat:@"%@" ,  [placemarks[0] administrativeArea]];
            txtZip.text=[NSString stringWithFormat:@"%@" ,  [placemarks[0] postalCode]];
            txtCity.text=[NSString stringWithFormat:@"%@" , [placemarks[0] locality]];
            ann.title=txtAddress.text;
     //      streetNumberLabel.text = [placemarks[0] subThoroughfare];
     //       streetLabel.text = [placemarks[0] thoroughfare];
     //       neighborhoodLabel.text = [placemarks[0] subLocality];
    //        cityLabel.text = [placemarks[0] locality];
     //       countyLabel.text = [placemarks[0] subAdministrativeArea];
    //        stateLabel.text = [placemarks[0] administrativeArea];    //or province
    //        zipCodeLabel.text = [placemarks[0] postalCode];
    //        countryLabel.text = [placemarks[0] country];
    //        countryCodeLabel.text = [placemarks[0] ISOcountryCode];
    //        inlandWaterLabel.text = [placemarks[0] inlandWater];
   //         oceanLabel.text = [placemarks[0] ocean];
     //       areasOfInterestLabel.text = [placemarks[0] areasOfInterest[0]];
        }
    }];

  //  txtAddress.text=[locationString substringFromIndex:6];
    return [locationString substringFromIndex:6];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self currentLocation];
    self.mapViewAdd.delegate=self;
    //  NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    //  self.lblVersion.text= [NSString stringWithFormat:@"Version %@",appBuildString];
    currentlocation = [[CLLocationManager alloc] init];
    currentlocation.desiredAccuracy = kCLLocationAccuracyBest;
    currentlocation.delegate = self;
    [currentlocation startUpdatingLocation];
    self.mapViewAdd.mapType = MKMapTypeSatellite;
    [mapViewAdd removeOverlays:[mapViewAdd overlays]];
    nTouches=0;
    
    [self readLocations];
    [self currentLocation];

    [self addGestureRecogniserToMapView];
    stepperRect.value=1;

    rectColor=@"Yellow";
    [self mapRectView];
}

- (void)viewWillDisappear:(BOOL)animated
{
  
    
}

- (void)viewDidLoad {

    [super viewDidLoad];


    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowInsert"]) {
        InsertViewController *newController = segue.destinationViewController;
        newController.recordID = self.fieldText ;
        newController.locationAddress=self.txtAddress.text;
        newController.locationCity=self.txtCity.text;
        newController.locationZip=self.txtZip.text;
        newController.locationState=self.txtState.text;
        newController.NLatDetail=self.NLat;
        newController.NLonDetail=self.NLon;
        newController.WLatDetail=self.WLat;
        newController.WLonDetail=self.WLon;
        newController.ELatDetail=self.ELat;
        newController.ELonDetail=self.ELon;
        newController.SLatDetail=self.SLat;
        newController.SLonDetail=self.SLon;
    }

    
}


- (void)addGestureRecogniserToMapView
{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.3; //
    [self.mapViewAdd addGestureRecognizer:lpgr];

}


- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }

    [self removeAllAnnotations];
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapViewAdd];
    CLLocationCoordinate2D touchMapCoordinate =[self.mapViewAdd convertPoint:touchPoint toCoordinateFromView:self.mapViewAdd];
        ann  = [[ShowMap alloc] init];
        ann.coordinate = touchMapCoordinate;
     [self.mapViewAdd addAnnotation:ann];

    NSLog(@"%d",nTouches);
    switch (nTouches) {
        case 0:
            [self getAddressFromLatLon:ann.coordinate.latitude withLongitude:ann.coordinate.longitude];
             break;
        case 1:
             self.NLat = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
             self.NLon = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
             ann.title=@"pinNe";
            break;
        case 2:
            self.WLat = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
            self.WLon = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
            ann.title=@"pinNw";
            break;
        case 3:
            self.SLat = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
            self.SLon = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
            ann.title=@"pinSw";
            break;
        case 4:
            self.ELat = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
            self.ELon = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
            ann.title=@"pinSe";
            break;
        default:
            break;
    }

    eventLatitude =[NSString stringWithFormat:@"%f",ann.coordinate.latitude ];
    eventLongitude=[NSString stringWithFormat:@"%f",ann.coordinate.longitude ];
    [self mapRectView];
    rectColor=@"Green";
    [self mapFixRectView:rectColor];
    

}




- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id < MKOverlay >)overlay
{
    
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithPolyline:overlay];
     renderer.lineWidth = 3.0;
    if ([rectColor isEqualToString:@"Clear"])
    {
        renderer.strokeColor = [UIColor clearColor];
    }
     if ([rectColor isEqualToString:@"Green"])
    {
        renderer.strokeColor = [UIColor greenColor];
    }
    if ([rectColor isEqualToString:@"Yellow"])
    {
        renderer.strokeColor = [UIColor yellowColor];
    }
    if ([rectColor isEqualToString:@"Red"])
    {
        renderer.strokeColor = [UIColor redColor];
    }
    if ([rectColor isEqualToString:@"Blue"])
    {
        renderer.strokeColor = [UIColor blueColor];
    }
    return renderer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation

{
 
    static NSString *AnnotationViewID = @"com.invasivecode.pin";

    MKAnnotationView *annotationView = (MKAnnotationView *)[mapViewAdd dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];

    if (annotation==self.mapViewAdd.userLocation)
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
        [annView setAnimatesDrop:YES];
        annView.draggable = YES;
   
  //  annView.pinColor = MKPinAnnotationColorRed;

 //   annotationView.image = [UIImage imageNamed:geoImage];
   // return annotationView;
      return annView;
}
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
   [self.mapViewAdd removeOverlays:[self.mapViewAdd overlays]];
    if (newState == MKAnnotationViewDragStateEnding)
    {

        
    }
    
    if (newState == MKAnnotationViewDragStateNone)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        eventLatitude= [NSString stringWithFormat:@"%f",droppedAt.latitude];
        eventLongitude=[NSString stringWithFormat:@"%f",droppedAt.longitude];
        [self mapRectView];
        rectColor=@"Yellow";
        [self mapFixRectView:rectColor];
        
    }
}



@end
