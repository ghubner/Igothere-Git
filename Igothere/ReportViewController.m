//
//  ReportViewController.m
//  Igothere
//
//  Created by Gilberto Hubner on 9/21/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "ReportViewController.h"
#import "CellEvents.h"
#import "ReportDetailViewController.h"
#import "SWRevealViewController.h"
@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize btnEdit;
@synthesize eventsTableView;
@synthesize fieldText;
@synthesize editEvents;
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

- (IBAction)btnEdit:(id)sender {
    if([self.btnEdit.title isEqualToString:@"Edit"])
    {
    self.editEvents=@"Y";
    self.btnEdit.title =@"Delete";
    [eventsTableView reloadData];
    }
    else
    {
        self.editEvents=@"N";
        self.btnEdit.title =@"Edit";
        [self openDB];
        char *err;
        NSString *sql;
        [self openDB];
        for (int xx=0; xx < itemsSelected.count;xx++)
        {
            if(![[itemsSelected objectAtIndex:xx] isEqualToString:@"N"])
            {
              fieldText= [itemsEventID objectAtIndex:xx];
                sql = [NSString stringWithFormat:@"Delete from Event where EventID=%@",fieldText];
                if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
                {
                }
            }
        }
        [self readEvents];
         [eventsTableView reloadData];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    eventsTableView.delegate=self;
    self.editEvents=@"N";
    [self readEvents];
    [eventsTableView reloadData];
    // Change button color
  //  _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
}

-(void)readEvents
{
  //  char *err;
  
    itemsLocationID = [[NSMutableArray alloc] init];
    itemsLocationName = [[NSMutableArray alloc] init];
    itemsLocationAddress = [[NSMutableArray alloc] init];
    itemsEventID = [[NSMutableArray alloc] init];
    itemsDateTimeIn= [[NSMutableArray alloc] init];
    itemsDateTimeOut= [[NSMutableArray alloc] init];
    itemsLatIN = [[NSMutableArray alloc] init];
    itemsLatOUT = [[NSMutableArray alloc] init];
    itemsLonIN = [[NSMutableArray alloc] init];
    itemsLonOUT= [[NSMutableArray alloc] init];
    itemsSelected= [[NSMutableArray alloc] init];
     NSString *locationAddress;
    [self openDB];
    NSString *sql =[NSString stringWithFormat:@"select * from Event as a,Location as b where a.locationID=b.locationID order by a.eventID desc"];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement ,0)];
            [itemsEventID addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,1)];
            [itemsLocationID addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,2)];
            [itemsDateTimeIn addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,3)];
            [itemsDateTimeOut addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,4)];
            [itemsLatIN addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,5)];
            [itemsLatOUT addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,6)];
            [itemsLonIN addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,7)];
            [itemsLonOUT addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,8)];
            [itemsSendEmainIN addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,9)];
            [itemsSendEmailOUT addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,11)];
            [itemsLocationName addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,12)];
            locationAddress=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,13)];
            locationAddress= [NSString stringWithFormat:@"%@ , %@",locationAddress,fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,14)];
            locationAddress= [NSString stringWithFormat:@"%@ %@",locationAddress,fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,15)];
            [itemsLocationAddress addObject:locationAddress];
            [itemsSelected addObject:@"N"];
        }
        
    }
//  sqlite3_close(appDB);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLocationReport"]) {
        ReportDetailViewController *newController = segue.destinationViewController;
        newController.recordIDResult = self.fieldText ;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return itemsEventID.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customCellEvents";
    CellEvents *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //Load custom cell from NIB file
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellEvents" owner:self options:NULL];
        cell = (CellEvents *) [nib objectAtIndex:0];
    }
    if([self.editEvents isEqualToString:@"Y"])
    {
      cell.imgCircleEdit.hidden=FALSE;
       if([[itemsSelected objectAtIndex:indexPath.row] isEqualToString:@"Y"])
       {
           cell.imgCircleEdit.image  = [UIImage imageNamed:@"circleRedChecked"] ;
       }
       else{
           cell.imgCircleEdit.image  = [UIImage imageNamed:@"circleRed"] ;
       }
   }
  
    cell.lblLocation.text = [itemsLocationName objectAtIndex:indexPath.row];
    cell.lblAddress.text = [itemsLocationAddress objectAtIndex:indexPath.row];
    cell.lblDateIN.text= [itemsDateTimeIn objectAtIndex:indexPath.row];
    cell.lblDateOut.text= [itemsDateTimeOut objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [itemsSelected replaceObjectAtIndex:indexPath.row withObject:@"N"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *selected=[NSString stringWithFormat:@"%@", [itemsEventID objectAtIndex:indexPath.row]];
       fieldText=[NSString stringWithFormat:@"%@", [itemsEventID objectAtIndex:indexPath.row]];
    if([self.editEvents isEqualToString:@"Y"])
    {
        [itemsSelected replaceObjectAtIndex:indexPath.row withObject:@"Y"];
    
    }
    else
    {
 
    NSLog(@"%@",selected);
    [self performSegueWithIdentifier:@"ShowLocationReport" sender:self];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *selected=[NSString stringWithFormat:@"%@", [itemsEventID objectAtIndex:indexPath.row]];
        fieldText=[NSString stringWithFormat:@"%@", [itemsEventID objectAtIndex:indexPath.row]];
        NSLog(@"%@",selected);
        char *err;
        [self openDB];
        
        
        NSString *sql = [NSString stringWithFormat:@"Delete from Event where EventID=%@",fieldText];
        
        if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
        {
        }
        [self readEvents];
        [eventsTableView endUpdates];
        [eventsTableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    */
}
@end
