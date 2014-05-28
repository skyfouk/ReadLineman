//
//  LinemanListController.m
//  ReadLineman
//
//  Created by spring sky on 14-5-14.
//  Copyright (c) 2014年 spring sky. All rights reserved.
//

#import "LinemanListController.h"
#import <AddressBook/AddressBook.h>
#import "AboutMeController.h"

@interface LinemanListController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) IBOutlet UITableView* tableView;
@property (strong,nonatomic) IBOutlet UILabel* lineCountLabel;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView* activityView;
@property (strong,nonatomic) NSArray* linemanArray;

@property (strong,nonatomic) NSMutableDictionary* deleteArray;

@end

@implementation LinemanListController
{
    ABAddressBookRef addressBook;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deleteArray = [NSMutableDictionary new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关于我" style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    
    
   
    
    
//    [self loadLineman];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self clickRefresh:nil];
}

-(void) clickRight
{
    AboutMeController* aboutCtrl = [AboutMeController new];
    CATransition *transition = [CATransition animation];
	transition.duration =2.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = @"rippleEffect";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.navigationController pushViewController:aboutCtrl animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadLineman{
    
    CFErrorRef error = NULL;
    if(!addressBook){
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    }
    self.lineCountLabel.text = @"正在加载联系人信息....";
    self.activityView.hidden = NO;
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //查询所有
            [self filterContentForSearchText:@""];
            [self performSelectorOnMainThread:@selector(showLineman) withObject:nil waitUntilDone:YES];
        }
        
    });
}

-(void) viewDidUnload
{
    CFRelease(addressBook);
    [super viewDidUnload];
    
}

-(void) showLineman
{
    [self.tableView reloadData];
    self.activityView.hidden = YES;
    self.lineCountLabel.text = [NSString stringWithFormat:@"一共%ld个联系人",[self.linemanArray count]];
    CATransition *transition = [CATransition animation];
	transition.duration = 1.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = @"suckEffect";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

- (void)filterContentForSearchText:(NSString*)searchText

{
    //如果没有授权则退出
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        [self.view showActivityOnlyLabel:@"请授权访问通讯录再试" forSeconds:2.0f];
        return ;
        
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray* array = nil;
    if([searchText length]==0)
        
    {
        //查询所有
        array = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
        
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        array = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        CFRelease(cfSearchText);
        
    }
    self.linemanArray = array;
   
}

-(IBAction)clickRefresh:(id)sender
{
     [self performSelectorInBackground:@selector(loadLineman) withObject:nil];
}

-(IBAction)clickDelete:(id)sender
{
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSArray* keys = self.deleteArray.allKeys;
    int count = 0;
    for(NSString* key in keys){
        if([self.deleteArray[key] isEqual:@"1"]){
            ABRecordRef ref = CFArrayGetValueAtIndex(arrayRef, [key intValue]);
            ABAddressBookRemoveRecord(addressBook, ref, NULL);
            count+=1;
        }
    }
    //保存电话本
    ABAddressBookSave(addressBook, nil);
    //释放内存
    CFRelease(arrayRef);
    
    [self.view showActivityForFinish:[NSString stringWithFormat:@"太好了，删除%d个联系人！",count] delegate:nil];
    [self.deleteArray removeAllObjects];
    [self clickRefresh:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.linemanArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0f];
    }
    ABRecordRef thisPerson = CFBridgingRetain([self.linemanArray objectAtIndex:[indexPath row]]);
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    firstName = firstName != nil?firstName:@"";
    
    NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    lastName = lastName != nil?lastName:@"";
    
    ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
    
    NSArray* phoneNumberArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneNumberProperty));
    
    NSString* phoneNumer = [phoneNumberArray componentsJoinedByString:@" "];
    
    phoneNumer = phoneNumer != nil ? phoneNumer : @"空";
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"iPhone：%@",phoneNumer ];
    
    CFRelease(thisPerson);
    NSString* rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    if(self.deleteArray[rowKey] == nil){
        self.deleteArray[rowKey] = @"0";
    }
    
    cell.accessoryType = [self.deleteArray[rowKey] isEqualToString:@"1"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* rowKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    if(self.deleteArray[rowKey] == nil){
        self.deleteArray[rowKey] = @"0";
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if([self.deleteArray[rowKey] isEqual:@"1"]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.deleteArray[rowKey] = @"0";
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.deleteArray[rowKey] = @"1";
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
