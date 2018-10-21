//
//  CellSendEmail.m
//  InspectionView
//
//
//

#import "CellSendEmail.h"

@implementation CellSendEmail
@synthesize lblContractorName;
@synthesize imgChecked;
@synthesize lblEmailContactAddress;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{   
    
  
    
    [super setSelected:selected animated:animated];
    if (selected)
    {
       imgChecked.image =[UIImage imageNamed:@"checkedBlueCompleted.png"];
    }
else
    {

        imgChecked.image =[UIImage imageNamed:@"checkedBlue.png"];
    }
    
    // Configure the view for the selected state
}


@end
