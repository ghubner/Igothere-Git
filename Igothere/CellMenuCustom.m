//
//  CellMenuCustom.m
//  GPS
//
//  Created by Gilberto Hubner on 7/26/14.
//  Copyright (c) 2014 crw. All rights reserved.
//

#import "CellMenuCustom.h"

@implementation CellMenuCustom
@synthesize imgCircleEdit;
@synthesize  lblCity;
@synthesize switchEnable;
@synthesize lblClicked;
@synthesize lblAddress;
@synthesize lblLocationDescription;
@synthesize CellMenuCustom;
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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (IBAction)switchEnable:(id)sender {
  
    lblClicked.text=[NSString stringWithFormat:@"%d",switchEnable.on  ];
    NSString *locID=[NSString stringWithFormat:@"%li", (long)switchEnable.tag];
    NSLog(@"indexPath.row value : %@ %@", lblClicked.text,locID);
    [self   openDB];
    char *err;
    NSString *sql = [NSString stringWithFormat:@"UPDATE location set enableLocation=%@ where locationID=%@",lblClicked.text,locID];
    if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK)
    {
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    if (selected)
    {
        imgCircleEdit.image =[UIImage imageNamed:@"circleRedChecked"];
    }
    else
    {
        
        imgCircleEdit.image =[UIImage imageNamed:@"circleRed"];
    }
    
    // Configure the view for the selected state
}

@end
