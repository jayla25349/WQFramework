//
//  WQFinderListVC.m
//  GameHelper
//
//  Created by 青秀斌 on 2016/12/29.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "WQFinderListVC.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQFinderListVC ()<UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSURL *> *fileURLs;
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@end

@implementation WQFinderListVC

- (instancetype)init {
    self = [super init];
    self.dirURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.dirURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.dirURL.lastPathComponent;
    
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
    NSError *error = nil;
    self.fileURLs = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.dirURL
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:&error] mutableCopy];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    } else {
        [self.tableView reloadData];
    }
}

/**********************************************************************/
#pragma mark - UITableViewDataSource
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSURL *fileURL = self.fileURLs[indexPath.row];
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileURL.path isDirectory:&isDirectory] && isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = fileURL.lastPathComponent;
    
    return cell;
}

/**********************************************************************/
#pragma mark - UITableViewDelegate
/**********************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *fileURL = self.fileURLs[indexPath.row];
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileURL.path isDirectory:&isDirectory] && isDirectory) {
        WQFinderListVC *vc = [[WQFinderListVC alloc] init];
        vc.dirURL = fileURL;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (!self.docController) {
            self.docController = [[UIDocumentInteractionController alloc] init];
            self.docController.delegate = self;
        }
        self.docController.URL = fileURL;
        if (![self.docController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES]) {
            [SVProgressHUD showErrorWithStatus:@"沒有程序可以打开要分享的文件"];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSURL *fileURL = self.fileURLs[indexPath.row];
        NSError *error = nil;
        
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:fileURL.path]) {
            if ([[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
                [self.fileURLs removeObject:fileURL];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [SVProgressHUD showErrorWithStatus:@"删除文件成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"不能删除该文件"];
        }
    }
}

/**********************************************************************/
#pragma mark - UIDocumentInteractionControllerDelegate
/**********************************************************************/

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}

@end

NS_ASSUME_NONNULL_END
