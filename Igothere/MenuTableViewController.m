//
//  MenuTableViewController.m
//
//
//  Created by Gilberto Hubner on 7/26/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import "MenuTableViewController.h"
#import "CellMenuCustom.h"
#import "ViewController.h"
#import "AddLocationViewController.h"
#import "SWRevealViewController.h"

@implementation MenuTableViewController
@synthesize lblButton;
@synthesize btnEdit;
@synthesize tableViewLocations;
@synthesize fieldText;
@synthesize selectAll;
@synthesize viewMenu;
@synthesize editLocations;
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


-(void)readLocations
{
    [self openDB];
     NSString *sql =@"Select * from Location";
    itemsLocationID =  [[NSMutableArray alloc] init];
	itemsDescription=  [[NSMutableArray alloc] init];
    itemsAddress    =  [[NSMutableArray alloc] init];
    itemsEnable  =  [[NSMutableArray alloc] init];
    itemsCity = [[NSMutableArray alloc] init];
    itemsSelected=[[NSMutableArray alloc] init];
    NSString *locationAddress;
	if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
		SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [self checkNULL:(char *)sqlite3_column_text(statement , 0)];
            [itemsLocationID addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 1)];
            [itemsDescription addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement , 2)];
            [itemsAddress addObject:fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,3)];
            locationAddress=fieldText;
            [self checkNULL:(char *)sqlite3_column_text(statement ,4)];
            locationAddress= [NSString stringWithFormat:@"%@ , %@",locationAddress,fieldText];
            [self checkNULL:(char *)sqlite3_column_text(statement ,5)];
            locationAddress= [NSString stringWithFormat:@"%@ , %@",locationAddress,fieldText];
            [itemsCity addObject:locationAddress];
            [self checkNULL:(char *)sqlite3_column_text(statement ,18)];
            [itemsEnable addObject:fieldText];
            [itemsSelected addObject:@"N"];
        }
    }
    [tableViewLocations reloadData];
}

- (IBAction)btnEdit:(id)sender {
    if([self.lblButton.text isEqualToString:@"Edit"])
    {
        self.lblButton.text=@"Delete";
        self.editLocations=@"Y";
        self.btnEdit.titleLabel.text =@"Delete";
        [tableViewLocations reloadData];
    }
    else
    {
        self.lblButton.text=@"Edit";
        self.editLocations=@"N";
        self.btnEdit.titleLabel.text =@"Edit";
        [self openDB];
        char *err;
        NSString *sql;
        [self openDB];
        for (int xx=0; xx < itemsSelected.count;xx++)
        {
            if(![[itemsSelected objectAtIndex:xx] isEqualToString:@"N"])
            {
                fieldText= [itemsLocationID objectAtIndex:xx];
                
                sql = [NSString stringWithFormat:@"Delete from Event where locationID=%@",fieldText];
                
                if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
                {
                }
                sql = [NSString stringWithFormat:@"Delete from Location where locationID=%@",fieldText];
                
                if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
                {
                } 
            }
        }
        [self readLocations];
        [tableViewLocations reloadData];
    }
    
}




- (IBAction)btnAddLocation:(id)sender {
    [self performSegueWithIdentifier:@"ShowAddLocation" sender:self];
}
-(void)refreshTable:(NSString *)recordID
{
    [self readLocations];
    [tableViewLocations reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
   
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    // Change button color
 //   _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    [self readLocations];
    [tableViewLocations reloadData];
    if(itemsLocationID.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"i g o t h e r e"
                              message: @"To ADD location, tap on the little (+) add icon in the top right hand corner of the screen"
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [tableViewLocations reloadData];
    }
    self.btnEdit.titleLabel.text=@"Edit";
}
-(void)viewDidDisappear:(BOOL)animated
{
    viewMenu=nil;
  //  tableViewLocations=nil;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLocation"]) {
        ViewController *newController = segue.destinationViewController;
        newController.recordIDResult = self.fieldText ;
    }
    if ([segue.identifier isEqualToString:@"ShowAddLocation"]) {
        AddLocationViewController *newController = segue.destinationViewController;
        newController.recordIDResult = self.fieldText ;
        newController.delegate=self;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return itemsLocationID.count;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *CellIdentifier = @"cellMenuCustom";
    CellMenuCustom *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //Load custom cell from NIB file
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellMenuCustom" owner:self options:NULL];
        cell = (CellMenuCustom *) [nib objectAtIndex:0];
        
    }
    cell.lblLocationDescription.text= [itemsDescription objectAtIndex:indexPath.row];
    cell.lblAddress.text= [itemsAddress objectAtIndex:indexPath.row];
    cell.lblCity.text=[itemsCity objectAtIndex:indexPath.row];
    NSString *locID=[itemsLocationID  objectAtIndex:indexPath.row];
    NSString *locEnable=[itemsEnable   objectAtIndex:indexPath.row];
    if ([locEnable isEqualToString:@"1"])
    {
        cell.switchEnable.on=TRUE;
    }
    else
    {
        cell.switchEnable.on=FALSE;
    }
    cell.switchEnable.tag=locID.integerValue;
    
    NSString *selected=[NSString stringWithFormat:@"%@", [itemsSelected objectAtIndex:indexPath.row]];
    if ( [selected  isEqualToString: @"Y"])
    {
      
    }
    else
    {
        
      
        
    }
    
    if([self.editLocations isEqualToString:@"Y"])
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
    
    
    
    if ([selectAll isEqualToString:@"Y"])
    {
        [tableViewLocations selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70
    ;
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
          [itemsSelected replaceObjectAtIndex:indexPath.row withObject:@"N"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *selected=[NSString stringWithFormat:@"%@", [itemsLocationID objectAtIndex:indexPath.row]];
    fieldText=[NSString stringWithFormat:@"%@", [itemsLocationID objectAtIndex:indexPath.row]];
    NSLog(@"%@",selected);
    if([self.editLocations isEqualToString:@"Y"])
    {
 
          [itemsSelected replaceObjectAtIndex:indexPath.row withObject:@"Y"];

        
    }
    else
    {
 [self performSegueWithIdentifier:@"ShowLocation" sender:self];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           NSString *selected=[NSString stringWithFormat:@"%@", [itemsLocationID objectAtIndex:indexPath.row]];
        fieldText=selected;

        char *err;
        [self openDB];
        NSString *sql = [NSString stringWithFormat:@"Delete from Event where locationID=%@",fieldText];
        
        if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
        {
        }
        sql = [NSString stringWithFormat:@"Delete from Location where locationID=%@",fieldText];
        
        if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
        {
        }
        [itemsLocationID removeObjectAtIndex:indexPath.row];
        [itemsDescription removeObjectAtIndex:indexPath.row];
        [itemsAddress removeObjectAtIndex:indexPath.row];
        [self.tableViewLocations endUpdates];
        [tableViewLocations reloadData];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
   */
    
}

@end
