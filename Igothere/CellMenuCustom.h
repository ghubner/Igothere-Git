//
//  CellMenuCustom.h
//  GPS
//
//  Created by Gilberto Hubner on 7/26/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface CellMenuCustom : UITableViewCell
{
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    IBOutlet UILabel *lblLocationDescription;
    
    IBOutlet UILabel *lblAddress;

    IBOutlet UISwitch *switchEnable;
  
    IBOutlet UILabel *lblCity;

    IBOutlet UIImageView *imgCircleEdit;

    IBOutlet UILabel *lblClicked;
    
 
    IBOutlet UIView *CellMenuCustom;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgCircleEdit;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;

@property (strong, nonatomic) IBOutlet UISwitch *switchEnable;
@property (strong, nonatomic) IBOutlet UILabel *lblClicked;

@property (strong, nonatomic) IBOutlet UIView *CellMenuCustom;

@property (strong, nonatomic) IBOutlet UILabel *lblLocationDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;




@end
