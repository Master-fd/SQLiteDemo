//
//  FDSQLiftMTSViewController.m
//  SQLift3
//
//  Created by asus on 16/7/11.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDSQLiftMTSViewController.h"
#import "FDSQLiftMTS.h"



@interface FDSQLiftMTSViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) FDSQLiftMTS *database;

@end

@implementation FDSQLiftMTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"sql 多线程测试");
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(getOneData)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    [self setTestData:300];
    
    [self getTestDataStartID:1 end:300];
}


- (void)getOneData
{
    __weak typeof(self) _weakSelf = self;
    
    [self.database databaseSelectWithStart:1 end:2 didSelectBlock:^(NSArray *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_weakSelf.tableView beginUpdates];
            [_weakSelf.dataSource insertObject:data[0] atIndex:0];
            [_weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_weakSelf.tableView endUpdates];

        });
        
    }];
    
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
    if ([self.database databaseCreateTable]) {
        
        for (int i=0; i<count; i++) {
            [self.database databaseInsertWithName:[NSString stringWithFormat:@"xiaomi%ld", (long)i] age:i];
            
        }
    }
    
}

- (void)getTestDataStartID:(NSInteger )startID end:(NSInteger )endID
{
    __weak typeof(self) _weakSelf = self;
    
    [self.database databaseSelectWithStart:startID end:endID didSelectBlock:^(NSArray *data) {
        
        [_weakSelf refreshtableView:data];
        
    }];
    
}
- (void)refreshtableView:(NSArray *)data
{
     __weak typeof(self) _weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        _weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
        [_weakSelf.tableView reloadData];
    });
    
}
- (FDSQLiftMTS *)database
{
    if (!_database) {
        _database = [[FDSQLiftMTS alloc] init];
        
    }
    
    return _database;
}



@end
