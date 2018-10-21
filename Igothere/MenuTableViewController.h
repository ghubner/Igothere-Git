//
//  MenuTableViewController.h
//  GPS
//
//  Created by Gilberto Hubner on 7/26/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface MenuTableViewController :UIViewController <UITableViewDelegate>
{
 
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    NSMutableArray *itemsLocationID;
    NSMutableArray *itemsDescription;
    NSMutableArray *itemsAddress;
    NSMutableArray *itemsCity;
    NSMutableArray *itemsSelected;
    NSMutableArray *itemsEnable;
    IBOutlet UITableView *tableViewLocations;
    IBOutlet UIView *viewMenu;
    
    IBOutlet UILabel *lblButton;
    IBOutlet UIButton *btnEdit;
}
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UILabel *lblButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property (nonatomic,strong) NSString *fieldText;
@property (strong, nonatomic) IBOutlet UITableView *tableViewLocations;
@property (nonatomic, strong) NSString *selectAll;
@property (strong, nonatomic) NSString *editLocations;
@end
