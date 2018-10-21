//
//  InsertViewController.m
//  Igothere
//
//  Created by Gilberto Hubner on 9/28/14.
//  Copyright (c) 2014 hubner-app.com. All rights reserved.
//

#import "InsertViewController.h"
#import "CellSendEmail.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface InsertViewController ()

@end

@implementation InsertViewController
@synthesize txtMessageIN;
@synthesize txtMessageOUT;
@synthesize txtEmailFrom;
@synthesize txtEmailTo;
@synthesize tableViewSendEmail;
@synthesize btnSave;
@synthesize pickerViewFrom;
@synthesize fieldText;
@synthesize viewSendEmail;
@synthesize locationAddress;
@synthesize locationCity;
@synthesize locationState;
@synthesize locationZip;
@synthesize NLatDetail;
@synthesize NLonDetail;
@synthesize ELatDetail;
@synthesize ELonDetail;
@synthesize WLatDetail;
@synthesize WLonDetail;
@synthesize SLatDetail;
@synthesize SLonDetail;
@synthesize txtLocation;
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
-(void)checkNULL:(char *)aChar
{
    if (aChar == NULL)
    {
        fieldText=@"";
    }
    else
    {
        fieldText=[NSString stringWithUTF8String:aChar];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.btnSave.enabled=TRUE;
    return true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    btnSave.enabled=TRUE;
    
    return YES;
}


- (IBAction)btnOKEmail:(id)sender {
    viewSendEmail.hidden=TRUE;
}

- (NSString*)textClear:(NSString *)textFormat
{
    textFormat=[NSString stringWithFormat:@"%@",textFormat ];
    
    if ([textFormat isEqualToString:@"<null>"] || [textFormat isEqualToString:@"(null)"])
    {
        textFormat=@"";
    }
    return textFormat;
}
- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)btnEmailFrom:(id)sender {
    [txtMessageIN   resignFirstResponder];
    [txtMessageOUT   resignFirstResponder];
    [txtEmailFrom   resignFirstResponder];
    [txtEmailTo   resignFirstResponder];
    [txtLocation   resignFirstResponder];
    if(contactEmailsFrom.count > 0)
    {
        viewPickerFrom.hidden=FALSE;
    }
}
-(void)getAllContacts
{
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        contactEmails =  [[NSMutableArray alloc] init];
        contactName  = [[NSMutableArray alloc] init];
        emailContactSelected = [[NSMutableArray alloc] init];
        CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFMutableArrayRef recordsMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(records),records);
        
        CFArraySortValues(recordsMutable,
                          CFRangeMake(0, CFArrayGetCount(recordsMutable)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          kABPersonSortByFirstName);
        for (CFIndex i = 0; i < CFArrayGetCount(recordsMutable); i++)
        {
            NSMutableSet *contactSet = [NSMutableSet set];
            ABRecordRef record = CFArrayGetValueAtIndex(recordsMutable, i);
            [contactSet addObject:(__bridge id)record];
            NSArray *linkedRecordsArray = (__bridge NSArray *)ABPersonCopyArrayOfAllLinkedPeople(record);
            [contactSet addObjectsFromArray:linkedRecordsArray];
            NSString *firstNames = (__bridge NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
            NSString *lastNames =  (__bridge NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
            
            ABMultiValueRef multiEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                if([firstNames isEqualToString:@"(null)"])
                {
                    firstNames=@"";
                }
                if([lastNames isEqualToString:@"(null)"])
                {
                    lastNames=@"";
                }
                
                [contactName addObject:  [NSString stringWithFormat:@"%@ %@",firstNames,lastNames]];
                [contactEmails addObject:contactEmail];
                [emailContactSelected addObject:@"N"];
            }
            CFRelease(record);
        }
    }
}
-(void)readEmail
{
    [self openDB];
    NSString *sql =[NSString stringWithFormat:   @"Select distinct emailFrom  from Location"];
    contactEmailsFrom =   [[NSMutableArray alloc] init];
    [contactEmailsFrom addObject:@"Select an e-mail"];
    if (sqlite3_prepare_v2( appDB, [sql UTF8String], -1, &statement, nil) ==
        SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            [self checkNULL:(char *)sqlite3_column_text(statement ,0)];
            [contactEmailsFrom addObject:fieldText];
        }
    }
   // sqlite3_close(appDB);
    
}
- (IBAction)btnSelectFromContacts:(id)sender {
    [txtMessageIN   resignFirstResponder];
    [txtMessageOUT   resignFirstResponder];
    [txtEmailFrom   resignFirstResponder];
    [txtEmailTo   resignFirstResponder];
    [txtLocation   resignFirstResponder];
    viewPickerFrom.hidden=TRUE;
    viewSendEmail.hidden=FALSE;
    
}
- (IBAction)btnSendEmailsOK:(id)sender {
    
    viewSendEmail.hidden=true;
    viewPickerFrom.hidden=TRUE;
    self.txtEmailTo.text=@"";
    for (int xx=0; xx < emailContactSelected.count;xx++)
    {
        if([[emailContactSelected objectAtIndex:xx] isEqualToString:@"Y"])
        {
            if([self.txtEmailTo.text isEqualToString:@""])
            {
                self.txtEmailTo.text= [NSString stringWithFormat:@"%@",[contactEmails objectAtIndex:xx]];
            }
            else
            {
                self.txtEmailTo.text= [NSString stringWithFormat:@"%@,%@",txtEmailTo.text,[contactEmails objectAtIndex:xx]];
            }
        }
    }
}

- (IBAction)btnSave:(id)sender {
    char *err;
    [self openDB];
    NSString *sql =[NSString stringWithFormat:@"Insert into Location (Description, Address, City, State, Zip, NLat,NLon,WLat,WLon,SLat,SLon,ELat,ELon,emailTo,emailFrom,messageIN,messageOUT,enableLocation) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',1)", txtLocation.text , self.locationAddress, self.locationCity, self.locationState, self.locationZip, self.NLatDetail,self.NLonDetail,self.WLatDetail,self.WLonDetail,self.SLatDetail,self.SLonDetail,self.ELatDetail,self.ELonDetail,txtEmailTo.text,txtEmailFrom.text,txtMessageIN.text,txtMessageOUT.text];
    if (sqlite3_exec(appDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        
        [self openDB];
    }
   // sqlite3_close(appDB);
    
    [txtLocation resignFirstResponder];
      [self dismissViewControllerAnimated:TRUE completion:nil];
  //      [self performSegueWithIdentifier:@"ShowMenu" sender:self];
  
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"ShowMenu"]) {
  //      [segue.destinationViewController self];
 //   }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtLocation.delegate=self;
    viewSendEmail.hidden=TRUE;
    [self readEmail];
    [self getAllContacts];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
-(void)changeTableViewSize
{
    NSInteger numRow=(contactEmails.count);
    NSInteger cellSize=60*numRow;
    self.tableViewSendEmail.frame = CGRectMake(20,70, 500,cellSize) ;
    
    [tableViewSendEmail reloadData];
    
}
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactEmails.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return 0;
}



- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *unChecked = [UIImage imageNamed:@"checkedBlue.png"];
    UIImage *Checked = [UIImage imageNamed:@"checkedBlueCompleted.png"];
    
    
    static NSString *CellIdentifier = @"CustomCellSendEmail";
    CellSendEmail *cellEmail = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cellEmail == nil)
    {
        //Load custom cell from NIB file
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellSendEmail" owner:self options:NULL];
        cellEmail = (CellSendEmail *) [nib objectAtIndex:0];
        
    }
    cellEmail.lblEmailContactAddress.text = [NSString stringWithFormat:@"%@",[contactEmails objectAtIndex:indexPath.row]];
    cellEmail.lblContractorName.text = [NSString stringWithFormat:@"%@",[contactName objectAtIndex:indexPath.row]];
    NSString *selected=[NSString stringWithFormat:@"%@", [emailContactSelected objectAtIndex:indexPath.row]];
    if ( [selected  isEqualToString: @"Y"])
    {
        cellEmail.imgChecked.image= Checked;
        
    }
    else
    {
        cellEmail.imgChecked.image= unChecked;
    }
    //    UIView *selectionColor = [[UIView alloc] init];
    //    selectionColor.backgroundColor =[UIColor whiteColor];
    //   cellEmail.selectedBackgroundView = selectionColor;
    
    return cellEmail;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero] ;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //cell.backgroundColor= [UIColor whiteColor];
    
}
- (IBAction)testSendEmail:(id)sender {
    
    
    NSString *sendTo = [self convertHTML:txtEmailTo.text];
    NSString *sendFrom = [self convertHTML:txtEmailFrom.text];
    NSString *message = [self convertHTML:txtMessageIN.text];
    NSString *urlString =[NSString stringWithFormat:@"http://hubner-apps.com/igothere/sms.php?a=%@&b=%@&c=%@",sendFrom,sendTo,message];
    urlString=[urlString stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *results = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", results);
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [emailContactSelected  replaceObjectAtIndex:indexPath.row withObject:@"Y"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected=[NSString stringWithFormat:@"%@", [emailContactSelected objectAtIndex:indexPath.row]];
    [emailContactSelected  replaceObjectAtIndex:indexPath.row withObject:@"Y"];
    NSLog(@"%@",selected);
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
    if(selectedIndex > 0)
    {
        self.pickerViewFrom = [contactEmailsFrom objectAtIndex:selectedIndex];
        self.txtEmailFrom.text = [contactEmailsFrom objectAtIndex:selectedIndex];
    }
    viewPickerFrom.hidden=TRUE;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [contactEmailsFrom objectAtIndex:row];
}
- (NSString *)pickerView:(UIPickerView  *)pickerView textForRow:(NSInteger)row {
    return [contactEmailsFrom objectAtIndex:row];
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return contactEmailsFrom.count;
}
- (NSString*)convertHTML:(NSString *)textFormat
{
    
    
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"<" withString:@"%3c"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@">" withString:@"%3e"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"{" withString:@"%7b"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"}" withString:@"%7d"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"|" withString:@"%7c"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"^" withString:@"%5e"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"~" withString:@"%7e"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"[" withString:@"%5b"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"]" withString:@"%5d"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"`" withString:@"%60"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"," withString:@"%2c"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"*" withString:@"%2a"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\r\n" withString:@"%0d"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\r" withString:@"%0d"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"\n" withString:@"%0d"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
    NSString *str = @"\"";
    NSString *quotes =[str substringWithRange:NSMakeRange(0, 1)];
    textFormat= [self textClear:[NSString stringWithFormat:@"%@",textFormat ]];
    textFormat=[textFormat stringByReplacingOccurrencesOfString: quotes withString:@"%22"];
    str=@"\\";
    NSString *backSlash = [str substringWithRange:NSMakeRange(0, 1)];
    textFormat=[textFormat stringByReplacingOccurrencesOfString:backSlash withString:@"%5c"];
    return textFormat;
}
@end
