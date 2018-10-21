//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#define  NORMAL_HEIGHT 24
#define SPECIAL_HEIGHT 150
@interface SidebarViewController ()
@property (nonatomic) int cellSize;
@end

@implementation SidebarViewController
@synthesize menuTableView;
@synthesize locationsCount;
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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    menuItems = @[@"title", @"tracking", @"map", @"locations", @"events"];
    //, @"wishlist", @"bookmark", @"tag"];
    //    self.menuTableView.frame = CGRectMake(0,0, 320,200) ;
   self.menuTableView.backgroundColor=[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0];
 

}
-(void)viewDidAppear
{
    [self openDB];
    NSString *locationCount;
    NSString *sql =@"Select count(locationID) from Location";
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            locationCount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement , 0)];
        }
    }
    self.locationsCount=locationCount.integerValue;
    if(self.locationsCount ==0)
    {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        
        [self.menuTableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 50;
    }
else
{
    return 100;
}
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView

    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
