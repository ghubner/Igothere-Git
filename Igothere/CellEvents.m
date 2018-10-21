//
//  CellEvents.m
//  Igothere
//
//  Created by Gilberto on 9/21/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "CellEvents.h"

@implementation CellEvents

@synthesize lblDateIN;
@synthesize lblDateOut;
@synthesize lblLocation;
@synthesize lblAddress;
@synthesize imgCircleEdit;



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        imgCircleEdit.image =[UIImage imageNamed:@"circleRedChecked"];
    }
    else
    {
        
        imgCircleEdit.image =[UIImage imageNamed:@"circleRed"];
    }
}

@end
