//
//  FDSQLiftNormalViewController.m
//  SQLift3
//
//  Created by asus on 16/7/11.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDSQLiftNormalViewController.h"
#import "FDSQLiftNormal.h"



@interface FDSQLiftNormalViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) FDSQLiftNormal *database;

@end



@implementation FDSQLiftNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"sql 正常模式测试");
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(getOneData)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    [self setTestData:300];
    
    [self getTestDataStartID:1 end:300];
}


- (void)getOneData
{
    NSArray *array = [self.database databaseSelectWithStart:1 end:2];
    
    [self.tableView beginUpdates];
    [self.dataSource insertObject:array[0] atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * const cellID = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *data = self.dataSource[indexPath.row];
    
    cell.textLabel.text = [data objectForKey:kName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:kName]];
    
    return cell;
}




- (void)setTestData:(NSInteger )count
{
     [self.database databaseCreateTable];
    
    for (int i=0; i<count; i++) {
        
        [self.database databaseInsertWithName:[NSString stringWithFormat:@"xiaomi%ld", (long)i] age:i];
        
    }
    
}

- (void)getTestDataStartID:(NSInteger )startID end:(NSInteger )endID
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[self.database databaseSelectWithStart:startID end:endID]];
    
    self.dataSource = arrayM;
    
}

- (FDSQLiftNormal *)database
{
    if (!_database) {
        _database = [[FDSQLiftNormal alloc] init];
        
    }
    
    return _database;
}

@end







