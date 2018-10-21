//
//  CellEvents.h
//  Igothere
//
//  Created by Gilberto on 9/21/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellEvents : UITableViewCell
{
    
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblDateIN;
    IBOutlet UILabel *lblDateOut;
    IBOutlet UILabel *lblAddress;

    IBOutlet UIImageView *imgCircleEdit;


}
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDateIN;
@property (strong, nonatomic) IBOutlet UILabel *lblDateOut;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgCircleEdit;


@end
