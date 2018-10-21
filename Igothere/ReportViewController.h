//
//  ReportViewController.h
//  Igothere
//
//  Created by Gilberto Hubner on 9/21/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@protocol RefreshTableDelegate <NSObject>

-(void)refreshTable:(NSString *)recordID;

@end
@interface ReportViewController : UIViewController <UITableViewDelegate>
{

    sqlite3 *appDB;
    sqlite3_stmt *statement;
    IBOutlet UITableView *eventsTableView;
    NSMutableArray *itemsEventID;
    NSMutableArray *itemsLocationID;
    NSMutableArray *itemsLocationName;
    NSMutableArray *itemsLocationAddress;
    NSMutableArray *itemsDateTimeIn;
    NSMutableArray *itemsDateTimeOut;
    NSMutableArray *itemsLatIN;
    NSMutableArray *itemsLonIN;
    NSMutableArray *itemsLatOUT;
    NSMutableArray *itemsLonOUT;
    NSMutableArray *itemsSendEmainIN;
    NSMutableArray *itemsSendEmailOUT;
    NSMutableArray *itemsSelected;
 
    IBOutlet UIBarButtonItem *btnEdit;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSString *fieldText;
@property (strong, nonatomic) NSString *editEvents;
@property (strong, nonatomic) IBOutlet UITableView *eventsTableView;
@end
