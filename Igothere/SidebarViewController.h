//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface SidebarViewController : UITableViewController
{
    NSArray *menuItems;
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    IBOutlet UITableView *menuTableView;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic) NSInteger locationsCount;
@end
