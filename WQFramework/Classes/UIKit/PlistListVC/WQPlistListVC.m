//
//  WQPlistListVC.m
//  GameHelper
//
//  Created by 青秀斌 on 16/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQPlistListVC.h"

@interface PlistItem : NSObject
@property (nonatomic, strong) NSString *key;
@property (nullable, nonatomic, strong) id value;
@end

@interface WQPlistListVC ()<UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary<NSString *, id> *plistDic;
@property (nonatomic, strong) NSArray<NSString *> *sortKeys;
@end

@implementation WQPlistListVC

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self reloadData];
}

- (void)reloadData {
    self.sortKeys = [self.plistDic allKeysSorted];
    [self.tableView reloadData];
}

/**********************************************************************/
#pragma mark - UITableViewDataSource
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *key = self.sortKeys[indexPath.row];
    id value = self.plistDic[key];
    
    cell.textLabel.text = key;
    if ([value isKindOfClass:[NSString class]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [value stringValue];
    } else if ([value isKindOfClass:[NSArray class]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"[数组]";
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [value stringValue];
        cell.detailTextLabel.text = @"[字典]";
    }
    
    return cell;
}

/**********************************************************************/
#pragma mark - UITableViewDelegate
/**********************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
