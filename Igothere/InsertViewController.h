//
//  InsertViewController.h
//  Igothere
//
//  Created by Gilberto Hubner on 9/28/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface InsertViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UIPickerViewDelegate>
{
    sqlite3 *appDB;
    sqlite3_stmt *statement;
    NSMutableArray *emailContacts;
    NSMutableArray *emailContactSelected;

    IBOutlet UIView *viewPickerFrom;
   
    IBOutlet UITextField *txtLocation;
    IBOutlet UITextView *txtMessageIN;
    IBOutlet UITextView *txtMessageOUT;
    IBOutlet UITextField *txtEmailFrom;
    IBOutlet UITextView *txtEmailTo;
    IBOutlet UITableView *tableViewSendEmail;
    IBOutlet UIPickerView *pickerViewFrom;
    NSMutableArray *contactEmailsFrom;
    NSMutableArray *contactEmails;
    NSMutableArray *contactName;
    IBOutlet UIView *viewSendEmail;
}
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewFrom;
@property (strong, nonatomic) IBOutlet UIView *viewSendEmail;
@property (nonatomic,strong)  NSString *fieldText;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSendEmail;
@property (strong, nonatomic) IBOutlet UITextView *txtMessageIN;
@property (strong, nonatomic) IBOutlet UITextView *txtMessageOUT;
@property (strong, nonatomic) IBOutlet UITextView *txtEmailTo;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailFrom;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (nonatomic, strong) NSString *recordID;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) NSString *locationState;
@property (nonatomic, strong) NSString *locationZip;
@property (strong, nonatomic) NSString *NLatDetail;
@property (strong, nonatomic) NSString *NLonDetail;
@property (strong, nonatomic) NSString *WLatDetail;
@property (strong, nonatomic) NSString *WLonDetail;
@property (strong, nonatomic) NSString *SLatDetail;
@property (strong, nonatomic) NSString *SLonDetail;
@property (strong, nonatomic) NSString *ELatDetail;
@property (strong, nonatomic) NSString *ELonDetail;
@end
