//
//  CellSendEmail.h
//  InspectionView
//
//  Created by CRW on 6/24/14.
//
//

#import <UIKit/UIKit.h>

@interface CellSendEmail : UITableViewCell
{



    IBOutlet UIImageView *imgChecked;


    IBOutlet UILabel *lblEmailContactAddress;

    IBOutlet UILabel *lblContractorName;

}
@property (retain, nonatomic) IBOutlet UILabel *lblContractorName;


@property (retain, nonatomic) IBOutlet UILabel *lblEmailContactAddress;

@property (retain, nonatomic) IBOutlet UIImageView *imgChecked;

@end
