 //
//  MapViewController.m
//  Igothere
//
//  Created by CRW on 9/10/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#define kGeoCodingString @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f"
#define MINRADIUS 10
#define MAXRADIUS 30
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize dateInOut;
@synthesize lastDateIN;
@synthesize darkGreen;
@synthesize locationName;
@synthesize lblLocation;
@synthesize viewAddress;
@synthesize lblAddress;
@synthesize lblCity;
@synthesize lblState;
@synthesize lblZip;
@synthesize startTracking;
@synthesize animationImageView;
@synthesize lblStatus;
@synthesize btnStartStopTracking;
@synthesize circleView;
@synthesize lblZoomLevel;
@synthesize sliderZoom;
@synthesize emailFrom;
@synthesize emailTo;
@synthesize emailMessage;
@synthesize emailMessageIN;
@synthesize emailMessageOUT;
@synthesize locationRecordID;
@synthesize mapView;
@synthesize NLat;
@synthesize NLon;
@synthesize WLat;
@synthesize WLon;
@synthesize SLat;
@synthesize SLon;
@synthesize ELat;
@synthesize ELon;
@synthesize geocoder;
@synthesize fieldText;
@synthesize rectColor;
@synthesize eventLatitude;
@synthesize eventLongitude;
@synthesize segmentMapType;
@synthesize annotations = _annotations;
@synthesize sentEmailIN;
@synthesize sentEmailOUT;
@synthesize locationAddress;
@synthesize eventID;
@synthesize segmentMapMode;
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
- (IBAction)mapModeChanged:(id)sender {
    NSString *mapType=@"";
    switch (self.segmentMapMode.selectedSegmentIndex)
    {
        case 0:
            mapType=@"0";
            self.mapView.mapType = MKMapTypeSatellite  ;
            break;
        case 1:
            mapType=@"1";
            self.mapView.mapType = MKMapTypeHybrid ;
            break;
        case 2:
            mapType=@"2";
            self.mapView.mapType =MKMapTypeStandard ;
            break;
            
    }
}
-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    [mapView removeOverlays:[mapView overlays]];
    id userAnnotation=mapView.userLocation;
    
    //Remove all added annotations
    [mapView removeAnnotations:mapView.annotations];
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [mapView addAnnotation:userAnnotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.darkGreen= [UIColor colorWithRed:(0/255.0) green:(128.0/255.0) blue:(0/255.0) alpha:1.0];
     self.viewAddress.hidden=FALSE;
    if (nil == currentlocation)
        currentlocation = [[CLLocationManager alloc] init];
    currentlocation.delegate = self;
    currentlocation.desiredAccuracy = kCLLocationAccuracyBest;
    if ([currentlocation respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [currentlocation requestWhenInUseAuthorization];
    }
    [currentlocation requestAlwaysAuthorization];
    rectColor=@"Green";
    self.mapView.showsUserLocation = YES;
    lblZoomLevel.text=@"Zoom: 5";
    zoomLevel=0.001;
    if(sliderZoom.value==0)
    {
        lblZoomLevel.text=@"5";
    }
    mapView.delegate=self;
    
    [currentlocation stopUpdatingLocation];
    [self removeAllAnnotations];
    self.mapView.mapType = MKMapTypeSatellite;
    rectColor=@"Green";
    
    self.circleColor=@"Red";
    // Change button color
  //  _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    [self readLocations];
    if(itemsMapLocationID.count > 0)
    {
        [currentlocation startUpdatingLocation];
        self.circleView.hidden=FALSE;
        [self drawCircle];
        self.startTracking=@"YES";
        
        [self findCurrentLocation];
        [self mapFixRectView];
        [self checkInOut];
        [self createAnimation];
        [self startTimer];
        [animationImageView startAnimating];
        
    }
    else
    {
        self.startTracking=@"NO";
        [currentlocation stopUpdatingLocation];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_igothere_1024" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [ btnStartStopTracking setImage: img forState:UIControlStateNormal];
        self.startTracking=@"NO";
        [animationImageView stopAnimating];
        [currentlocation stopUpdatingLocation];
        [timer invalidate];
        [self changeColorBlue];

    }
    
}

- (IBAction)btnStartTracking:(id)sender {
    if([self.startTracking isEqualToString:@"NO"])
        {
            [currentlocation startUpdatingLocation];
            [animationImageView startAnimating];
            [self startTimer];
            self.startTracking=@"YES";
            self.circleView.hidden=FALSE;
            if([self.circleColor isEqualToString:@"Green"])
            {
                [self changeColorDarkGreen];
            }
            else
            {
                 [self changeColorRed];
            }
        }
        else
        {
            [currentlocation stopUpdatingLocation];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_igothere_1024" ofType:@"png"];
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            [ btnStartStopTracking setImage: img forState:UIControlStateNormal];
            self.startTracking=@"NO";
            [animationImageView stopAnimating];
            [currentlocation stopUpdatingLocation];
            [timer invalidate];
            [self changeColorBlue];
        }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mapView=nil;
      [timer invalidate];
    [currentlocation stopUpdatingLocation];
    [super viewWillDisappear:animated];
  
}
-(void)createAnimation
{
    
    self.animationImageView.animationDuration = 2;
    NSMutableArray *starImageArray = [@[] mutableCopy];
    for (int i = 0; i < 4; i++) {
        UIImage *starImage = [UIImage imageNamed:[NSString stringWithFormat:@"circleRedStop%d", i+1]];
        [starImageArray addObject:starImage];
    }
    self.animationImageView.animationImages = starImageArray;
}
-(void)startTimer
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                             target:self
                                           selector:@selector(timerFired:)
                                           userInfo:nil
                                            repeats:YES];
}
-(void)changeColorBlue
{
    self.circleView.hidden=TRUE;
    self.lblStatus.text=@"Press button to START";
    self.lblStatus.textColor=[UIColor blueColor];
    self.lblStatus.textColor  =[UIColor blueColor];
    self.lblAddress.textColor  =[UIColor blueColor];
    self.lblCity.textColor  =[UIColor blueColor];
    self.lblLocation.textColor  =[UIColor blueColor];
    self.lblState.textColor  =[UIColor blueColor];
    self.lblZip.textColor =[UIColor blueColor];
    self.lblZoomLevel.textColor=[UIColor blueColor];
}
-(void)changeColorWhite
{
    self.circleView.hidden=TRUE;
    self.lblStatus.text=@"Press button to START";
    self.lblStatus.textColor=[UIColor whiteColor];
    self.lblStatus.textColor  =[UIColor whiteColor];
    self.lblAddress.textColor  =[UIColor whiteColor];
    self.lblCity.textColor  =[UIColor whiteColor];
    self.lblLocation.textColor  =[UIColor whiteColor];
    self.lblState.textColor  =[UIColor whiteColor];
    self.lblZip.textColor =[UIColor whiteColor];
    self.lblZoomLevel.textColor =[UIColor whiteColor];
     self.lblZoomLevel.textColor=[UIColor whiteColor];
}
-(void)changeColorDarkGreen
{
    self.circleView.hidden=FALSE;
    self.lblStatus.text=@"Inside location:";
    self.lblStatus.textColor  =self.darkGreen;
    self.lblAddress.textColor  =self.darkGreen;
    self.lblCity.textColor  =self.darkGreen;
    self.lblLocation.textColor  =self.darkGreen;
    self.lblState.textColor  =self.darkGreen;
    self.lblZip.textColor =self.darkGreen;
     self.lblZoomLevel.textColor=darkGreen;
}
-(void)changeColorGreen
{
    
    self.circleView.hidden=FALSE;
    self.lblStatus.text=@"Inside location:";
    self.lblStatus.textColor  =[UIColor greenColor];
    self.lblAddress.textColor  =[UIColor greenColor];
    self.lblCity.textColor  =[UIColor greenColor];
    self.lblLocation.textColor  =[UIColor greenColor];
    self.lblState.textColor  =[UIColor greenColor];
    self.lblZip.textColor =[UIColor greenColor];
     self.lblZoomLevel.textColor=[UIColor greenColor];
}
-(void)changeColorRed
{
    self.lblStatus.text=@"Outside last location";
    self.lblStatus.textColor  =[UIColor redColor];
    self.lblAddress.textColor  =[UIColor redColor];
    self.lblCity.textColor  =[UIColor redColor];
    self.lblLocation.textColor  =[UIColor redColor];
    self.lblState.textColor  =[UIColor redColor];
    self.lblZip.textColor =[UIColor redColor];
    self.lblZoomLevel.textColor =[UIColor redColor];
    self.lblZoomLevel.textColor=[UIColor redColor];
}
-(void)drawCircle
{
   // [self.circleView removeFromSuperview];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
     if([self.circleColor isEqualToString:@"Red"])
     {
        [view setBackgroundColor:[UIColor redColor]];
     }
    else
    {
        [view setBackgroundColor:darkGreen];
    }
    [view.layer setCornerRadius:22.0f];
    [self.circleView addSubview:view];
}


-(void)timerFired:(NSTimer *) theTimer
{
    [self findCurrentLocation];
    [self checkInOut];
    NSLog(@"timerFired @ %@", [theTimer fireDate]);
}
-(void)viewDidDisappear:(BOOL)animated
{
       [currentlocation stopUpdatingLocation];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)readLastLocation
{

    [self openDB];
    NSString *sql =@"select * from location as a,(select locationID,max(datetimein) from event) as b where a.locationID=b.locationID";
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
           
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            self.lblLocation.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 2)];
            self.lblAddress.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 3)];
            self.lblCity.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 4)];
            self.lblState.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 5)];
            self.lblZip.text=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,21)];
            self.lastDateIN =fieldText;
        }
    }
    sqlite3_close(appDB);
    }
-(void)readLocations
{
    
    itemsMapLocationID = [[NSMutableArray alloc] init];
    itemsMapNLat = [[NSMutableArray alloc] init];
    itemsMapNLon = [[NSMutableArray alloc] init];
    itemsMapWLat = [[NSMutableArray alloc] init];
    itemsMapWLon = [[NSMutableArray alloc] init];
    itemsMapSLat = [[NSMutableArray alloc] init];
    itemsMapSLon = [[NSMutableArray alloc] init];
    itemsMapELat = [[NSMutableArray alloc] init];
    itemsMapELon = [[NSMutableArray alloc] init];
    itemsMapLocationName= [[NSMutableArray alloc] init];
    itemsMapEmailTo = [[NSMutableArray alloc] init];
    itemsMapEmailFrom  = [[NSMutableArray alloc] init];
    itemsMapEmailTo  = [[NSMutableArray alloc] init];
    itemsMapEmailMessageIN= [[NSMutableArray alloc] init];
    itemsMapEmailMessageOUT= [[NSMutableArray alloc] init];
    itemsMapLocationID= [[NSMutableArray alloc] init];
    itemsAddress= [[NSMutableArray alloc] init];
    itemsCity= [[NSMutableArray alloc] init];
    itemsState= [[NSMutableArray alloc] init];;
    itemsZip= [[NSMutableArray alloc] init];
    [self openDB];
    NSString *sql =[NSString stringWithFormat:@"Select * from Location where enableLocation=1"];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement , 0)];
            [itemsMapLocationID addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            [itemsMapLocationName addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 2)];
            [itemsAddress addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 3)];
            [itemsCity addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 4)];
            [itemsState addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 5)];
            [itemsZip addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 6)];
            [itemsMapNLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 7)];
            [itemsMapNLon   addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 8)];
            [itemsMapWLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 9)];
            [itemsMapWLon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,10)];
            [itemsMapSLat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,11)];
            [itemsMapSLon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,12)];
            [itemsMapELat addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,13)];
            [itemsMapELon addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,14)];
            [itemsMapEmailTo addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,15)];
            [itemsMapEmailFrom addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,16)];
            [itemsMapEmailMessageIN addObject: fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,17)];
            [itemsMapEmailMessageOUT addObject: fieldText];
        }
        [self readLastLocation];
    }
    //  sqlite3_close(appDB);
}
-(void)readLocationID
{
    [self openDB];
    NSString *sql =[NSString stringWithFormat:   @"Select * from Location where locationID='%@'",self.locationRecordID];
    
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
           
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            locationName=fieldText;
            
            NSString *locationAddressComplete=@"";
            [self checkNULL:(char *)sqlite3_column_text(statement , 2)];
              locationAddressComplete=fieldText;
          
            [self checkNULL:(char *)sqlite3_column_text(statement , 3)];
            locationAddressComplete= [NSString stringWithFormat:@"%@ %@",locationAddressComplete,fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 4)];
            locationAddressComplete= [NSString stringWithFormat:@"%@ %@",locationAddressComplete,fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 5)];
            locationAddressComplete= [NSString stringWithFormat:@"%@ %@",locationAddressComplete,fieldText];
            locationAddress=locationAddressComplete;
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
            self.emailTo =fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,15)];
            self.emailFrom=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,16)];
            self.emailMessageIN =fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,17)];
            self.emailMessageOUT=fieldText;
        }
    }
}
-(void)checkInOut
{
    bool  oddNodes=NO;
    int ll=9999;
    for (int ii=0; ii < itemsMapLocationID.count; ii++)
    {
        self.NLat  = [NSString stringWithFormat:@"%@",[itemsMapNLat objectAtIndex:ii]];
        self.NLon  = [NSString stringWithFormat:@"%@",[itemsMapNLon objectAtIndex:ii]];
        self.WLat  = [NSString stringWithFormat:@"%@",[itemsMapWLat objectAtIndex:ii]];
        self.WLon  = [NSString stringWithFormat:@"%@",[itemsMapWLon objectAtIndex:ii]];
        self.SLat  = [NSString stringWithFormat:@"%@",[itemsMapSLat objectAtIndex:ii]];
        self.SLon  = [NSString stringWithFormat:@"%@",[itemsMapSLon objectAtIndex:ii]];
        self.ELat  = [NSString stringWithFormat:@"%@",[itemsMapELat objectAtIndex:ii]];
        self.ELon  = [NSString stringWithFormat:@"%@",[itemsMapELon objectAtIndex:ii]];
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
    //    MKPolygon *polygon =[MKPolygon polygonWithCoordinates:rect count:5];
    //    rectColor=@"Blue";
    //    polygon.title = @"Select Location";
   //     [self.mapView addOverlay:polygon];
        float  polyX[4];
        float  polyY[4];
        float  x, y ;
        
        polyX[0] = N1point;
        polyX[1] = W1point;
        polyX[2] = S1point;
        polyX[3] = E1point;
        
        polyY[0] = N2point;
        polyY[1] = W2point;
        polyY[2] = S2point;
        polyY[3] = E2point;
        
        x= self.eventLatitude.floatValue;
        y= self.eventLongitude.floatValue;
     //
        int polySides =4;
        int   i, j=polySides-1 ;
        oddNodes=NO;
        
        for (i=0; i<polySides; i++) {
            if ((polyY[i]<y && polyY[j]>=y)  || ( polyY[j]< y && polyY[i]>= y))
            {
                if (polyX[i]+(y-polyY[i])/(polyY[j]-polyY[i])*(polyX[j]-polyX[i])<x)
                {
                    oddNodes=!oddNodes;
                }
            }
            j=i;
        }
         NSLog(@"%f %f %i",x,y,oddNodes);
        if(oddNodes)
        {
            ll=ii;
            ii=9999;
        }
    }

    if(oddNodes)
    {
        if([self.circleColor isEqualToString:@"Red"])
        {
        emailTo=[NSString stringWithFormat:@"%@",[itemsMapEmailTo objectAtIndex:ll]];
        emailFrom=[NSString stringWithFormat:@"%@",[itemsMapEmailFrom objectAtIndex:ll]];
        emailMessageIN=[NSString stringWithFormat:@"%@",[itemsMapEmailMessageIN objectAtIndex:ll]];
        emailMessageOUT=[NSString stringWithFormat:@"%@",[itemsMapEmailMessageOUT objectAtIndex:ll]];
        locationRecordID=[NSString stringWithFormat:@"%@",[itemsMapLocationID objectAtIndex:ll]];
        locationName=[NSString stringWithFormat:@"%@",[itemsMapLocationName objectAtIndex:ll]];
            locationAddress=[NSString stringWithFormat:@"%@ %@ %@ %@",[itemsAddress objectAtIndex:ll],[itemsCity objectAtIndex:ll],[itemsState objectAtIndex:ll],[itemsZip objectAtIndex:ll]];
        [self saveEventIN];
        self.lblLocation.text=[NSString stringWithFormat:@"%@",[itemsMapLocationName objectAtIndex:ll]];
        self.lblAddress.text=[NSString stringWithFormat:@"%@",[itemsAddress objectAtIndex:ll]];
        self.lblCity.text=[NSString stringWithFormat:@"%@",[itemsCity objectAtIndex:ll]];
        self.lblState.text=[NSString stringWithFormat:@"%@",[itemsState objectAtIndex:ll]];
        self.lblZip.text=[NSString stringWithFormat:@"%@",[itemsZip objectAtIndex:ll]];
        self.circleView.hidden=FALSE;
        [self changeColorDarkGreen];
        self.circleColor=@"Green";
        [self drawCircle];
        }
    }
    
    if(!oddNodes)
    {
      if([self.circleColor isEqualToString:@"Green"])
        {
            [self saveEventOUT];
            self.circleView.hidden=FALSE;
            [self changeColorRed];
            self.circleColor=@"Red";
            [self drawCircle];
        }
    }
}

-(void)sendEmail
{
    NSString *sendTo =emailTo;
    NSString *sendFrom =emailFrom;
    NSString *message = [emailMessage stringByReplacingOccurrencesOfString:@"\"" withString:@"-"];
    NSString *urlString =[NSString stringWithFormat:@"http://hubner-apps.com/igothere/sms.php?a=%@&b=%@&c=%@",sendFrom,sendTo,message];
    urlString=[urlString stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *results = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", results);
}
-(void)saveEventIN
{
    char *err;
    [self openDB];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSString *strDate = [dateFormat stringFromDate:today];
    eventID=@"0";
    sentEmailIN=@"0";
    
    NSString *sql =[NSString stringWithFormat:@"select * from Event where locationID=%@ and DateTimeOUT ='0'",locationRecordID ];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement , 0)];
            eventID=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,8)];
            sentEmailIN=fieldText;
        }
    }
    if([sentEmailIN isEqualToString:@"0"])
        {
            [self readLastLocation];
            dateInOut=strDate;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            NSDate *dateFromString = [[NSDate alloc] init];
            NSTimeInterval diff;
            if(self.lastDateIN.length ==0)
            {
                diff=400;
            }
            else
            {
                dateFromString = [dateFormat dateFromString:self.lastDateIN];
                diff = [today timeIntervalSinceDate:dateFromString];
            }
            if(diff > 300)
            {
            sql =[NSString stringWithFormat:@"Delete from Event where DateTimeOUT ='0'"];
            if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
            {
            }
          sql =[NSString stringWithFormat:@"Insert into Event (LocationID,DateTimeIN,DateTimeOUT, LatIN,LonIN,LatOUT,LonOUT, sendEmailIN, sendEmailOUT) values('%@','%@','0','%@','%@','0','0','1','0')",
                    locationRecordID, strDate,eventLatitude,eventLongitude];
          if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
            {
            }

            emailMessageIN = [NSString stringWithFormat:@"My Location:%@\nAddress:%@\nDate Time:%@\nMessage IN:\n%@", self.locationName,self.locationAddress,strDate,emailMessageIN];
            emailMessage = [self convertHTML:emailMessageIN];
            NSString *sendYES=@"1";
            if ([emailFrom rangeOfString:@"@"].location == NSNotFound) {
                sendYES=@"0";
            }
            if ([emailTo rangeOfString:@"@"].location == NSNotFound) {
                sendYES=@"0";
            }
            if([sendYES isEqualToString:@"1"])
            {
          
                [self sendEmail];
            }
            }
        }
    sqlite3_close(appDB);
}
-(void)saveEventOUT
{
    char *err;
    [self openDB];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    NSString *strDate = [dateFormat stringFromDate:today];
    sentEmailOUT=@"2";
    NSString *sql =[NSString stringWithFormat:@"select * from Event where DateTimeOUT ='0'"];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement , 0)];
            eventID=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            locationRecordID=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,9)];
            sentEmailOUT=@"0";
        }
        
    }
    
    if([sentEmailOUT isEqualToString:@"0"])
        {

             [self readLocationID];
            
            sql =[NSString stringWithFormat:@"update Event set DateTimeOUT='%@',LatOUT='%@',LonOUT='%@',sendEmailOUT='1' where DateTimeOUT ='0' ",strDate,eventLatitude,eventLongitude];
            if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
            {
            }
            dateInOut=strDate;
            NSTimeInterval diff;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            if(self.lastDateIN.length ==0)
            {
                diff=400;
            }
            else
            {
                NSDate *dateFromString = [[NSDate alloc] init];
                dateFromString = [dateFormat dateFromString:self.lastDateIN];
                diff = [today timeIntervalSinceDate:dateFromString];
            }
            if(diff > 300)
            {
                emailMessageOUT =  [NSString stringWithFormat:@"My Location:%@\nAddress:%@\nDate Time:%@\nMessage OUT:\n%@", self.locationName,self.locationAddress,strDate,emailMessageOUT];
                emailMessage = [self convertHTML:emailMessageOUT];
                NSString *sendYES=@"1";
                if ([emailFrom rangeOfString:@"@"].location == NSNotFound) {
                    sendYES=@"0";
                }
                if ([emailTo rangeOfString:@"@"].location == NSNotFound) {
                    sendYES=@"0";
                }
                if([sendYES isEqualToString:@"1"])
                {
                 [self sendEmail];
                }
            }
        }
  sqlite3_close(appDB);
}

-(void)mapFixRectView
{
   
    for (int ii=0; ii < itemsMapLocationID.count; ii++)
    {
        self.NLat  = [NSString stringWithFormat:@"%@",[itemsMapNLat objectAtIndex:ii]];
        self.NLon  = [NSString stringWithFormat:@"%@",[itemsMapNLon objectAtIndex:ii]];
        self.WLat  = [NSString stringWithFormat:@"%@",[itemsMapWLat objectAtIndex:ii]];
        self.WLon  = [NSString stringWithFormat:@"%@",[itemsMapWLon objectAtIndex:ii]];
        self.SLat  = [NSString stringWithFormat:@"%@",[itemsMapSLat objectAtIndex:ii]];
        self.SLon  = [NSString stringWithFormat:@"%@",[itemsMapSLon objectAtIndex:ii]];
        self.ELat  = [NSString stringWithFormat:@"%@",[itemsMapELat objectAtIndex:ii]];
        self.ELon  = [NSString stringWithFormat:@"%@",[itemsMapELon objectAtIndex:ii]];
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
        [self.mapView addOverlay:polygon];
        float C1 = (NLat.floatValue - SLat.floatValue)/2 +SLat.floatValue;
        float C2 = ( WLon.floatValue -ELon.floatValue)/2 +ELon.floatValue;
       ann = [[ShowMap alloc] init];
        //  ann.title  = @"NORTH";
        ann.coordinate = CLLocationCoordinate2DMake(C1, C2);
        [self.mapView addAnnotation:ann];
    }
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
- (IBAction)sliderZoomChange:(id)sender {

    zoomLevel=0.001 * self.sliderZoom.value;
    int zoom=self.sliderZoom.value;
    lblZoomLevel.text= [NSString stringWithFormat:@"Zoom: %i",zoom];
    [self findCurrentLocation];
}

-(void)findCurrentLocation
{
     geocoder = [[CLGeocoder alloc] init];

   //  currentlocation.desiredAccuracy = kCLLocationAccuracyKilometer;
  //   currentlocation.distanceFilter = 5; // meters
    [currentlocation startUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
    MKCoordinateRegion region= { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.span.longitudeDelta =zoomLevel;
    region.span.latitudeDelta =zoomLevel;

    region.center.latitude  =   currentlocation.location.coordinate.latitude;
    region.center.longitude =  currentlocation.location.coordinate.longitude;
    // use the zoom level to compute the region

    self.eventLatitude=[ NSString stringWithFormat:@"%f",currentlocation.location.coordinate.latitude ];
    self.eventLongitude=[ NSString stringWithFormat:@"%f",currentlocation.location.coordinate.longitude ];

    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    //   BOOL locationAvailable = currentlocation.location !=nil;
    
    if (locationAllowed==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for i g o t h e r e app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else
    {
    if(region.center.latitude == 0 && region.center.longitude ==0 )
        {
            [self.mapView setRegion:region animated:YES];
            CLLocationCoordinate2D  locationEventMap;
            if(itemsMapNLat.count >0)
            {
                self.NLat  = [NSString stringWithFormat:@"%@",[itemsMapNLat objectAtIndex:0]];
                self.NLon  = [NSString stringWithFormat:@"%@",[itemsMapNLon objectAtIndex:0]];

                locationEventMap = CLLocationCoordinate2DMake(self.NLat.floatValue, self.NLon.floatValue);
                region.center.latitude  = locationEventMap.latitude;
                region.center.longitude = locationEventMap.longitude ;
                [self getAddressFromLatLon:currentlocation.location.coordinate.latitude withLongitude:currentlocation.location.coordinate.longitude];
            }
        }
    }
   // ann = [[ShowMap alloc] init];
   // ann.title=locationAddress;
  //  ann.coordinate = region.center;
 
}

//         txtAddress.text= [NSString stringWithFormat:@"%@" , [placemarks[0] name] ];
//         txtState.text=[NSString stringWithFormat:@"%@" ,  [placemarks[0] administrativeArea]];
//          txtZip.text=[NSString stringWithFormat:@"%@" ,  [placemarks[0] postalCode]];
//          txtCity.text=[NSString stringWithFormat:@"%@" , [placemarks[0] locality]];
//           ann.title=txtAddress.text;
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

-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:kGeoCodingString,pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:pdblLatitude
                                                        longitude:pdblLongitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(placemarks.count){

        }
    }];
    
    locationAddress=[locationString substringFromIndex:6];
    return [locationString substringFromIndex:6];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id < MKOverlay >)overlay
{
    
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    if ([rectColor isEqualToString:@"Clear"])
    {
        renderer.strokeColor = [UIColor clearColor];
        renderer.lineWidth = 3.0;
    }
    if ([rectColor isEqualToString:@"Green"])
    {
        renderer.strokeColor = [UIColor greenColor];
        renderer.lineWidth = 3.0;
    }
    if ([rectColor isEqualToString:@"Yellow"])
    {
        renderer.strokeColor = [UIColor yellowColor];
        renderer.lineWidth = 3.0;
    }
    if ([rectColor isEqualToString:@"Red"])
    {
        renderer.strokeColor = [UIColor redColor];
        renderer.lineWidth = 3.0;
    }
    if ([rectColor isEqualToString:@"Blue"])
    {
        renderer.strokeColor = [UIColor blueColor];
        renderer.lineWidth = 3.0;
    }
    return renderer;
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation

{
    
    static NSString *AnnotationViewID = @"com.invasivecode.pin";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    if (annotation==self.mapView.userLocation)
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
    return annView;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // NSLog(@"%@", [locations lastObject]);
    BOOL isInBackground = NO;
   
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    if (isInBackground)
    {
        NSLog(@"%@",@"background");
    }

}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self zoomToUserLocation:userLocation];
}
- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;

    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span.longitudeDelta = zoomLevel;
    region.span.latitudeDelta = zoomLevel;
   
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}
- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == currentlocation)
        currentlocation = [[CLLocationManager alloc] init];
    
    currentlocation.delegate = self;
    [currentlocation startMonitoringSignificantLocationChanges];
}

-(void) applicationDidBecomeActive:(UIApplication *) application
{
    [currentlocation stopMonitoringSignificantLocationChanges];
    [currentlocation startUpdatingLocation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
